-- Script: High Magicks Auras
-- Attribute: isActive

-- Script Code:
local HighMagick = {
  "Attenuation",
  "PlanarModulation",
  "ArcanaHarvesting",
  "AntimagicFeedback",
  "Brittle",
  "SympatheticResonance",
}

GlobalVar.HighMagickSpell = GlobalVar.HighMagickSpell or nil

function setHighMagick(input)
    local setHighMagick = {
      "attenuation",
      "planar modulation",
      "arcana harvesting",
      "antimagic feedback",
      "brittle",
      "sympathetic resonance",
    }
    if not input then return nil end
    
    -- Normalize the input by removing quotes and extra spaces, then converting to lowercase
    local normalizedInput = input:lower():gsub("['\"]", ""):gsub("%s+", "")

    for _, enhancer in ipairs(setHighMagick) do
        local normalizedEnhancer = enhancer:lower():gsub("%s+", "")

        if normalizedEnhancer:find(normalizedInput) then
            return enhancer
        end
    end

    return nil
end

function checkHighMagick()
  for _, spell in ipairs(HighMagick) do
    if StatTable[spell] ~= nil then
      return spell
    end
  end
  return false
end

-- Called by GameLoop is you're a Mage
function castHighMagickSpell()
 if Battle.Combat then return end
 if GetTier() ~= "Lord" then return end
 if checkHighMagick() then return end
 if not GlobalVar.HighMagickSpell then return end
 
 TryAction("cast '" .. GlobalVar.HighMagickSpell .. "'", 30) 
end

function HighMagickInit()
  if not StatTable or not StatTable.CharName then return end
  if StatTable.Class == "Mage" and StatTable.Level == 125 then
    local charname = StatTable.CharName
    
    if StaticVars.Default_HighMagick[charname] then
      GlobalVar.HighMagickSpell = StaticVars.Default_HighMagick[charname]
      printGameMessage("HighMagick", "Default set to " .. StaticVars.Default_HighMagick[charname])
    end
  end
end


safeEventHandler("HighMagickInitID", "CustomProfileInit", "HighMagickInit", false)



  
 