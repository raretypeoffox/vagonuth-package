--if ((StatTable.current_health / StatTable.max_health) > 0.40 and matches[3] ~= "you" and StatTable.Sanctuary) then
  --send("rescue " .. matches[3])
--end

AR.Rescue(string.lower(matches[3]))

