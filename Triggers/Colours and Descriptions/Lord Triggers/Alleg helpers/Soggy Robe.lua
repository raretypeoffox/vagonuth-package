-- Trigger: Soggy Robe 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (start of line): (Demonic) (Black Aura) The animated corpse of Faraday wanders here.
-- 1 (start of line):    (Demonic) (Black Aura) The animated corpse of Faraday wanders here.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Soggy Robe]")