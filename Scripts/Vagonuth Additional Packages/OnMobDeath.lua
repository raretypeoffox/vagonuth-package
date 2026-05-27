-- Script: OnMobDeath
-- Attribute: isActive
-- OnMobDeath() called on the following events:
-- OnMobDeath

-- Script Code:
-- Dependencies: TryAction, pdebug(), splitstring

MobDeath = MobDeath or {}
MobDeath.Queue = MobDeath.Queue or {}
MobDeath.LastCommand = MobDeath.LastCommand or ""
MobDeath.CommandCheck = MobDeath.CommandCheck or {}

BuffManager = BuffManager or {}
BuffManager.Queue = BuffManager.Queue or {}
BuffManager.CurrentCasting = BuffManager.CurrentCasting or nil
BuffManager.VerifyTimerID = BuffManager.VerifyTimerID or nil
BuffManager.LagTimerID = BuffManager.LagTimerID or nil
BuffManager.RetryTimerID = BuffManager.RetryTimerID or nil
BuffManager.LastScheduledAt = BuffManager.LastScheduledAt or 0

-- Mapping dictionary of commands to StatTable keys
local buffMap = {
  ["cast sanctuary"] = "Sanctuary",
  ["cast 'iron monk'"] = "Sanctuary",
  ["cast frenzy"] = "Frenzy",
  ["cast mystical"] = "Mystical",
  ["cast 'death shroud'"] = "DeathShroud",
  ["cast 'glorious conquest'"] = "GloriousConquest",
  ["cast 'artificer blessing'"] = "ArtificerBlessing",
  ["cast discordia"] = "Discordia",
  ["sneak"] = "Sneak",
  ["move hidden"] = "MoveHidden",
  ["cast intervention"] = "Intervention",
  ["cast 'ether link'"] = "EtherLink",
  ["cast 'ether warp'"] = "EtherWarp",
  ["cast 'dagger hand'"] = "DaggerHand",
  ["cast 'stone fist'"] = "StoneFist",
  ["cast 'gravitas'"] = "Gravitas",
  ["cast 'hive mind'"] = "HiveMind",
  ["cast 'illusory shield'"] = "IllusoryShield",
  ["cast 'sense weakness'"] = "SenseWeakness",
  ["cast 'kahbyss insight'"] = "KahbyssInsight",
  ["cast fervor"] = "Fervor",
  ["cast 'holy zeal'"] = "HolyZeal",
  ["cast 'kinetic chain'"] = "KineticChain",
  ["cast 'stunning weapon'"] = "StunningWeapon",
  ["cast savvy"] = "Savvy",
  ["cast 'wildmind'"] = "Wildmind",
  ["alertness"] = "Alertness",
  ["cast 'flow like water'"] = "FlowLikeWater",
  ["cast 'burning fury'"] = "BurningFury",
  ["stance echelon"] = "StanceEchelon",
  ["stance square"] = "StanceSquare",
  ["stance vampire fang"] = "VampireFang",
  ["stance spectral fang"] = "SpectralFang",
  ["cast 'sidereal reflections'"] = "SiderealReflections",
}

