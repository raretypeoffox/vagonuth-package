-- Trigger: Poke Rescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) pokes you in the ribs.

-- Script Code:
send("rescue " .. matches[2])