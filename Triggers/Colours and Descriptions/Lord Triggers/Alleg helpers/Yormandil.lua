-- Trigger: Yormandil 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (substring): A wiry Fae sits here, meditating. A blindfold is tied around his head.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Yorimandil]")