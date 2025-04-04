-- Script: Psi Kinetic Enhancers
-- Attribute: isActive

-- Script Code:
KineticEnhancers = {
  "StunningWeapon",
  "DistractingWeapon",
  "DisablingWeapon",
  "RestrictingWeapon",
  "FellingWeapon",
  "ConsciousWeapon",
  "IntelligentWeapon",
}

-- hack for now
GlobalVar.KineticEnhancerOne = GlobalVar.KineticEnhancerOne or nil
GlobalVar.KineticEnhancerTwo = GlobalVar.KineticEnhancerTwo or nil

function checkKineticEnhancers()
  local count = 0

  for _, kin in ipairs(KineticEnhancers) do
    if StatTable[kin] ~= nil then
      count = count + 1
      if count >= 2 then
        return 2  -- Early return if there are at least two spells
      end
    end
  end

  return count
end

-- Function to match input string to one of the KineticEnhancers
function matchKineticEnhancer(input)
    if not input then return nil end
    
    -- Normalize the input by removing quotes and extra spaces, then converting to lowercase
    local normalizedInput = input:lower():gsub("['\"]", ""):gsub("%s+", "")

    -- Iterate through each value in KineticEnhancers
    for _, enhancer in ipairs(KineticEnhancers) do
        -- Normalize the enhancer value by removing spaces and converting to lowercase
        local normalizedEnhancer = enhancer:lower():gsub("%s+", "")

        -- Check for a partial match
        if normalizedEnhancer:find(normalizedInput) then
            return enhancer
        end
    end

    -- Return nil if no match is found
    return nil
end

-- Called by GameLoop is you're a Psi
function castKineticEnhancers()
  if Battle.Combat then return end
  if StatTable.Level <= 51 and StatTable.SubLevel < 500 then return end -- first spell is at hero 500
  if StatTable.current_mana < 5000 then return end -- set a minimum amount of mana
  
  local enhancersCount = checkKineticEnhancers()

  if enhancersCount == 2 or (enhancersCount == 1 and StatTable.Level == 51) then return end

  if GlobalVar.KineticEnhancerOne and matchKineticEnhancer(GlobalVar.KineticEnhancerOne) and not StatTable[matchKineticEnhancer(GlobalVar.KineticEnhancerOne)] then
    TryAction("cast '" .. GlobalVar.KineticEnhancerOne .. "'", 5)
    return  
  end
  
  if GlobalVar.KineticEnhancerTwo and matchKineticEnhancer(GlobalVar.KineticEnhancerTwo) and not StatTable[matchKineticEnhancer(GlobalVar.KineticEnhancerTwo)] then
    TryAction("cast '" .. GlobalVar.KineticEnhancerTwo .. "'", 5)
    return  
  end
  
end





    


