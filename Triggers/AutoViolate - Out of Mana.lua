-- Trigger: AutoViolate - Out of Mana 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You do not have enough mana to cast violation.

-- Script Code:
coroutine.wrap(function()

  send("sleep")
  
  repeat
    wait(10)
    StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
  until (StatTable.current_mana == StatTable.max_mana)
  
  send("stand")
  send("cast violation " .. GlobalVar.AutoViolateItem)
  
end)()