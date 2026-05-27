-- Script: Surge
-- Attribute: isActive

-- Script Code:
Surge = Surge or {}

local SURGE_MAX_BY_CLASS = {
  Necromancer = 1,
  Paladin = 1,
  Soldier = 1,
  Berserker = 1,
  Bodyguard = 1,
  Ripper = 1,

  Rogue = 2,
  Warrior = 2,
  Archer = 2,
  Assassin = 2,
  Priest = 2,
  Druid = 2,

  Cleric = 3,
  Monk = 3,
  Bladedancer = 3,
  ["Black Circle Initiate"] = 3,
  Shadowfist = 3,

  Psionicist = 4,
  Fury = 4,
  Vizier = 4,

  Mage = 5,
  Wizard = 5,
  Mindbender = 5,
  Sorcerer = 5,
}

local function surgeSpellCostMod(spell_type)
  if Battle and type(Battle.GetSpellCostMod) == "function" then return Battle.GetSpellCostMod(spell_type) end
  if type(_G["GetSpellCostMod"]) == "function" then return GetSpellCostMod(spell_type) end
  return 1
end

function Surge.ClampLevel(level, max_level)
  level = tonumber(level) or 1
  max_level = tonumber(max_level) or 5

  if level < 1 then return 1 end
  if level > max_level then return max_level end
  return level
end

function Surge.GetMaxLevel(class_name)
  if StatTable and StatTable.Level == 250 then return 5 end
  return SURGE_MAX_BY_CLASS[class_name or (StatTable and StatTable.Class)] or 5
end

function Surge.GetAutoCastStopSurge(spell_name)
  if not StatTable or StatTable.Level ~= 125 then return 3500 end

  if StatTable.Class == "Mage" or StatTable.Class == "Stormlord" then
    return 9000 * surgeSpellCostMod("arcane")
  elseif StatTable.Class == "Wizard" then
    return 10000 * surgeSpellCostMod("arcane")
  elseif StatTable.Class == "Sorcerer" then
    return 10000 * surgeSpellCostMod("arcane")
  elseif type(IsClass) == "function" and IsClass({"Mindbender", "Psionicist"}) then
    return 9000 * surgeSpellCostMod("psionic")
  end

  return 3500
end

function Surge.GetLevel(spell_name, opts)
  opts = opts or {}

  local base_level = Surge.ClampLevel(GlobalVar and GlobalVar.SurgeLevel or 1, 5)

  -- Legend surge access is lore-based, so do not class-gate or auto-adjust it here.
  if StatTable and StatTable.Level == 250 then return base_level end

  local surge_level = Surge.ClampLevel(base_level, Surge.GetMaxLevel())
  if surge_level <= 1 then return 1 end

  if GlobalVar and GlobalVar.AutoSurgeLevel == false then return surge_level end

  local mana = tonumber(opts.mana)
  if not mana and gmcp and gmcp.Char and gmcp.Char.Status then mana = tonumber(gmcp.Char.Status.mana) end
  if not mana and StatTable then mana = tonumber(StatTable.current_mana) end
  mana = mana or 0

  local stop_surge = tonumber(opts.stop_surge) or tonumber(opts.stopSurge) or Surge.GetAutoCastStopSurge(spell_name)
  if mana < stop_surge then return 1 end

  if StatTable and StatTable.Class == "Wizard" and StatTable.EtherCrash == 1 and
     GlobalVar and spell_name == GlobalVar.AutoCasterAOE then
    return Surge.ClampLevel(5, Surge.GetMaxLevel())
  end

  if mana > (stop_surge * 8) then
    surge_level = surge_level + 2
  elseif mana > (stop_surge * 4) then
    surge_level = surge_level + 1
  end

  if surge_level < 5 and spell_name == "signature spell" then
    surge_level = surge_level + 1
  end

  return Surge.ClampLevel(surge_level, Surge.GetMaxLevel())
end

function GetSurgeLevel(spell_name, opts)
  return Surge.GetLevel(spell_name, opts)
end
