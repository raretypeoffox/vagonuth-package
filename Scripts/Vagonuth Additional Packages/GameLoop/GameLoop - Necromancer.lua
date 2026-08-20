NecromancerGameLoop = NecromancerGameLoop or {}
local Nec = NecromancerGameLoop

Nec.Types = Nec.Types or {
  skeleton = 2,
  zombie = 3,
  bloated = 5,
  ghoul = 5,
  vampire = 6,
  ghost = 7,
}

Nec.TypeAliases = Nec.TypeAliases or {
  ["bloated one"] = "bloated",
}

Nec.Plan = Nec.Plan or nil
Nec.RoomCorpses = {}
Nec.RecentAbominations = {}
Nec.PendingLoot = {}
Nec.HandledLoot = {}
Nec.RitualPendingIds = {}
Nec.BloodCurseAttempts = {}
Nec.WeaponAttempts = {}
Nec.LootSerial = Nec.LootSerial or 0
Nec.RoomListPending = false

local function trim(value)
  return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function key(value)
  return trim(value):lower():gsub("%s+", " ")
end

function Nec.CanonicalType(value)
  local normalized = key(value)
  return Nec.TypeAliases[normalized] or normalized
end

local function isNecromancer()
  return StatTable and StatTable.Class == "Necromancer"
end

local function now()
  return os.clock()
end

local function weaponNow()
  return os.time()
end

local function itemPayload(name)
  local items = gmcp and gmcp.Char and gmcp.Char.Items
  return items and items[name]
end

local function printNec(message)
  if type(printMessage) == "function" then
    printMessage("Necromancer", message)
  elseif type(print) == "function" then
    print(message)
  end
end

function Nec.ClearWeaponTracking()
  if Nec.Plan and Nec.Plan.WeaponKeyword and type(TryActionSet) == "table" then
    for serial, _ in pairs(Nec.WeaponAttempts) do
      TryActionSet[string.format("give %s %s", Nec.Plan.WeaponKeyword, serial)] = nil
    end
  end
  Nec.WeaponAttempts = {}
  safeKillTimer("NecromancerWeaponReconcile")
  safeKillTimer("TryLock-NecromancerWeaponGive")
  if type(TryLockSet) == "table" then TryLockSet.NecromancerWeaponGive = nil end
end

function Nec.ResetSession()
  Nec.ClearWeaponTracking()
  Nec.Plan = nil
  Nec.RoomCorpses = {}
  safeKillTimer("NecromancerRoomListRequest")
  for serial, _ in pairs(Nec.PendingLoot) do
    safeKillTimer("NecromancerLootFallback" .. serial)
  end
  Nec.RecentAbominations = {}
  Nec.PendingLoot = {}
  Nec.HandledLoot = {}
  Nec.RitualPendingIds = {}
  Nec.BloodCurseAttempts = {}
  Nec.RoomListPending = false
end

function Nec.DisablePlan()
  Nec.ClearWeaponTracking()
  Nec.Plan = nil
end

function Nec.ParsePlan(args)
  local words = {}
  for word in trim(args):gmatch("%S+") do table.insert(words, word) end
  if #words < 3 then return nil, "Syntax: abom <type> <name> <max_weight> [weapon_keyword]" end

  local abomType
  local nameIndex
  local firstTwo = key((words[1] or "") .. " " .. (words[2] or ""))
  if firstTwo == "bloated one" then
    abomType = "bloated"
    nameIndex = 3
  else
    abomType = Nec.CanonicalType(words[1])
    nameIndex = 2
  end

  local targetIndex = nameIndex + 1
  if #words ~= targetIndex and #words ~= targetIndex + 1 then
    return nil, "Syntax: abom <type> <name> <max_weight> [weapon_keyword]"
  end

  local target = tonumber(words[targetIndex])
  if not target or target % 1 ~= 0 or target <= 0 then
    return nil, "max_weight must be a positive whole number."
  end

  if not Nec.Types[abomType] then
    return nil, "Unknown abomination type: " .. tostring(words[1])
  end

  local name = words[nameIndex]
  if not name or name == "" or name:find("[^%w_%-]") then
    return nil, "The abomination name contains unsafe characters."
  end

  local weapon = words[targetIndex + 1]
  if weapon and (weapon == "" or weapon:find("[^%w_%-]")) then
    return nil, "The weapon keyword must be one safe word."
  end

  return {
    Type = abomType,
    Name = name,
    Weight = Nec.Types[abomType],
    Target = target,
    WeaponKeyword = weapon,
  }
end

