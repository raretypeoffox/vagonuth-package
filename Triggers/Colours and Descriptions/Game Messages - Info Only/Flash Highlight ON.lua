if matches[2]:lower() ~= "someone" and not IsGroupMate(matches[2]) and not IsAbomination(matches[2]) then
  printGameMessageVerbose("Mob Flashed!", matches[2])
end