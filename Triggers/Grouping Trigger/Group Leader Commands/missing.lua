-- Trigger: missing 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): (?i)missing .*

-- Script Code:
local search_str = string.lower(matches[1])

if search_str:find(string.lower(StatTable.CharName)) then
  QuickBeep()
  printGameMessage("Missing", "Group leader says you're missing!")
end

