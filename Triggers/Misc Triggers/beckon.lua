-- Trigger: beckon 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) beckons for you to follow

-- Script Code:
if (StatTable.Position == "Sleep") then send("stand") end
send("fol " .. matches[2])
QuickBeep()
printGameMessage("QuickBeep", "You were beckoned by " .. matches[2])