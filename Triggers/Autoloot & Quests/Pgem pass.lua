-- Trigger: Pgem pass 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) gives a perfect (diamond|emerald|ruby|amethyst|sapphire) to (\w+)\.$

-- Script Code:
printGameMessage("PGEM!", matches[2] .. " passes the perfect " .. matches[3] .. " to " .. matches[4], "purple", "white")

--if (GlobalVar.GroupMates[GMCP_name(matches[2])] and StatTable.Level < 125 and not GlobalVar.Silent) then
  --send("gtell |BW|" .. matches[2] .. "|N| passes the perfect |BP|" .. matches[3] .. "|N| to |BW|" .. matches[4] .. "|N|!")
--end