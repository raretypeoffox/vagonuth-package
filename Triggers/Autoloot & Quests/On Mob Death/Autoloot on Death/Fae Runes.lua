-- Trigger: Fae Runes 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^A memory of (\w+) is DEAD!!
-- 1 (start of line): A young Fae is DEAD!!

-- Script Code:
send("get rune corpse")