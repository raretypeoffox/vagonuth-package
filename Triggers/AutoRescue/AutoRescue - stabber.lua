if AR.RescueList[string.lower(matches[2])] and not Battle.Combat then
  send("rescue " .. matches[2])
--else
  --AR.Rescue(string.lower(matches[2]))
end