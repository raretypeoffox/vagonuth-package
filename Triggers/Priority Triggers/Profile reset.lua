ProfileResetWait = ProfileResetWait or false

if ProfileResetWait then return end

printGameMessage("Profile Reset", "Attempted to cast a spell this class shouldn't attempt, reseting profile")
safeTempTimer("ProfileResetTimerID", 300, function() ProfileResetWait = nil; end)
Init.GlobalVars()