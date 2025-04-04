-- Trigger: lock - dismant 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You successfully dismantle the 
-- 1 (start of line): Wrong trap! You set it off!

-- Script Code:
send("hold chest")
send("pick lockbox")