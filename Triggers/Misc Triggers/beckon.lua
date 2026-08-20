if IsMDAY() then 
  if (StatTable.Position == "Sleep") then send("stand") end
  send("fol " .. matches[2])
else
  QuickBeep()
  printGameMessage("QuickBeep", "You were beckoned by " .. matches[2])
  send("fol " .. matches[2]) -- AGENT TODO: Remove this line
end
