-- Trigger: Other Revive 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^(\w+)'s body appears to be reviving itself!$

-- Script Code:
--Beburos's body appears to be reviving itself!
printGameMessageVerbose("Combat", matches[2] .. " is reviving!")