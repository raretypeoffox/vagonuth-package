send("gtell Found |N|... |BW|" .. GlobalVar.AutoTrackTarget .. "|N|!")
if (GlobalVar.AutoTrack == "kill") then send(GlobalVar.KillStyle .. " " .. GlobalVar.AutoTrackTarget) end
GlobalVar.AutoTrackTarget = ""