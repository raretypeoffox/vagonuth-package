-- Trigger: Comfort - Druid 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'comf(\d+)? (\w+)'$

-- Script Code:
if (StatTable.Level == 125) then 
  if (tonumber(matches[2])~=nil) then
    send("augment " .. matches[2])
    send("cast comfort " .. matches[3])
    send("augment off")
  else
    send("cast comfort " .. matches[3])
  end
end
