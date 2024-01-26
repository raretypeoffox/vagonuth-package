-- Trigger: glows blue. 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) glows blue.$
-- 1 (regex): ^(.*) shimmers with a gold aura.$

-- Script Code:
-- set up multiline multiline trigger 


coroutine.wrap(function()

  if (AutoEnchantTable.ItemName ~= string.lower(matches[2])) then
    AutoEnchantDebug("AutoEnchant: Other enchanter's detected\n")
    return
  else
    AutoEnchantDebug("AutoEnchant: Our enchant")
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
  
  AutoEnchantDBAdd("enchant")
  if (AutoEnchantAddLevel() == true) then
    AutoEnchantTry()
  end
  
end)()