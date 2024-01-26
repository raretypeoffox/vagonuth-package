-- Trigger: Nothing seemed to happen. 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Nothing seemed to happen.

-- Script Code:
coroutine.wrap(function()
  
  if (StatTable.current_mana < 200) then
    send("sleep")
    
    repeat
      wait(10)
      StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
    until (StatTable.current_mana == StatTable.max_mana)
    send("stand")
    print("max mana")
  end
  
  AutoEnchantDBAdd("nothing")
  AutoEnchantTry()
  
end)()
