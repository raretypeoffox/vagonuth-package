-- Script: Drider Script
-- Attribute: isActive

-- Script Code:
function DriderPoisonOnCombat()
  if not (StatTable.Level == 125 and StatTable.Race == "Drider") then return end
  
  if IsNotClass({"Soldier", "Priest", "Berserker", "Black Circle Initiate", "Bodyguard", "Stormlord"}) and not StatTable.RacialExpungeFatigue then
    TryAction("cast poison", 5)
    
    -- poison for a HiE is 7 mana base, 42 (quicken 5) and 70 (quicken 9)
  end
  
  TryAction("racial poison", 5)
  
  safeTempTrigger("DriderExpunge", "looks pretty hurt.", function() 
    if not StatTable.RacialExpungeFatigue and 
    (StatTable.Level == 125 and tonumber(gmcp.Char.Status.opponent_level) > 160) then 
      TryAction("racial expunge", 5) 
    end
  end, "substring", 1)

end
                                       
safeEventHandler("DriderOnCombatID", "OnCombat", "DriderPoisonOnCombat", false)