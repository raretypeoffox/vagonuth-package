-- Trigger: Other fails to rescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) fails to rescue (\w+)!

-- Script Code:
--if ((StatTable.current_health / StatTable.max_health) > 0.40 and matches[3] ~= "you" and StatTable.Sanctuary) then
  --send("rescue " .. matches[3])
--end

AR.Rescue(string.lower(matches[3]))

