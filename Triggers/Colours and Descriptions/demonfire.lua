-- Trigger: demonfire 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^(\w+) is surrounded by black flames!!!

-- Script Code:
printGameMessage("Demonfire", matches[2] .. " has dfire!", "red", "white")