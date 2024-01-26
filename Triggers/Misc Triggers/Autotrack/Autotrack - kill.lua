-- Trigger: Autotrack - kill 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You have found your quarry!!

-- Script Code:
send("gtell Found |N|... |BW|" .. GlobalVar.AutoTrackTarget .. "|N|!")
if (GlobalVar.AutoTrack == "kill") then send(GlobalVar.KillStyle .. " " .. GlobalVar.AutoTrackTarget) end
GlobalVar.AutoTrackTarget = ""