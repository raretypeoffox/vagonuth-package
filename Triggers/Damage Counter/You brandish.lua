-- Trigger: You brandish 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You brandish
-- 1 (regex): ^Your .* brandishes itself all of its own!

-- Script Code:
DamageCounter.AddBrandish(StatTable.CharName)