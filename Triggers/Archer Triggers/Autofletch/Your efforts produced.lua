-- Trigger: Your efforts produced 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Your efforts produced (\d+) (.*)

-- Script Code:
AutoFletch.ArrowsFletched = AutoFletch.ArrowsFletched or {}

if not AutoFletch.ArrowsFletched[matches[3]] then
 AutoFletch.ArrowsFletched[matches[3]] = 0
end

AutoFletch.ArrowsFletched[matches[3]] = AutoFletch.ArrowsFletched[matches[3]] + tonumber(matches[2])