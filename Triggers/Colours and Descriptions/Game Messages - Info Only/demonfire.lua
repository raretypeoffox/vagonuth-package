-- Trigger: demonfire 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^(\w+) is surrounded by black flames!!!
-- 1 (regex): ^(\w+) are surrounded by black flames!!!

-- Script Code:
local msg_txt = "has"
if matches[2] == "You" then msg_txt = "have" end

printGameMessage("Demonfire", matches[2] .. " " .. msg_txt .. " demonfire!", "red", "white")