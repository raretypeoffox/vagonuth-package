-- Script: Pantheon Spells
-- Attribute: isActive

-- Script Code:
local PantheonSpells = {
  "ArtificerBlessing",
  "Discordia",
  "DivineAdjutant",
  "DivineGrace",
  "GloriousConquest",
  "GrimHarvest",
  "HallowedNimbus",
  "ProtectiveVigil",
  "SylvanBenediction",
  "UnholyRampage"
}

GlobalVar.PantheonSpell = GlobalVar.PantheonSpell or nil
GlobalVar.PantheonCounter = GlobalVar.PantheonCounter or 0

function setPantheonSpell(input)
    local setPantheonSpells = {
      "artificer blessing",
      "discordia",
      "divine adjutant",
      "divine grace",
      "glorious conquest",
      "grim harvest",
      "hallowed nimbus",
      "protective vigil",
      "sylvan benediction",
      "unholy rampage"
    }
    if not input then return nil end
    
    if input == "gc" then return "glorious conquest" end -- I mean we all it call that right :p
    
    -- Normalize the input by removing quotes and extra spaces, then converting to lowercase
    local normalizedInput = input:lower():gsub("['\"]", ""):gsub("%s+", "")

    for _, enhancer in ipairs(setPantheonSpells) do
        local normalizedEnhancer = enhancer:lower():gsub("%s+", "")

        if normalizedEnhancer:find(normalizedInput) then
            return enhancer
        end
    end

    return nil
end

function checkPantheonSpells()
  for _, spell in ipairs(PantheonSpells) do
    if StatTable[spell] ~= nil then
      return spell
    end
  end
  return false
end

-- Called by GameLoop is you're a Cleric
function castPantheonSpell()
 if Battle.Combat then return end
 if checkPantheonSpells() then return end
 if not GlobalVar.PantheonSpell then return end
 
 
 TryAction("cast '" .. GlobalVar.PantheonSpell .. "'", 30) 
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
    safeKillEventHandler("PantheonGrimHarvestID")
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