-- Keep MobDeath.UpdateCommandCheck for full compatibility with legacy code and other files
function MobDeath.UpdateCommandCheck()
  MobDeath.CommandCheck["cast sanctuary"] = StatTable.Sanctuary or 0
  MobDeath.CommandCheck["cast 'iron monk'"] = StatTable.Sanctuary or 0
  if (StatTable.Sanctuary == "continuous") then MobDeath.CommandCheck["cast sanctuary"] = 99 end
  MobDeath.CommandCheck["cast frenzy"] = StatTable.Frenzy or 0
  MobDeath.CommandCheck["cast mystical"] = StatTable.Mystical or 0
  MobDeath.CommandCheck["cast 'death shroud'"] = StatTable.DeathShroud or 0
  MobDeath.CommandCheck["cast 'glorious conquest'"] = StatTable.GloriousConquest or 0
  MobDeath.CommandCheck["cast 'artificer blessing'"] = StatTable.ArtificerBlessing or 0
  MobDeath.CommandCheck["cast discordia"] = StatTable.Discordia or 0

  MobDeath.CommandCheck["sneak"] = StatTable.Sneak or 0
  MobDeath.CommandCheck["move hidden"] = StatTable.MoveHidden or 0
  MobDeath.CommandCheck["cast intervention"] = StatTable.Intervention or 0
  MobDeath.CommandCheck["cast 'ether link'"] = StatTable.EtherLink or 0
  MobDeath.CommandCheck["cast 'ether warp'"] = StatTable.EtherWarp or 0
  
  MobDeath.CommandCheck["cast 'dagger hand'"] = StatTable.DaggerHand or 0
  MobDeath.CommandCheck["cast 'stone fist'"] = StatTable.StoneFist or 0
  
  MobDeath.CommandCheck["cast 'gravitas'"] = StatTable.Gravitas or 0
  MobDeath.CommandCheck["cast 'hive mind'"] = StatTable.HiveMind or 0
  MobDeath.CommandCheck["cast 'illusory shield'"] = StatTable.IllusoryShield or 0
  
  MobDeath.CommandCheck["cast 'sense weakness'"] = StatTable.SenseWeakness or 0
  MobDeath.CommandCheck["cast 'kahbyss insight'"] = StatTable.KahbyssInsight or 0
  
  -- Paladin
  if (GlobalVar.PrayerName ~= "") then
    MobDeath.CommandCheck["cast prayer '" .. GlobalVar.PrayerName .. "'"] = StatTable.Prayer or 0
  end
  MobDeath.CommandCheck["cast fervor"] = StatTable.Fervor or 0
  if (StatTable.Fervor == nil and StatTable.Frenzy ~= nil) then MobDeath.CommandCheck["cast fervor"] = StatTable.Frenzy end
  MobDeath.CommandCheck["cast 'holy zeal'"] = StatTable.HolyZeal or 0
  
  --Psi
  MobDeath.CommandCheck["cast 'kinetic chain'"] = StatTable.KineticChain or 0
  MobDeath.CommandCheck["cast 'stunning weapon'"] = StatTable.StunningWeapon or 0
  MobDeath.CommandCheck["cast savvy"] = StatTable.Savvy or 0
  
  -- Fyr
  MobDeath.CommandCheck["cast 'wildmind'"] = StatTable.Wildmind or 0
  
  -- Rogue-likes
  MobDeath.CommandCheck["alertness"] = StatTable.Alertness or 0
end

-- Returns the corresponding StatTable key for a given action string (handles targeted spells like "cast frenzy player")
function BuffManager.GetStatKeyForAction(action)
  if not action then return nil end
  local clean_action = string.lower(action)
  clean_action = string.gsub(clean_action, "%s+", " ")
  
  -- Check exact match or prefix match with space
  for cmd, statKey in pairs(buffMap) do
    if clean_action == cmd or string.sub(clean_action, 1, string.len(cmd) + 1) == cmd .. " " then
      return statKey
    end
  end
  return nil
end

-- Checks if the buff/effect for the action is currently active in StatTable
function BuffManager.IsActionActive(action)
  local statKey = BuffManager.GetStatKeyForAction(action)
  if not statKey then
    -- Non-buff commands (like instant transfers, quickcasts, stances with exhaust check elsewhere)
    -- are assumed to be "not active" and always execute
    return false
  end
  
  local val = StatTable[statKey]
  
  -- Special case for fervor/frenzy fallback
  if statKey == "Fervor" and val == nil and StatTable.Frenzy ~= nil then
    val = StatTable.Frenzy
  end
  
  if val == "continuous" or val == "yes" or val == true then
    return true
  end
  
  local num = tonumber(val)
  if num and num > 0 then
    return true
  end
  
  return false
end

-- Check if the queue already contains the specified action
function BuffManager.QueueContains(action)
  for _, item in ipairs(BuffManager.Queue) do
    if item.action == action then
      return true
    end
  end
  return false
end

-- Add action to the queue with a priority
function BuffManager.Add(action, priority)
  priority = priority or 1
  
  -- Strip leading/trailing whitespace
  action = string.gsub(action, "^%s*(.-)%s*$", "%1")
  if action == "" then return false end
  
  -- Prevent double queueing
  if BuffManager.QueueContains(action) then
    pdebug("BuffManager.Add(): Action already in queue: " .. action)
    return false
  end
  
  -- If the action is already active, don't queue it
  if BuffManager.IsActionActive(action) then
    pdebug("BuffManager.Add(): Action already active, not queueing: " .. action)
    return false
  end
  
  -- Specific check for cure blindness: if not blind, don't queue
  if action == "cast 'cure blindness'" and not StatTable.Blindness then
    pdebug("BuffManager.Add(): 'cure blindness' ignored, not blind")
    return false
  end
  
  local item = {
    action = action,
    priority = priority,
    added_at = os.clock(),
    retries = 0,
    max_retries = 3,
  }
  
  -- Insert into queue sorted by priority (higher priority first)
  local inserted = false
  for i, queued_item in ipairs(BuffManager.Queue) do
    if priority > queued_item.priority then
      table.insert(BuffManager.Queue, i, item)
      inserted = true
      break
    end
  end
  
  if not inserted then
    table.insert(BuffManager.Queue, item)
  end
  
  pdebug("BuffManager.Add(): Added to queue: " .. action .. " (Priority: " .. priority .. ")")
  
  -- Update legacy queue for any external code inspection
  MobDeath.Queue = {}
  for _, qi in ipairs(BuffManager.Queue) do
    table.insert(MobDeath.Queue, qi.action)
  end
  
  -- Process queue out of combat
  BuffManager.Process()
  return true
