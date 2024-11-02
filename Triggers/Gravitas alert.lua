-- Trigger: Gravitas alert 
-- Attribute: isActive
-- Attribute: isMultiline
-- Attribute: isColorizerTrigger

-- mFgColor: #ff5500
-- mBgColour: #000000

-- Trigger Patterns:
-- 0 (start of line): Your weapons dance through the air!
-- 1 (regex): ^(.*) is captured! It floats into (.*)'s hands!$

-- Script Code:
local weapon = multimatches[2][2]
local mob = multimatches[2][3]

beep()
printGameMessage("BEEP", weapon .. " captured by " .. mob .. "!", "red", "white")
