-- Trigger: inno 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells the group 'inno
-- 1 (regex): ^(\w+) tells you 'inno'

-- Script Code:
if (StatTable.Level == 125) then
  TryAction("cast inno " .. matches[2])
end