end

-- Clear the queue completely
function BuffManager.Clear(echo)
  if echo ~= false then echo = true end
  pdebug("BuffManager.Clear()")
  if echo then printGameMessageVerbose("BuffManager", "queue cleared") end
  
  BuffManager.Queue = {}
  BuffManager.CurrentCasting = nil
  MobDeath.Queue = {}
  MobDeath.LastCommand = ""
  
  if BuffManager.VerifyTimerID then killTimer(BuffManager.VerifyTimerID); BuffManager.VerifyTimerID = nil end
  if BuffManager.LagTimerID then killTimer(BuffManager.LagTimerID); BuffManager.LagTimerID = nil end
  if BuffManager.RetryTimerID then killTimer(BuffManager.RetryTimerID); BuffManager.RetryTimerID = nil end
end

-- Primary sequential execution loop
function BuffManager.Process()
  -- 1. Do not process if in combat
  if Battle.Combat then
    pdebug("BuffManager.Process(): Blocked - Currently in combat.")
    return
  end
  
  -- 2. Do not process if sleeping or resting
  if StatTable.Position == "Sleep" or StatTable.Position == "Rest" then
    pdebug("BuffManager.Process(): Blocked - Sleeping or resting.")
    return
  end
  
  -- 3. Do not process if already waiting on verification for an action
  if BuffManager.CurrentCasting then
    pdebug("BuffManager.Process(): Blocked - Currently verifying: " .. BuffManager.CurrentCasting.action)
    return
  end
  
  -- 4. Check if we have active lag
  local lag = tonumber(gmcp.Char.Vitals.lag) or 0
  if lag > 0 then
    if BuffManager.RetryTimerID and os.clock() - (BuffManager.LastScheduledAt or 0) < 0.05 then
      -- Already scheduled in the same execution frame, ignore silently
      return
    end
    
    pdebug("BuffManager.Process(): In lag (" .. lag .. "s). Scheduling process when lag ends.")
    if BuffManager.RetryTimerID then killTimer(BuffManager.RetryTimerID) end
    BuffManager.LastScheduledAt = os.clock()
    BuffManager.RetryTimerID = tempTimer(lag + 0.1, function() BuffManager.RetryTimerID = nil; BuffManager.Process() end)
    return
  end
  
  -- 5. Empty queue check
  if #BuffManager.Queue == 0 then
    return
  end
  
  -- Get the next item
  local item = BuffManager.Queue[1]
  
  -- Check if already active (could have been applied in between)
  if BuffManager.IsActionActive(item.action) then
    pdebug("BuffManager.Process(): Skipping already active action: " .. item.action)
    table.remove(BuffManager.Queue, 1)
    
    -- Sync legacy queue
    MobDeath.Queue = {}
    for _, qi in ipairs(BuffManager.Queue) do
      table.insert(MobDeath.Queue, qi.action)
    end
    
    BuffManager.Process()
    return
  end
  
  -- Specific check for cure blindness: if we got cured in the meantime, skip
  if item.action == "cast 'cure blindness'" and not StatTable.Blindness then
    table.remove(BuffManager.Queue, 1)
    
    -- Sync legacy queue
    MobDeath.Queue = {}
    for _, qi in ipairs(BuffManager.Queue) do
      table.insert(MobDeath.Queue, qi.action)
    end
    
    BuffManager.Process()
    return
  end
  
  -- Set active item and execute
  BuffManager.CurrentCasting = item
  MobDeath.LastCommand = item.action
  
  pdebug("BuffManager.Process(): Sending action: " .. item.action)
  printGameMessageVerbose("BuffManager", "Trying: " .. item.action)
  
  send(item.action)
  
  -- Schedule a short timer to let the server process the command and send back any GMCP lag
  if BuffManager.VerifyTimerID then killTimer(BuffManager.VerifyTimerID) end
  BuffManager.VerifyTimerID = tempTimer(0.2, function()
    BuffManager.VerifyTimerID = nil
    BuffManager.HandleFeedback(item)
  end)
