-- Trigger: rescue trigger on emote 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) is killing (\w+).

-- Script Code:
if (AR.Status and StatTable.CharName ~= matches[2]) then
  AR.Rescue(string.lower(matches[2]))
end
