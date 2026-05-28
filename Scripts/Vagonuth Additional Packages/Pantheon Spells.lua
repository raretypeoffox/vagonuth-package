-- Script: Pantheon Spells
-- Attribute: isActive

-- Script Code:
PantheonSpells = {
  { key = "GloriousConquest", spell = "glorious conquest", level = 51, sublevel = 100 },
  { key = "HallowedNimbus", auraKey = "HallowedNimbusAura", spell = "hallowed nimbus", level = 51, sublevel = 150 },
  { key = "ArtificerBlessing", auraKey = "ArtificerBlessingAura", spell = "artificer blessing", level = 51, sublevel = 200 },
  { key = "UnholyRampage", auraKey = "UnholyRampageAura", spell = "unholy rampage", level = 51, sublevel = 250 },
  { key = "SylvanBenediction", auraKey = "SylvanBenedictionAura", spell = "sylvan benediction", level = 51, sublevel = 300 },
  { key = "GrimHarvest", auraKey = "GrimHarvestAura", spell = "grim harvest", level = 51, sublevel = 375 },
  { key = "Discordia", auraKey = "DiscordiaAura", spell = "discordia", level = 51, sublevel = 500 },
  { key = "DivineGrace", spell = "divine grace", level = 125, sublevel = 1 },
  { key = "ProtectiveVigil", auraKey = "ProtectiveVigilAura", spell = "protective vigil", level = 125, sublevel = 50 },
  { key = "DivineAdjutant", auraKey = "DivineAdjutantAura", spell = "divine adjutant", level = 125, sublevel = 100 },
}

GlobalVar.PantheonSpell = GlobalVar.PantheonSpell or nil
GlobalVar.PantheonCounter = GlobalVar.PantheonCounter or 0

local function normalizePantheonInput(input)
  if not input then return nil end

  return input
    :lower()
    :gsub("['\"]", "")
    :gsub("^%s+", "")
    :gsub("%s+$", "")
    :gsub("%s+", "")
end

function matchPantheonSpell(input)
  local normalizedInput = normalizePantheonInput(input)

  if not normalizedInput or normalizedInput == "" then
    return nil
  end

  if normalizedInput == "gc" then
    normalizedInput = "gloriousconquest"
  end

  local exactMatch = nil
  local matches = {}

  for _, pantheonSpell in ipairs(PantheonSpells) do
    local normalizedSpell = normalizePantheonInput(pantheonSpell.spell)

    if normalizedSpell == normalizedInput then
      exactMatch = pantheonSpell
      break
    end

    if normalizedSpell:find(normalizedInput, 1, true) then
      table.insert(matches, pantheonSpell)
    end
  end

  if exactMatch then
    return exactMatch
  end

  if #matches == 0 then
    return nil
  end

  if #matches > 1 then
    printMessage("Pantheon error", "Ambiguous spell: <yellow>" .. tostring(input))

    for _, pantheonSpell in ipairs(matches) do
      printMessage("Possible match", "<yellow>" .. pantheonSpell.spell)
    end

    return nil
  end

  return matches[1]
end

function setPantheonSpell(input)
  local pantheonSpell = matchPantheonSpell(input)

  return pantheonSpell and pantheonSpell.spell or nil
end

function hasPantheonSpellUnlocked(pantheonSpell)
  local level = StatTable.Level or 0
  local sublevel = StatTable.SubLevel or 0

  if level > pantheonSpell.level then
    return true
  end

  if level == pantheonSpell.level and sublevel >= pantheonSpell.sublevel then
    return true
  end

  return false
end

function canAutocastPantheonSpell(pantheonSpell)
  return pantheonSpell and pantheonSpell.key ~= nil
end

function checkPantheonSpells()
  for _, pantheonSpell in ipairs(PantheonSpells) do
    if pantheonSpell.key and StatTable[pantheonSpell.key] ~= nil then
      return pantheonSpell.key
    end
  end
  return false
end

-- Called by GameLoop is you're a Cleric
function castPantheonSpell()
 if Battle.Combat then return end
 if checkPantheonSpells() then return end
 if not GlobalVar.PantheonSpell then return end

 local pantheonSpell = matchPantheonSpell(GlobalVar.PantheonSpell)

 if not pantheonSpell then return end
 if not hasPantheonSpellUnlocked(pantheonSpell) then return end
 if not canAutocastPantheonSpell(pantheonSpell) then return end
 if StatTable[pantheonSpell.key] ~= nil then return end

 TryAction("cast '" .. pantheonSpell.spell .. "'", 30) 
end

function PantheonSpellSetInit()
  if not StatTable or not StatTable.CharName then return end
  if StatTable.Class == "Cleric" and StatTable.Level >= 51 then
  local charname = StatTable.CharName
  
    if StaticVars.Default_Pantheon[charname] then
      GlobalVar.PantheonSpell = StaticVars.Default_Pantheon[charname]
      printGameMessage("Pantheon", "Default set to " .. StaticVars.Default_Pantheon[charname])
    end
    
    safeEventHandler("PantheonActiID", "OnMobDeath", "PantheonActivator", false)
  else
    safeKillEventHandler("PantheonActiID")
  end
end

function PantheonActivator()
  if not StatTable.GrimHarvest and not StatTable.UnholyRampage then return end
  if (StatTable.GrimHarvest and StatTable.GrimHarvestAura) or (StatTable.UnholyRampage and StatTable.UnholyRampageAura) then GlobalVar.PantheonCounter = 0; return end
  
  GlobalVar.PantheonCounter = GlobalVar.PantheonCounter + 1
  
  if GlobalVar.PantheonCounter >= StaticVars.PantheonNumber then
    if StatTable.GrimHarvest and not StatTable.GrimHarvestAura then
      Battle.DoAfterCombat("cast 'grim harvest' activate")
      GlobalVar.PantheonCounter = 0
    elseif StatTable.UnholyRampage and not StatTable.UnholyRampageAura then
      Battle.DoAfterCombat("cast 'unholy rampage' activate")
      GlobalVar.PantheonCounter = 0
    end
  end
  
end


safeEventHandler("PantheonSpellSetInitID", "CustomProfileInit", "PantheonSpellSetInit", false)

