-- Trigger: beckon 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) beckons for you to follow

-- Script Code:
if IsMDAY() then 
  if (StatTable.Position == "Sleep") then send("stand") end
  send("fol " .. matches[2])
else
  QuickBeep()
  printGameMessage("QuickBeep", "You were beckoned by " .. matches[2])
end