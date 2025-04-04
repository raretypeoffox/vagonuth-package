-- Trigger: surge level 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(s|surge) (off|up|down|1|2|3|4|5)

-- Script Code:
local SurgeUpMana = (30000 * Battle.GetSpellCostMod("arcane")) or 30000 
local surgelevel = tonumber(matches[3]) or matches[3]

if (StatTable.Class == "Mage" or StatTable.Class == "Wizard" or StatTable.Class == "Sorcerer") then
  
  if surgelevel == "off" or surgelevel == 1 then
    GlobalVar.SurgeLevel = 1
    printGameMessage("Surge Request", "Surging turned off")
    
  elseif surgelevel == "down" then
    GlobalVar.SurgeLevel = 2
    printGameMessage("Surge Request", "Surge level set to " .. GlobalVar.SurgeLevel)
    
  elseif surgelevel == "up" then
        
    if GlobalVar.SurgeLevel <= 3 and manapct > 0.40 then
      local priorsurgelevel = GlobalVar.SurgeLevel
      if StatTable.current_mana  > SurgeUpMana then
        GlobalVar.SurgeLevel = 5
      elseif StatTable.current_mana  > (SurgeUpMana * 0.75) then
        GlobalVar.SurgeLevel = (GlobalVar.SurgeLevel > 4 and GlobalVar.SurgeLevel or 4)
      else
        GlobalVar.SurgeLevel = (GlobalVar.SurgeLevel > 3 and GlobalVar.SurgeLevel or 3)
      end
      
      tempTimer(60, function() GlobalVar.SurgeLevel = priorsurgelevel; printGameMessage("Surge Request", "Surge level reset to " .. priorsurgelevel) end)
      printGameMessage("Surge Request", "Surge level set to " .. GlobalVar.SurgeLevel)
    else
      printGameMessage("Surge Request", "Mana is low, didn't surge up")
    end  
    
  else
    assert(surgelevel~=nil)
    GlobalVar.SurgeLevel = surgelevel
    printGameMessage("Surge Request", "Surge level set to " .. GlobalVar.SurgeLevel)
  end
elseif StatTable.Class == "Psionicist" then
  if GlobalVar.QuickenStatus then return end
  
  if surgelevel == "up" then
    local manapct = (StatTable.current_mana / StatTable.max_mana)
    
    if manapct > 0.75 then
      send("quicken 5",false)
      tempTimer(60, function() send("quicken off"); printGameMessage("Surge Request", "Quicken ended") end)
    elseif manapct > 0.5 then
      send("quicken 3",false)
      tempTimer(60, function() send("quicken off"); printGameMessage("Surge Request", "Quicken ended") end)
    else
      printGameMessage("Surge Request", "Mana is low, didn't quicken")
    end
  end 

end
  
  
    