function Nec.Configure(plan)
  if not isNecromancer() then return false, "This command is only available to Necromancers." end
  local state = StatTable.Necromancer
  if not state or (tonumber(state.MaxAbominationWeight) or 0) <= 0 then
    return false, "Necromancer GMCP capacity is not available yet."
  end
  if plan.Target > tonumber(state.MaxAbominationWeight) then
    return false, "max_weight exceeds your current abomination capacity."
  end
  if plan.Target < plan.Weight then
    return false, "max_weight is smaller than the selected abomination's weight."
  end
  Nec.ClearWeaponTracking()
  Nec.Plan = plan
  return true
end

function Nec.CurrentNeed()
  if not Nec.Plan or not StatTable.Necromancer then return 0 end
  local current = tonumber(StatTable.Necromancer.AbominationWeight) or 0
  return math.floor(math.max(0, Nec.Plan.Target - current) / Nec.Plan.Weight)
end

function Nec.ShowStatus()
  if not Nec.Plan then
    printNec("No abomination maintenance plan is active. Syntax: abom <type> <name> <max_weight> [weapon_keyword]")
    return
  end
  local state = StatTable.Necromancer or {}
  local current = tonumber(state.AbominationWeight) or 0
  printNec(string.format(
    "Abom plan: %s named %s, target %d weight; current %d/%d, need %d; weapon: %s.",
    Nec.Plan.Type, Nec.Plan.Name, Nec.Plan.Target, current,
    tonumber(state.MaxAbominationWeight) or 0, Nec.CurrentNeed(),
    Nec.Plan.WeaponKeyword or "none"
  ))
end

function Nec.RegisterRoomCorpse(item)
  if type(item) ~= "table" or not item.id then return end
  local id = tostring(item.id)
  Nec.RoomCorpses[id] = {
    id = id,
    name = tostring(item.name or ""),
    added_at = now(),
    loot_handled = Nec.HandledLoot[id] == true,
    ritual_pending = Nec.RitualPendingIds[id] == true,
  }
end

function Nec.OnItemAdd()
  local payload = itemPayload("Add")
  if type(payload) ~= "table" or payload.location ~= "room" or type(payload.item) ~= "table" then return end
  if payload.item.type ~= "npc corpse" then return end
  Nec.RegisterRoomCorpse(payload.item)
  Nec.ResolvePendingLoot()
end

function Nec.OnItemRemove()
  local payload = itemPayload("Remove")
  if type(payload) ~= "table" or type(payload.item) ~= "table" or not payload.item.id then return end
  Nec.RoomCorpses[tostring(payload.item.id)] = nil
  Nec.RitualPendingIds[tostring(payload.item.id)] = nil
end

function Nec.OnItemList()
  local payload = itemPayload("List")
  if type(payload) ~= "table" or payload.location ~= "room" then return end
  safeKillTimer("NecromancerRoomListRequest")
  Nec.RoomListPending = false
  Nec.RoomCorpses = {}
  for _, item in ipairs(payload.items or {}) do
    if item.type == "npc corpse" then Nec.RegisterRoomCorpse(item) end
  end
  Nec.ResolvePendingLoot()
  Nec.MaintainAbominations(true)
end

function Nec.OnRoomChange()
  Nec.RoomCorpses = {}
  safeKillTimer("NecromancerRoomListRequest")
  Nec.RoomListPending = false
  for serial, _ in pairs(Nec.PendingLoot) do
    safeKillTimer('NecromancerLootFallback' .. serial)
  end
  Nec.PendingLoot = {}
  Nec.HandledLoot = {}
  Nec.RitualPendingIds = {}
end

local function abominationKey(abomType, name)
  return Nec.CanonicalType(abomType) .. "|" .. key(name)
end

function Nec.SyncAbominations()
  if not isNecromancer() then return end
  local state = StatTable.Necromancer
  local presentWeaponless = {}
  for _, abom in ipairs(state and state.Abominations or {}) do
    local k = abominationKey(abom.Type, abom.Name)
    Nec.RecentAbominations[k] = { Type = Nec.CanonicalType(abom.Type), Name = abom.Name, seen_at = now() }
    local serial = tostring(abom.SerialNumber or "")
    if serial ~= "" and not abom.Weapon then
      presentWeaponless[serial] = true
    else
      Nec.WeaponAttempts[serial] = nil
    end
  end
  for serial, _ in pairs(Nec.WeaponAttempts) do
    if not presentWeaponless[serial] then Nec.WeaponAttempts[serial] = nil end
  end
end

local function planMatchesAbomination(abom)
  if not Nec.Plan or Nec.CanonicalType(abom.Type) ~= Nec.Plan.Type then return false end
  local abomName = key(abom.Name)
  local wantedName = key(Nec.Plan.Name)
  if abomName == wantedName then return true end
  local suffix = "named " .. wantedName
  return wantedName ~= "" and #abomName >= #suffix and abomName:sub(-#suffix) == suffix
end

