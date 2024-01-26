-- Trigger: Pgem passed by you 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You give a perfect (diamond|emerald|ruby|amethyst|sapphire) to (\w+).$

-- Script Code:
printGameMessage("PGEM!", "You passed the perfect " .. matches[2] .. " to " .. matches[3], "purple", "white")

--if (GlobalVar.GroupMates[GMCP_name(matches[2])]  and StatTable.Level < 125 and not GlobalVar.Silent) then
--  send("gtell |BW| I |N| passed the perfect |BP|" .. matches[2] .. "|N| to |BW|" .. matches[3] .. "|N|. Congrats ".. matches[3] .."!")
--end