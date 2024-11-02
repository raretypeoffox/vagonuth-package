-- Trigger: Pgem - Art Blessing 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) leaves behind a perfect (diamond|emerald|ruby|amethyst|sapphire) due to an artificer blessing!$

-- Script Code:
if not (GlobalVar.GroupMates[GMCP_name(matches[2])]) then
  send("get " .. matches[3])
  printGameMessage("PGEM!", "Perfect " .. matches[3] .. " left behind due to artificer blessing", "purple", "white")

end




