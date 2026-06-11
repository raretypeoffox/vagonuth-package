-- Script: Stormlord Stratums
-- Attribute: isActive

-- Script Code:
StormlordStratums = {
  {
    key = "StratumGale",
    spell = "gale",
    level = 51,
    sublevel = 675,
    desc = "helps hold off non-targeted magical and breath attacks",
  },
  {
    key = "StratumSleet",
    spell = "sleet",
    level = 51,
    sublevel = 675,
    desc = "can make mobs choose an easier target or slip when attacking",
  },
  {
    key = "StratumSpringRain",
    spell = "spring rain",
    level = 51,
    sublevel = 675,
    desc = "reduces sustained weather spell cost",
  },
  {
    key = "StratumCloudburst",
    spell = "cloudburst",
    level = 51,
    sublevel = 675,
    desc = "matching weather spell can attack right away",
  },
  {
    key = "StratumHailStorm",
    spell = "hail storm",
    level = 51,
    sublevel = 675,
    desc = "matching weather spell can attack right away",
  },
  {
    key = "StratumThunderhead",
    spell = "thunderhead",
    level = 125,
    sublevel = 1,
    desc = "matching weather spell does increased damage",
  },
  {
    key = "StratumBlizzard",
    spell = "blizzard",
    level = 125,
    sublevel = 1,
    desc = "matching weather spell does increased damage",
  },
}

GlobalVar.StratumTwo = GlobalVar.StratumTwo or nil

local function normalizeStratumInput(input)
  if not input then return nil end

  return input
    :lower()
    :gsub("['\"]", "")
    :gsub("^%s+", "")
    :gsub("%s+$", "")
    :gsub("%s+", "")
end

function matchStratum(input)
  local normalizedInput = normalizeStratumInput(input)

  if not normalizedInput or normalizedInput == "" then
    return nil
  end

  local exactMatch = nil
  local matches = {}

  for _, stratum in ipairs(StormlordStratums) do
    local normalizedSpell = normalizeStratumInput(stratum.spell)

    if normalizedSpell == normalizedInput then
      exactMatch = stratum
      break
    end

    if normalizedSpell:find(normalizedInput, 1, true) then
      table.insert(matches, stratum)
    end
  end

  if exactMatch then
    return exactMatch
  end

  if #matches == 0 then
    return nil
  end

  if #matches > 1 then
    printMessage("Stratum error", "Ambiguous stratum: <yellow>" .. tostring(input))

    for _, match in ipairs(matches) do
      printMessage("Possible match", "<yellow>" .. match.spell)
    end

    return nil
  end

  return matches[1]
end

function hasStratumUnlocked(stratum)
  if not stratum then return false end

  local level = StatTable.Level or 0
  local sublevel = StatTable.SubLevel or 0

  if level > stratum.level then
    return true
  end

  if level == stratum.level and sublevel >= stratum.sublevel then
    return true
  end

  return false
end

function hasStrataControl()
  return StatTable.Level == 125 and (StatTable.SubLevel or 0) >= 25
end

function checkStratums()
  local count = 0

  for _, stratum in ipairs(StormlordStratums) do
    if StatTable[stratum.key] ~= nil then
      count = count + 1

      if count >= 2 then
        return 2
      end
    end
  end

  return count
end

function getStratumLimit()
  return hasStrataControl() and 2 or 1
end

function getDefaultStratumOne()
  if StatTable.Level == 125 then
    return "gale"
  end

  return nil
end

function getPreferredStratumOne()
  if GlobalVar.StratumOne ~= nil then
    return GlobalVar.StratumOne
  end

  return getDefaultStratumOne()
end

function isStratumAutomationOff()
  return getPreferredStratumOne() == "off"
end

function getStratumCommand(input)
  local stratum = matchStratum(input)

  if not stratum then return nil end
  if not hasStratumUnlocked(stratum) then return nil end

  return "cast stratum " .. stratum.spell
end

function getPreferredStratumCommands()
  local commands = {}
  local seen = {}
  local slotsAvailable = getStratumLimit() - checkStratums()

  if isStratumAutomationOff() then
    return commands
  end

  if slotsAvailable <= 0 then
    return commands
  end

  local preferredStratums = {
    getPreferredStratumOne(),
    GlobalVar.StratumTwo,
  }

  for _, preferredStratum in ipairs(preferredStratums) do
    if preferredStratum and #commands < slotsAvailable then
      local stratum = matchStratum(preferredStratum)

      if stratum and not seen[stratum.key] and hasStratumUnlocked(stratum) and StatTable[stratum.key] == nil then
        table.insert(commands, "cast stratum " .. stratum.spell)
        seen[stratum.key] = true
      end
    end
  end

  return commands
end

local function castStratumIfNeeded(input)
  local stratum = matchStratum(input)

  if not stratum then
    return false
  end

  if not hasStratumUnlocked(stratum) then
    return false
  end

  if StatTable[stratum.key] ~= nil then
    return false
  end

  if checkStratums() >= getStratumLimit() then
    return false
  end

  if type(BuffManager) == "table" and type(BuffManager.Add) == "function" then
    BuffManager.Add("cast stratum " .. stratum.spell, 1)
  else
    TryAction("cast stratum " .. stratum.spell, 30)
  end

  return true
end

function castStratums()
  if Battle.Combat then return end
  if StatTable.Class ~= "Stormlord" then return end
  if isStratumAutomationOff() then return end
  if StatTable.Position ~= "Stand" then return end

  if StatTable.Level < 51 then return end
  if StatTable.Level == 51 and (StatTable.SubLevel or 0) < 675 then return end
  if (StatTable.current_mana or 0) < 500 then return end

  if checkStratums() >= getStratumLimit() then
    return
  end

  local stratumOne = getPreferredStratumOne()

  if stratumOne then
    if castStratumIfNeeded(stratumOne) then
      return
    end
  end

  if getStratumLimit() >= 2 and GlobalVar.StratumTwo then
    if castStratumIfNeeded(GlobalVar.StratumTwo) then
      return
    end
  end
end
