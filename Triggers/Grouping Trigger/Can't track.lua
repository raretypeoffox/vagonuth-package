-- Trigger: Can't track 


-- Trigger Patterns:
-- 0 (start of line): You can't sense a trail to

-- Script Code:
if GlobalVar.AutoTrack == "echo" then
  TryAction("gtell Can't sense a trail from here", 5)
end