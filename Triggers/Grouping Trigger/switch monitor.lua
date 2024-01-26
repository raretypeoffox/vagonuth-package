-- Trigger: switch monitor 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Okay, you are now monitoring (\w+).

-- Script Code:
StatTable.Monitor = matches[2]