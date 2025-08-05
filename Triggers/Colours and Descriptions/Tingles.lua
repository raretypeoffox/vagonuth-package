-- Trigger: Tingles 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #aa007f
-- mBgColour: transparent

-- Trigger Patterns:
-- 0 (regex): ^You feel more confidence in your ability with (.*)\.$
-- 1 (regex): ^Your mastery of (.*) has improved!$

-- Script Code:
if StatTable.Level == 250 then return end

printGameMessage("Tingle!", matches[2], "purple", "yellow")
TingleBeep()

raiseEvent("OnTingle", matches[2])
