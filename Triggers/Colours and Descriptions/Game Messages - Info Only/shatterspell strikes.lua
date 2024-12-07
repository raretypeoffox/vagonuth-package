-- Trigger: shatterspell strikes 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+)'s shatterspell strikes (.*)

-- Script Code:
if not IsGroupMate(matches[2]) then
  printGameMessageVerbose("Mob shattered!", matches[3], "yellow", "white")
end