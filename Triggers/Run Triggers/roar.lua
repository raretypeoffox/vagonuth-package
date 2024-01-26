-- Trigger: roar 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'roar'

-- Script Code:
if (StatTable.Race == "Dragon") then
  send("racial roar")
end