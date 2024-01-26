-- Trigger: Holiday Tokens 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You have earned an item! (a heroic halloween token)
-- 1 (start of line): You have earned an item! (a lordly halloween token) 
-- 2 (start of line): You have earned an item! (a Conjunction Holiday token) 

-- Script Code:
send("touch token")