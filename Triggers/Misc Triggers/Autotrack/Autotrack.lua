-- Trigger: Autotrack 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You see your quarry's trail head (\w+) from here!

-- Script Code:
if (GlobalVar.AutoTrack == "on" or GlobalVar.AutoTrack == "kill") then
  send(matches[2])
elseif (GlobalVar.AutoTrack == "echo") then
  if (GlobalVar.AutoTrackTarget ~= "") then
    send("gtell Tracking |BW|" .. GlobalVar.AutoTrackTarget .. "|N|... |BR|" .. matches[2] .. "|N|!")
  else
    send("gtell Tracking |N|... |BR|" .. matches[2] .. "|N|!")
  end
end