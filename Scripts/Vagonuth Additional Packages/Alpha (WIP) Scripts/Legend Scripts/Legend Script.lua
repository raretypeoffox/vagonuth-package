-- Script: Legend Script
-- Attribute: isActive

-- Script Code:
Legend = Legend or {}
Legend.Init = Legend.Init or {}

function Legend.Init.ApplyCasterSettings()
  if not Legend.HasLore then return false end

  if Legend.HasLore("epic wizardry") then
    GlobalVar.SurgeLevel = 5
    GlobalVar.AutoCaster = "signature spell"
    GlobalVar.AutoCasterSingle = "signature spell"
    GlobalVar.AutoCasterAOE = "inferno"
    GlobalVar.QuickenStatus = false
    AutoCastON()
    if AutoCastSetGUI then AutoCastSetGUI() end
    printGameMessage("Legend Lore", "Epic wizardry spells set", "cyan", "white")
    return true
  end

  if Legend.HasLore("basic wizardry") then
    GlobalVar.SurgeLevel = 5
    GlobalVar.AutoCaster = "fireball"
    GlobalVar.AutoCasterSingle = "fireball"
    GlobalVar.AutoCasterAOE = "acid blast"
    GlobalVar.QuickenStatus = false
    AutoCastON()
    if AutoCastSetGUI then AutoCastSetGUI() end
    printGameMessage("Legend Lore", "Basic wizardry spells set", "cyan", "white")
    return true
  end

  return false
end

function Legend.Init.ApplyLoreSettings()
  return Legend.Init.ApplyCasterSettings()
end

function Legend.Init.Run()
  if not Legend.Lore or Legend.Lore.IsCapturing then return end

  Legend.Init.ApplyLoreSettings()
end

safeEventHandler("Legend.Init.OnLegendLore", "OnLegendLore", function()
  Legend.Init.Run()
end)

Legend.SpellUp = Legend.SpellUp or {}
Legend.SpellUp.Pending = false
Legend.SpellUp.HighMagick = Legend.SpellUp.HighMagick or "attenuation"
Legend.SpellUp.Pantheon = Legend.SpellUp.Pantheon or "discordia"
Legend.SpellUp.KineticWeapon = Legend.SpellUp.KineticWeapon or nil
Legend.SpellUp.Boon = Legend.SpellUp.Boon or nil
Legend.SpellUp.Sneak = Legend.SpellUp.Sneak or nil