function Nec.ReconcileWeapons()
  local plan = Nec.Plan
  if not isNecromancer() or not plan or not plan.WeaponKeyword then return false end
  if Battle and Battle.Combat then return false end
  if type(SafeArea) == "function" and SafeArea() then return false end
  if not StatTable or StatTable.Position ~= "Stand" then return false end
  local vitals = gmcp and gmcp.Char and gmcp.Char.Vitals
  if not vitals or tonumber(vitals.lag) ~= 0 then return false end

  local state = StatTable.Necromancer
  for _, abom in ipairs(state and state.Abominations or {}) do
    local serial = tostring(abom.SerialNumber or "")
    if planMatchesAbomination(abom) and not abom.Weapon and serial:match("^%d+$") then
      local attempt = Nec.WeaponAttempts[serial]
      if attempt and attempt.Attempts >= 3 then
        if not attempt.Reported and weaponNow() - attempt.LastAttempt >= 10 then
          printNec(string.format("Could not give %s to abomination %s after three attempts.", plan.WeaponKeyword, serial))
          attempt.Reported = true
        end
      elseif not attempt or weaponNow() - attempt.LastAttempt >= 10 then
        if type(TryLock) ~= "function" or not TryLock("NecromancerWeaponGive", 10) then return false end
        local command = string.format("give %s %s", plan.WeaponKeyword, serial)
        if type(TryAction) == "function" and TryAction(command, 10) then
          Nec.WeaponAttempts[serial] = {
            Attempts = (attempt and attempt.Attempts or 0) + 1,
            LastAttempt = weaponNow(),
            Reported = false,
          }
          return true
        end
        return false
      end
    end
  end
  return false
end

function Nec.RequestWeaponReconciliation()
  if not isNecromancer() or not Nec.Plan or not Nec.Plan.WeaponKeyword then return end
  safeTempTimer("NecromancerWeaponReconcile", 0.75, function()
    Nec.ReconcileWeapons()
  end)
end

function Nec.IsOwnedAbomination(abomType, name)
  abomType = Nec.CanonicalType(abomType)
  if Nec.Plan and Nec.Plan.Type == abomType and key(Nec.Plan.Name) == key(name) then
    return true
  end
  Nec.SyncAbominations()
  local owned = Nec.RecentAbominations[abominationKey(abomType, name)]
  return owned and (now() - owned.seen_at) <= 30
end

local function corpseMatches(corpse, abomType, name)
  local corpseName = key(corpse.name)
  local wantedName = key(name)
  if wantedName ~= "" and corpseName:find(wantedName, 1, true) then return true end

  local wantedType = Nec.CanonicalType(abomType)
  return wantedType ~= "" and corpseName:find(wantedType, 1, true) ~= nil
end
function Nec.FindCorpse(abomType, name)
  local best
  for _, corpse in pairs(Nec.RoomCorpses) do
    if not corpse.loot_handled and corpseMatches(corpse, abomType, name) then
      if not best or corpse.added_at > best.added_at then best = corpse end
    end
  end
  return best
end

function Nec.LootCorpse(corpse, fallback)
  if (not fallback and not corpse) or (corpse and not fallback and Nec.HandledLoot[corpse.id]) then return false end
  local command = fallback and "get all corpse" or ("get all " .. corpse.id)
  local lag = tonumber(gmcp and gmcp.Char and gmcp.Char.Vitals and gmcp.Char.Vitals.lag) or 0
  local shouldQueue = (Battle and Battle.Combat) or lag > 0
  local sent = false
  if shouldQueue and type(TryQueuePriority) == "function" then
    sent = TryQueuePriority(command, 3)
  elseif type(TryAction) == "function" then
    sent = TryAction(command, 3)
  elseif type(send) == "function" then
    send(command)
    sent = true
  end
  if sent and corpse and corpse.id then
    corpse.loot_handled = true
    Nec.HandledLoot[corpse.id] = true
  end
  return sent
end

function Nec.TryLootFallback(serial)
  local pending = Nec.PendingLoot[serial]
  if not pending then return end

  local corpse = Nec.FindCorpse(pending.Type, pending.Name)
  if corpse and Nec.LootCorpse(corpse, false) then
    Nec.PendingLoot[serial] = nil
    return
  end

  if Nec.LootCorpse(nil, true) then
    Nec.PendingLoot[serial] = nil
    return
  end

  pending.FallbackAttempts = (pending.FallbackAttempts or 0) + 1
  if pending.FallbackAttempts >= 5 then
    Nec.PendingLoot[serial] = nil
    return
  end

  safeTempTimer("NecromancerLootFallback" .. serial, 1, function()
    Nec.TryLootFallback(serial)
  end)
end

function Nec.ResolvePendingLoot()
  for serial, pending in pairs(Nec.PendingLoot) do
    local corpse = Nec.FindCorpse(pending.Type, pending.Name)
    if corpse and Nec.LootCorpse(corpse, false) then
      Nec.PendingLoot[serial] = nil
      safeKillTimer("NecromancerLootFallback" .. serial)
    end
  end
