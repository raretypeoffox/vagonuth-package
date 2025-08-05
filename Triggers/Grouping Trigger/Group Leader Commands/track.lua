-- Trigger: track 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): track (\w+)

-- Script Code:
if GlobalVar.AutoTrack == "echo" then
  TryAction("track " .. matches[2], 1)
  GlobalVar.AutoTrackTarget = matches[2]
end