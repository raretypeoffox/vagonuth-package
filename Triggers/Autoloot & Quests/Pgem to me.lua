-- Trigger: Pgem to me 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) gives you a perfect (diamond|emerald|ruby|amethyst|sapphire).$

-- Script Code:
if IsMDAY() then send("put perfect pgem") end

printGameMessage("PGEM!", matches[2] .. " passes the perfect " .. matches[3] .. " to me", "purple", "white")

--if (GlobalVar.GroupMates[GMCP_name(matches[2])]  and StatTable.Level < 125 and not GlobalVar.Silent) then
--  send("gtell |BW|" .. matches[2] .. "|N| passes the perfect |BP|" .. matches[3] .. "|N| to |BW|me|N|. Thank you ".. matches[2] .."!")
--end