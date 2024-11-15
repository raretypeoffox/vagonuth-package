-- Trigger: Det text 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^Moments before detonation, (.*) vanishes suddenly! 

-- Script Code:
printGameMessage("Det Alert!", matches[2] .. " vanishes suddenly!", "red", "white")