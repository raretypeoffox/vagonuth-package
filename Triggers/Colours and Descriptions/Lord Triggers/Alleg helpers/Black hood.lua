-- Trigger: Black hood 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (substring): A black robed githzerai stands here watching his pupils.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Black hood]")