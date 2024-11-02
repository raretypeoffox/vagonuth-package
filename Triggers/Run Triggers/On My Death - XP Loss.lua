-- Trigger: On My Death - XP Loss 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Death sucks (\d+) experience points from you as payment for resurrection.

-- Script Code:
printGameMessage("Death!", "Death Loss XP: <white>" .. matches[2], "red", "ansi_white")
