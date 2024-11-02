-- Trigger: AutoViolate - fail 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your attempt to violate this item has failed.

-- Script Code:



coroutine.wrap(function()

   
  if (StatTable.current_mana < 200) then
    send("sleep")
    
    repeat
      wait(10)
      StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
    until (StatTable.current_mana == StatTable.max_mana)
    send("stand")

  end
  
  send("cast violation " .. GlobalVar.AutoViolateItem)

  
end)()