Legend.SpellUp.Buffs = {
  -- Core spellup / travel
  { spell = "aegis", command = "cast aegis", statKey = "Sanctuary", alsoStatKeys = { "Awen", "Invincibility" }, priority = 110, final = true, lores = { "basic piety", "greater chivalry" } },
  { spell = "awen", command = "cast awen", statKey = "Sanctuary", alsoStatKeys = { "Awen" }, priority = 108, final = true, lores = { "basic theology" } },
  { spell = "iron monk", command = "cast 'iron monk'", statKey = "Sanctuary", priority = 105, final = true, lores = { "basic empty hand" } },
  { spell = "sanctuary", command = "cast sanctuary", statKey = "Sanctuary", priority = 100, final = true, lores = { "basic theology" } },
  { spell = "fortitudes", command = "cast fortitudes", statKey = "Fortitude", priority = 85, lores = { "basic psionics" } },
  { spell = "foci", command = "cast foci", statKey = "Foci", priority = 80, lores = { "basic magic" } },
  { spell = "holy sight", command = "cast 'holy sight'", statKey = "HolySight", priority = 78, lores = { "basic theology" } },
  { spell = "invincibility", command = "cast invincibility", statKey = "Invincibility", priority = 77, lores = { "basic theology" } },
  { spell = "fly", command = "cast fly", statKey = "Fly", priority = 75, lores = { "basic magic", "basic theology" } },
  { spell = "water breathing", command = "cast 'water breathing'", statKey = "WaterBreathing", priority = 70, lores = { "basic magic", "basic theology" } },
  { spell = "improved invis", command = "cast 'improved invis'", statKey = "Invis", priority = 66, lores = { "greater magic", "greater wizardry", "greater stormlore", "greater psionics", "greater mysticism", "greater theology", "greater chivalry", "greater warcraft", "greater empty hand", "greater shadowlore", "greater archery", "greater ballistics" } },
  { spell = "mass invis", command = "cast 'mass invis'", statKey = "Invis", priority = 65, lores = { "basic magic", "basic theology" } },
  { spell = "invis", command = "cast invis", statKey = "Invis", priority = 64, lores = { "basic magic", "basic theology" } },
  { spell = "detect haven", command = "cast 'detect haven'", statKey = "DetectHaven", priority = 30, lores = { "greater stormlore", "greater psionics", "basic piety", "greater warcraft", "greater empty hand", "greater archery", "greater ballistics", "greater mysticism", "greater theology", "greater chivalry" } },
  { spell = "concentrate", command = "cast concentrate", statKey = "Concentrate", priority = 60, lores = { "basic empty hand" } },
  { spell = "barkskin", command = "cast barkskin", statKey = "Barkskin", priority = 58, lores = { "greater wizardry", "lesser mysticism" } },
  { spell = "steel skeleton", command = "cast 'steel skeleton'", statKey = "SteelSkeleton", priority = 57, lores = { "basic psionics" } },
  { spell = "iron skin", command = "cast 'iron skin'", statKey = "IronSkin", priority = 56, lores = { "basic psionics" } },
  { spell = "dark embrace", command = "cast 'dark embrace'", statKey = "DarkEmbrace", priority = 54, lores = { "basic sorcery" } },
  { spell = "death shroud", command = "cast 'death shroud'", statKey = "DeathShroud", priority = 53, lores = { "basic sorcery", "greater chivalry", "epic theology" } },
  { spell = "werrebocler", command = "cast werrebocler", statKey = "Werrebocler", priority = 52, lores = { "epic warcraft", "epic empty hand", "epic shadowlore" } },
  { spell = "protection good", command = "cast 'protection good'", statKey = "ProtectionGood", priority = 20, lores = { "basic theology" }, condition = function() return (StatTable.Alignment or 0) < 300 end },
  { spell = "protection evil", command = "cast 'protection evil'", statKey = "ProtectionEvil", priority = 20, lores = { "basic theology" }, condition = function() return (StatTable.Alignment or 0) > 300 end },

  -- Caster and lore-specialized buffs
  { spell = "savvy", command = "cast savvy", statKey = "Savvy", priority = 50, lores = { "greater magic", "lesser psionics" } },
  { spell = "mystical barrier", command = "cast mystical", statKey = "Mystical", priority = 49, lores = { "lesser magic", "lesser wizardry" } },
  { spell = "ether link", command = "cast 'ether link'", statKey = "EtherLink", priority = 48, lores = { "greater wizardry" } },
  { spell = "vile philosophy", command = "cast 'vile philosophy'", statKey = "VilePhilosophy", priority = 47, lores = { "greater sorcery" } },
  { spell = "defiled flesh", command = "cast 'defiled flesh'", statKey = "DefiledFlesh", priority = 46, lores = { "lesser sorcery" } },
  { spell = "summon necrit", command = "cast 'summon necrit'", statKey = "SummonNecrit", priority = 45, lores = { "basic sorcery" } },
  { spell = "kinetic chain", command = "cast 'kinetic chain'", statKey = "KineticChain", priority = 44, lores = { "lesser psionics" } },
  { spell = "gravitas", command = "cast 'gravitas'", statKey = "Gravitas", priority = 43, lores = { "greater psionics" } },
  { spell = "minds eye", command = "cast 'minds eye'", statKey = "MindsEye", priority = 42, lores = { "lesser psionics" } },
  { spell = "wildmind", command = "cast 'wildmind'", statKey = "Wildmind", priority = 41, lores = { "basic derangement" } },
  { spell = "attenuation", command = "cast attenuation", statKey = "Attenuation", exclusiveGroup = "HighMagick", priority = 27, lores = { "basic magic" } },
  { spell = "planar modulation", command = "cast 'planar modulation'", statKey = "PlanarModulation", exclusiveGroup = "HighMagick", priority = 27, lores = { "greater magic" } },
  { spell = "arcana harvesting", command = "cast 'arcana harvesting'", statKey = "ArcanaHarvesting", exclusiveGroup = "HighMagick", priority = 27, lores = { "greater magic" } },
  { spell = "antimagic feedback", command = "cast 'antimagic feedback'", statKey = "AntimagicFeedback", exclusiveGroup = "HighMagick", priority = 27, lores = { "greater magic" } },
  { spell = "brittle", command = "cast brittle", statKey = "Brittle", exclusiveGroup = "HighMagick", priority = 27, lores = { "greater magic" } },
  { spell = "sympathetic resonance", command = "cast 'sympathetic resonance'", statKey = "SympatheticResonance", exclusiveGroup = "HighMagick", priority = 27, lores = { "greater magic" } },
  { spell = "stunning weapon", command = "cast 'stunning weapon'", statKey = "StunningWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "lesser psionics" } },
  { spell = "distracting weapon", command = "cast 'distracting weapon'", statKey = "DistractingWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "greater psionics" } },
  { spell = "disabling weapon", command = "cast 'disabling weapon'", statKey = "DisablingWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "greater psionics" } },
  { spell = "restricting weapon", command = "cast 'restricting weapon'", statKey = "RestrictingWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "greater psionics" } },
  { spell = "felling weapon", command = "cast 'felling weapon'", statKey = "FellingWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "greater psionics" } },
  { spell = "conscious weapon", command = "cast 'conscious weapon'", statKey = "ConsciousWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "greater psionics" } },
  { spell = "intelligent weapon", command = "cast 'intelligent weapon'", statKey = "IntelligentWeapon", exclusiveGroup = "KineticWeapon", priority = 26, lores = { "greater psionics" } },
  { spell = "glorious conquest", command = "cast 'glorious conquest'", statKey = "GloriousConquest", exclusiveGroup = "Pantheon", priority = 25, lores = { "greater theology" } },
  { spell = "hallowed nimbus", command = "cast 'hallowed nimbus'", statKey = "HallowedNimbus", exclusiveGroup = "Pantheon", priority = 25, lores = { "lesser theology" } },
  { spell = "artificer blessing", command = "cast 'artificer blessing'", statKey = "ArtificerBlessing", exclusiveGroup = "Pantheon", priority = 25, lores = { "lesser theology" } },
  { spell = "unholy rampage", command = "cast 'unholy rampage'", statKey = "UnholyRampage", exclusiveGroup = "Pantheon", priority = 25, lores = { "lesser theology" } },
  { spell = "sylvan benediction", command = "cast 'sylvan benediction'", statKey = "SylvanBenediction", exclusiveGroup = "Pantheon", priority = 25, lores = { "lesser theology" } },
  { spell = "grim harvest", command = "cast 'grim harvest'", statKey = "GrimHarvest", exclusiveGroup = "Pantheon", priority = 25, lores = { "greater theology" } },
  { spell = "discordia", command = "cast discordia", statKey = "Discordia", exclusiveGroup = "Pantheon", priority = 25, lores = { "lesser theology" } },
  { spell = "divine grace", command = "cast 'divine grace'", statKey = "DivineGrace", exclusiveGroup = "Pantheon", priority = 25, lores = { "greater theology" } },
  { spell = "protective vigil", command = "cast 'protective vigil'", statKey = "ProtectiveVigil", exclusiveGroup = "Pantheon", priority = 25, lores = { "lesser theology" } },
  { spell = "divine adjutant", command = "cast 'divine adjutant'", statKey = "DivineAdjutant", exclusiveGroup = "Pantheon", priority = 25, lores = { "greater theology" } },
  { spell = "shadow form", command = "shadow form", statKey = "Sneak", exclusiveGroup = "Sneak", priority = 24, lores = { "basic psionics" } },
  { spell = "sneak", command = "sneak", statKey = "Sneak", exclusiveGroup = "Sneak", priority = 23, lores = { "basic subterfuge", "basic assassination" } },
  { spell = "move hidden", command = "move hidden", statKey = "MoveHidden", priority = 22, lores = { "basic subterfuge", "basic assassination" } },

  -- Paladin/chivalry-style buffs
  { spell = "fervor", command = "cast fervor", statKey = "Frenzy", exclusiveGroup = "Frenzy", priority = 41, lores = { "basic chivalry" } },
  { spell = "holy zeal", command = "cast 'holy zeal'", statKey = "HolyZeal", priority = 39, lores = { "basic chivalry" } },
  { spell = "joined boon", command = "cast 'joined boon'", statKey = "JoinedBoon", exclusiveGroup = "Boon", priority = 38, lores = { "lesser chivalry" } },
  { spell = "heroic boon", command = "cast 'heroic boon'", statKey = "HeroicBoon", exclusiveGroup = "Boon", priority = 37, lores = { "lesser chivalry" } },
  { spell = "shared boon", command = "cast 'shared boon'", statKey = "SharedBoon", exclusiveGroup = "Boon", priority = 36, lores = { "greater chivalry" } },
  { spell = "valorous boon", command = "cast 'valorous boon'", statKey = "ValorousBoon", exclusiveGroup = "Boon", priority = 35, lores = { "greater chivalry" } },
  { spell = "final boon", command = "cast 'final boon'", statKey = "FinalBoon", exclusiveGroup = "Boon", priority = 34, lores = { "greater chivalry" } },

  -- Monk / shadowfist-style buffs and stances used by existing automation
  { spell = "stone fist", command = "cast 'stone fist'", statKey = "StoneFist", priority = 33, lores = { "lesser empty hand", "lesser shadowlore" } },
  { spell = "dagger hand", command = "cast 'dagger hand'", statKey = "DaggerHand", priority = 32, lores = { "lesser empty hand", "lesser shadowlore" } },
  { spell = "consummation", command = "cast consummation", statKey = "Consummation", priority = 31, lores = { "greater empty hand" } },
  { spell = "blind devotion", command = "cast 'blind devotion'", statKey = "BlindDevotion", priority = 30, lores = { "greater empty hand" } },
  { spell = "flow like water", command = "cast 'flow like water'", statKey = "FlowLikeWater", priority = 29, lores = { "greater empty hand" } },
  { spell = "burning fury", command = "cast 'burning fury'", statKey = "BurningFury", priority = 28, lores = { "greater shadowlore" } },
}

local function legendStatIsActive(statKey)
  if not statKey then return false end

  local value = StatTable[statKey]
  if statKey == "Frenzy" and not value then value = StatTable.Fervor end
  if value == "continuous" or value == "yes" or value == true then return true end

  local number = tonumber(value)
  return number ~= nil and number > 0
end

local function legendBuffIsActive(buff)
  if legendStatIsActive(buff.statKey) then return true end

  if buff.alsoStatKeys then
    for _, statKey in ipairs(buff.alsoStatKeys) do
      if legendStatIsActive(statKey) then return true end
    end
  end

  return false
end

local function legendMarkPlannedStats(buff, plannedStats)
  if buff.statKey then plannedStats[buff.statKey] = true end

  if buff.alsoStatKeys then
    for _, statKey in ipairs(buff.alsoStatKeys) do
      plannedStats[statKey] = true
    end
  end
end

local function legendHasPlannedStat(buff, plannedStats)
  if buff.statKey and plannedStats[buff.statKey] then return true end

  if buff.alsoStatKeys then
    for _, statKey in ipairs(buff.alsoStatKeys) do
      if plannedStats[statKey] then return true end
    end
  end

  return false
end

local function normalizeLegendSpellUpName(name)
  if not name then return nil end

  name = name:lower()
  name = name:gsub("['\"]", "")
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  name = name:gsub("%s+", " ")
  if name == "" then return nil end
  return name
end

local function legendSpellUpPreference(group)
  if not group then return nil end
  return normalizeLegendSpellUpName(Legend.SpellUp[group])
end

local function legendExclusiveGroupIsActive(group)
  if not group then return false end

  for _, buff in ipairs(Legend.SpellUp.Buffs) do
    if buff.exclusiveGroup == group and legendBuffIsActive(buff) then
      return true
    end
  end

  return false
end

local function legendBuffMatchesPreference(buff)
  if not buff.exclusiveGroup then return true end

  local preference = legendSpellUpPreference(buff.exclusiveGroup)
  local requiresPreference = {
    HighMagick = true,
    Pantheon = true,
    KineticWeapon = true,
    Boon = true,
  }

  if requiresPreference[buff.exclusiveGroup] and not preference then return false end
  if not preference then return true end

  return normalizeLegendSpellUpName(buff.spell) == preference
end

local function legendBuffConditionMet(buff)
  if not buff.condition then return true end
  return buff.condition()
end

function Legend.SpellUp.HasLoreForBuff(buff)
  if not Legend.HasLore or not buff or not buff.lores then return false end

  for _, lore in ipairs(buff.lores) do
    if Legend.HasLore(lore) then return true end
  end

  return false
end

function Legend.SpellUp.GetAvailableBuffs()
  local buffs = {}

  for _, buff in ipairs(Legend.SpellUp.Buffs) do
    if Legend.SpellUp.HasLoreForBuff(buff) and legendBuffMatchesPreference(buff) and legendBuffConditionMet(buff) then
      table.insert(buffs, buff)
    end
  end

  table.sort(buffs, function(a, b)
    if a.final ~= b.final then return not a.final end
    if a.priority == b.priority then return a.spell < b.spell end
    return a.priority > b.priority
  end)

  return buffs
end

function Legend.SpellUp.GetCommands()
  local commands = {}
  local plannedStats = {}
  local plannedGroups = {}

  for _, buff in ipairs(Legend.SpellUp.GetAvailableBuffs()) do
    if not legendBuffIsActive(buff) and
       not legendHasPlannedStat(buff, plannedStats) and
       not legendExclusiveGroupIsActive(buff.exclusiveGroup) and
       not (buff.exclusiveGroup and plannedGroups[buff.exclusiveGroup]) then
      table.insert(commands, buff)
      legendMarkPlannedStats(buff, plannedStats)
      if buff.exclusiveGroup then plannedGroups[buff.exclusiveGroup] = true end
    end
  end

  return commands
end

function Legend.SpellUp.Queue()
  if not Legend.Lore or Legend.Lore.IsCapturing then return false end

  if Battle and Battle.Combat then
    printGameMessage("Legend SpellUp", "Spellup skipped while in combat", "cyan", "white")
    return false
  end

  if StatTable.Position == "Sleep" then
    send("wake")
    safeTempTimer("Legend.SpellUp.AfterWake", 1, function() Legend.SpellUp.Queue() end)
    return true
  elseif StatTable.Position ~= "Stand" then
    send("stand")
    safeTempTimer("Legend.SpellUp.AfterStand", 1, function() Legend.SpellUp.Queue() end)
    return true
  end

  local buffs = Legend.SpellUp.GetCommands()
  local queued = 0
  local action = SafeArea() and "sent" or "queued"

  if SafeArea() then
    local commands = {}
    for _, buff in ipairs(buffs) do
      table.insert(commands, buff.command)
    end

    if #commands > 0 then
      send(table.concat(commands, getCommandSeparator()))
    end

    queued = #commands
  else
    for _, buff in ipairs(buffs) do
      if BuffManager.Add(buff.command, buff.priority) then
        queued = queued + 1
      end
    end
  end

  printGameMessage("Legend SpellUp", queued .. " buff" .. (queued == 1 and "" or "s") .. " " .. action, "cyan", "white")
  return queued > 0
end

function Legend.SpellUp.Run()
  if not Legend.Lore or not Legend.Lore.KnownLookup then
    Legend.SpellUp.Pending = true
    send("lore")
    printGameMessage("Legend SpellUp", "Refreshing lore before spellup", "cyan", "white")
    return
  end

  Legend.SpellUp.Queue()
end

safeEventHandler("Legend.SpellUp.OnLegendLore", "OnLegendLore", function()
  if not Legend.SpellUp.Pending then return end

  Legend.SpellUp.Pending = false
  Legend.SpellUp.Queue()
end)
