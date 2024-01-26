-- Trigger: Explode 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) shivers violently and explodes!$
-- 1 (regex): ^(.*) flares blindingly... and evaporates!$

-- Script Code:
coroutine.wrap(function()
  if (AutoEnchantTable.ItemName ~= string.lower(matches[2])) then
    AutoEnchantDebug("AutoEnchant: Other enchanter's explosion detected")
    return
  end
  
    if (StatTable.current_mana < 200) then
      send("sleep")
      
      repeat
        wait(10)
        StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
      until (StatTable.current_mana == StatTable.max_mana)
      send("stand")
      print("max mana")
    end
    
    if (AutoEnchantTable.Brills > 0) then
      AutoEnchantPrint("Brill exploded!")
    else
      AutoEnchantPrint("Item exploded")
    end
    
    AutoEnchantDBAdd("explode")
    AutoEnchantReset()
  
  
end)()