-- Trigger: Profile reset 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Casting (brimstone|torment|maelstrom|disintegrate|comfort) requires knowledge, and you will NEVER learn it!$

-- Script Code:
ProfileResetWait = ProfileResetWait or false

if ProfileResetWait then return end

printGameMessage("Profile Reset", "Attempted to cast a spell this class shouldn't attempt, reseting profile")
safeTempTimer("ProfileResetTimerID", 300, function() ProfileResetWait = nil; end)
Init.GlobalVars()