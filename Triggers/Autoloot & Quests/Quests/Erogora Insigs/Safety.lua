-- Trigger: Safety 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): Pilgrim says 'Each group member should send me a tell stating "reward".'

-- Script Code:
tempTimer(1, [[send("tell pilgrim reward")]])
tempTimer(5, [[send("tell pilgrim reward")]])