-- Trigger: Tingles 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #aa007f
-- mBgColour: transparent

-- Trigger Patterns:
-- 0 (regex): ^You feel more confidence in your ability with (.*)\.$
-- 1 (regex): ^Your mastery of (.*) has improved!$

-- Script Code:
printGameMessage("Tingle!", matches[2], "purple", "yellow")
TingleBeep()
