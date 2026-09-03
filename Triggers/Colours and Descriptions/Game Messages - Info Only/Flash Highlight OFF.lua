if matches[2]:lower() ~= "someone" and not IsGroupMate(matches[2]) and not IsAbomination(matches[2]) then
  printGameMessageVerbose("Mob Eyes Clear!", matches[2])
end