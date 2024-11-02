-- Trigger: A darkenbeast feeds on a burnt corpse. 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (substring): A darkenbeast feeds on a burnt corpse.
-- 1 (substring): A blurred denizen steps out of the wasteland, savage and hungry!

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Sandblasted Emerald]")