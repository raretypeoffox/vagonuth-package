-- Trigger: fade 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) glows brightly, then fades...oops.$

-- Script Code:
coroutine.wrap(function()

  if (AutoEnchantTable.ItemName ~= string.lower(matches[2])) then
    AutoEnchantDebug("AutoEnchant: Other fade\n")
    return
  else
    AutoEnchantDebug("AutoEnchant: Our fade\n")
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
  
  AutoEnchantDBAdd("fade")
  
  
  if (AutoEnchantTable.Brills > 0) then
    AutoEnchantTable.Brills = 0 -- item faded, reset brills to 0
    AutoEnchantPrint("Brill faded!")
  --else
    --AutoEnchantPrint("Fade")
  end
    
    
  if (AutoEnchantAddLevel() == true) then
    AutoEnchantTry()
  end
  
end)()