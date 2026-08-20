-- Script: Psi Kinetic Enhancers
-- Attribute: isActive

-- Script Code:
KineticEnhancers = {
  {
    key = "StunningWeapon",
    spell = "stunning weapon",
    level = 51,
    sublevel = 500,
    desc = "stuns the mob for approx one round (33% chance)",
  },
  {
    key = "DistractingWeapon",
    spell = "distracting weapon",
    level = 125,
    sublevel = 50,
    desc = "mobs attacks less likely to land",
  },
  {
    key = "DisablingWeapon",
    spell = "disabling weapon",
    level = 125,
    sublevel = 100,
    desc = "reduces the effectiveness of melee combat in mobs",
  },
  {
    key = "RestrictingWeapon",
    spell = "restricting weapon",
    level = 125,
    sublevel = 300,
    desc = "reduces the likelihood of mob's landing multiple blows/round",
  },
  {
    key = "FellingWeapon",
    spell = "felling weapon",
    level = 125,
    sublevel = 400,
    desc = "bashes the mob",
  },
  {
    key = "ConsciousWeapon",
    spell = "conscious weapon",
    level = 125,
    sublevel = 500,
    desc = "telekinetic attacks are more damaging",
  },
  {
    key = "IntelligentWeapon",
    spell = "intelligent weapon",
    level = 125,
    sublevel = 800,
    desc = "exploit mob's weaknesses",
  },
}

GlobalVar.KineticEnhancerOne = GlobalVar.KineticEnhancerOne or "felling weapon"
GlobalVar.KineticEnhancerTwo = GlobalVar.KineticEnhancerTwo or "conscious weapon"
GlobalVar.KineticEnhancerThree = GlobalVar.KineticEnhancerThree or "intelligent weapon"

local function normalizeKineticInput(input)
  if not input then return nil end

  return input
    :lower()
    :gsub("['\"]", "")
    :gsub("^%s+", "")
    :gsub("%s+$", "")
    :gsub("%s+", "")
end


function matchKineticEnhancer(input, silent)
  local normalizedInput = normalizeKineticInput(input)

  if not normalizedInput or normalizedInput == "" then
    return nil
  end

  local matches = {}

  for _, enhancer in ipairs(KineticEnhancers) do
    local normalizedSpell = normalizeKineticInput(enhancer.spell)

    if normalizedSpell:find(normalizedInput, 1, true) then
      table.insert(matches, enhancer)
    end
  end

  if #matches == 0 then
    return nil
  end

  if #matches > 1 then
    if not silent then
      printMessage("Kinetic Enhancer error", "Ambiguous spell: <yellow>" .. tostring(input))

      for _, match in ipairs(matches) do
        printMessage("Possible match", "<yellow>" .. match.spell)
      end
    end

    return nil
  end

  return matches[1]
end


function hasKineticEnhancerUnlocked(enhancer)
  local level = tonumber(StatTable.Level) or 0
  local sublevel = tonumber(StatTable.SubLevel) or 0

  if level > enhancer.level then
    return true
  end

  if level == enhancer.level and sublevel >= enhancer.sublevel then
    return true
  end

  return false
end


function getMaxKineticEnhancers()
  local level = tonumber(StatTable.Level) or 0
  local sublevel = tonumber(StatTable.SubLevel) or 0

  if level == 51 then
    return sublevel >= 500 and 1 or 0
  end

  if level == 125 then
    return sublevel >= 800 and 3 or 2
  end

  -- Preserve the existing behavior for tiers above Lord.
  return level > 125 and 2 or 0
end


function checkKineticEnhancers()
  local count = 0

  for _, enhancer in ipairs(KineticEnhancers) do
    if StatTable[enhancer.key] ~= nil then
      count = count + 1

    end
  end

  return count
end


function isKineticEnhancerExhausted(enhancer)
  if not enhancer then
    return false
  end

  return StatTable[enhancer.key .. "Exhaust"] ~= nil
end


local function castKineticEnhancerIfNeeded(input)
  local enhancer = matchKineticEnhancer(input)

  if not enhancer then
    return false
  end

  if not hasKineticEnhancerUnlocked(enhancer) then
    return false
  end

  if StatTable[enhancer.key] ~= nil then
    return false
  end

  if isKineticEnhancerExhausted(enhancer) then
    return false
  end

  TryAction("cast '" .. enhancer.spell .. "'", 5)
  return true
end

-- Called by GameLoop if you're a Psi
function castKineticEnhancers()
  if Battle.Combat then return end
  if StatTable.Class ~= "Psionicist" then return end

  local maxEnhancers = getMaxKineticEnhancers()
  if maxEnhancers == 0 then return end

  if (tonumber(StatTable.current_mana) or 0) < 5000 then return end

  local enhancersCount = checkKineticEnhancers()

  if enhancersCount >= maxEnhancers then
    return
  end

  if GlobalVar.KineticEnhancerOne then
    if castKineticEnhancerIfNeeded(GlobalVar.KineticEnhancerOne) then
      return
    end
  end

  if GlobalVar.KineticEnhancerTwo then
    if castKineticEnhancerIfNeeded(GlobalVar.KineticEnhancerTwo) then
      return
    end
  end

  if GlobalVar.KineticEnhancerThree then
    if castKineticEnhancerIfNeeded(GlobalVar.KineticEnhancerThree) then
      return
    end
  end
end