end

function Nec.OnAbominationDeath(abomType, name)
  if not isNecromancer() then return end
  abomType = Nec.CanonicalType(abomType)
  if not Nec.IsOwnedAbomination(abomType, name) then return end

  local corpse = Nec.FindCorpse(abomType, name)
  if corpse and Nec.LootCorpse(corpse, false) then return end

  Nec.LootSerial = Nec.LootSerial + 1
  local serial = Nec.LootSerial
  Nec.PendingLoot[serial] = { Type = abomType, Name = name }
  safeTempTimer("NecromancerLootFallback" .. serial, 1, function()
    Nec.TryLootFallback(serial)
  end)
end

function Nec.NextBloodCurse()
  if not isNecromancer() or not GlobalVar.AutoCast or not Battle.Combat then return end
  local hp = tonumber(StatTable.current_health) or 0
  local maxhp = tonumber(StatTable.max_health) or 0
  if maxhp <= 0 or hp / maxhp >= 0.85 then return end
  local status = gmcp and gmcp.Char and gmcp.Char.Status or {}
  local opponent = trim(status.opponent_name)
  if opponent == "" or Nec.BloodCurseAttempts[opponent] then return end
  local lag = 5 * (Battle.GetSpellLagMod and Battle.GetSpellLagMod() or 1)
  if GlobalVar.QuickenStatus and tonumber(StatTable.Quicken) then
    lag = lag * (1 - (tonumber(StatTable.Quicken) / 18))
  end
  Nec.BloodCurseAttempts[opponent] = true
  return "cast 'blood curse'", lag
end

function Nec.RequestRoomItems()
  if Nec.RoomListPending or type(sendGMCP) ~= "function" then return false end
  Nec.RoomListPending = true
  safeTempTimer("NecromancerRoomListRequest", 5, function()
    Nec.RoomListPending = false
  end)
  sendGMCP("Char.Items.Room")
  return true
end

function Nec.MaintainAbominations(roomListCurrent)
  if not isNecromancer() or not Nec.Plan or Battle.Combat then return end
  if type(SafeArea) == "function" and SafeArea() then return end
  if StatTable.Position ~= "Stand" or tonumber(gmcp.Char.Vitals.lag) ~= 0 then return end
  local state = StatTable.Necromancer
  if not state then return end
  local current = tonumber(state.AbominationWeight) or 0
  local capacity = tonumber(state.MaxAbominationWeight) or 0
  if current + Nec.Plan.Weight > math.min(Nec.Plan.Target, capacity) then return end
  local maxhp = tonumber(StatTable.max_health) or 0
  local hp = tonumber(StatTable.current_health) or 0
  local ritualCost = maxhp * 0.05 * Nec.Plan.Weight
  if maxhp <= 0 or hp - ritualCost < maxhp * 0.25 then return end
  local corpse
  for _, candidate in pairs(Nec.RoomCorpses) do
    if not candidate.ritual_pending and not Nec.RitualPendingIds[candidate.id] then corpse = candidate break end
  end
  if not corpse then
    if not roomListCurrent then Nec.RequestRoomItems() end
    return
  end
  local command = string.format("cast 'unholy ritual' %s %s", Nec.Plan.Type, Nec.Plan.Name)
  local sent = type(TryCast) == "function" and TryCast(command, 5) or false
  if sent then
    corpse.ritual_pending = true
    Nec.RitualPendingIds[corpse.id] = true
  end
end

function Nec.GameLoop()
  Nec.SyncAbominations()
  if not Battle.Combat then
    local weaponSent = Nec.ReconcileWeapons()
    if not weaponSent then Nec.MaintainAbominations() end
  end
end

safeEventHandler("NecromancerGameLoop.ItemsAdd", "gmcp.Char.Items.Add", Nec.OnItemAdd, false)
safeEventHandler("NecromancerGameLoop.ItemsRemove", "gmcp.Char.Items.Remove", Nec.OnItemRemove, false)
safeEventHandler("NecromancerGameLoop.ItemsList", "gmcp.Char.Items.List", Nec.OnItemList, false)
safeEventHandler("NecromancerGameLoop.Vitals", "gmcp.Char.Vitals", Nec.SyncAbominations, false)
safeEventHandler("NecromancerGameLoop.Room", "gmcp.Room.Info", Nec.OnRoomChange, false)
safeEventHandler("NecromancerGameLoop.EndCombat", "EndCombat", function() Nec.BloodCurseAttempts = {} end, false)
safeEventHandler("NecromancerGameLoop.Profile", "CustomProfileInit", Nec.ResetSession, false)
safeEventHandler("NecromancerGameLoop.Disconnect", "sysDisconnectionEvent", Nec.ResetSession, false)
