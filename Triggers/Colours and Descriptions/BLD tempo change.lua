-- Trigger: BLD tempo change 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^(\w+)'s tempo change grants you an epiphany!$

-- Script Code:
printGameMessage("Epiphany", matches[2] .. " granted you an epiphany!", "yellow", "white")