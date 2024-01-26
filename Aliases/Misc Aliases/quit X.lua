-- Alias: quit X
-- Attribute: isActive

-- Pattern: ^quit (\d+)$

-- Script Code:
-- Command to exit mudlet in X minutes
-- Handy for when you want to idle for a bit before logging off
-- Profile is saved before exiting

local timetowait = tonumber(matches[2])*60

print("Mudlet will exit in " .. matches[2] .. " minutes. Saving profile...")
RunStats.EchoSession()
saveProfile()
SaveProfileVars()
safeTempTimer("QuitXID", timetowait, function() saveProfile(); raiseEvent("OnQuit"); send("quit") end)
safeTempTimer("CloseMudletID", timetowait+5, function() closeMudlet() end)