end

-- Invoked 0.2s after sending an action to determine lag and schedule verification
function BuffManager.HandleFeedback(item)
  local lag = tonumber(gmcp.Char.Vitals.lag) or 0
  
  if lag > 0 then
    -- Command created lag. Wait for lag to finish, then check success.
    pdebug("BuffManager.HandleFeedback(): Action '" .. item.action .. "' registered with lag: " .. lag .. "s. Waiting to verify...")
    if BuffManager.LagTimerID then killTimer(BuffManager.LagTimerID) end
    BuffManager.LagTimerID = tempTimer(lag + 0.3, function()
      BuffManager.LagTimerID = nil
      BuffManager.VerifySuccess(item)
    end)
  else
    -- Command has no lag, or failed immediately. Verify success now.
    pdebug("BuffManager.HandleFeedback(): Action '" .. item.action .. "' registered with 0 lag. Verifying immediately...")
    BuffManager.VerifySuccess(item)
  end
end

-- Checks if the spell was successfully cast
function BuffManager.VerifySuccess(item)
  -- 1. Check if the action was aborted by an external trigger (like Not Enough Mana)
  -- These triggers clear MobDeath.LastCommand
  if MobDeath.LastCommand == "" then
    pdebug("BuffManager.VerifySuccess(): Action aborted by external trigger: " .. item.action)
    table.remove(BuffManager.Queue, 1)
    
    -- Sync legacy queue
    MobDeath.Queue = {}
    for _, qi in ipairs(BuffManager.Queue) do
      table.insert(MobDeath.Queue, qi.action)
    end
    
    BuffManager.CurrentCasting = nil
    BuffManager.Process()
    return
  end
  
  -- 2. Verify if the spell is now active in StatTable (for buffs)
  local is_active = BuffManager.IsActionActive(item.action)
  local statKey = BuffManager.GetStatKeyForAction(item.action)
  
  -- If it's a persistent buff, we check if it is active. 
  -- If it's an instant action (statKey is nil), we assume success after executing it.
  if is_active or (not statKey) then
    pdebug("BuffManager.VerifySuccess(): Success! Action completed: " .. item.action)
    table.remove(BuffManager.Queue, 1)
    
    -- Sync legacy queue
    MobDeath.Queue = {}
    for _, qi in ipairs(BuffManager.Queue) do
      table.insert(MobDeath.Queue, qi.action)
    end
    
    MobDeath.LastCommand = ""
    BuffManager.CurrentCasting = nil
    
    -- Cast next queued action
    BuffManager.Process()
  else
    -- 3. Verification failed (spell was failed, fizzled, concentration lost, etc.)
    item.retries = item.retries + 1
    pdebug("BuffManager.VerifySuccess(): Failure! Action not active: " .. item.action .. " (Retry: " .. item.retries .. "/" .. item.max_retries .. ")")
    
    if item.retries < item.max_retries then
      -- Schedule a retry after a small delay
      MobDeath.LastCommand = ""
      BuffManager.CurrentCasting = nil
      
      if BuffManager.RetryTimerID then killTimer(BuffManager.RetryTimerID) end
      BuffManager.RetryTimerID = tempTimer(1.0, function()
        BuffManager.RetryTimerID = nil
        BuffManager.Process()
      end)
    else
      -- Exceeded max retries, discard
      printGameMessage("BuffManager", "Action failed after max retries: " .. item.action)
      table.remove(BuffManager.Queue, 1)
      
      -- Sync legacy queue
      MobDeath.Queue = {}
      for _, qi in ipairs(BuffManager.Queue) do
        table.insert(MobDeath.Queue, qi.action)
      end
      
      MobDeath.LastCommand = ""
      BuffManager.CurrentCasting = nil
      
      BuffManager.Process()
    end
  end
end

-- Backward compatible legacy functions

function OnMobDeath()
  -- Legacy handler called when a mob dies
  pdebug("OnMobDeath() wrapper called")
  BuffManager.Process()
end

function OnMobDeathQueuePriority(command)
  BuffManager.Add(command, 2)
end

function OnMobDeathQueueClear(echo)
  BuffManager.Clear(echo)
end

function OnMobDeathQueue(command)
  BuffManager.Add(command, 1)
end

function OnMobDeathWake()
  pdebug("OnMobDeathWake() wrapper called")
  BuffManager.Process()
end
