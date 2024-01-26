-- Trigger: Pgem 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) leaves behind a perfect (diamond|emerald|ruby|amethyst|sapphire)!$

-- Script Code:
if not (GlobalVar.GroupMates[GMCP_name(matches[2])]) then
  send("get " .. matches[3])
  printGameMessage("PGEM!", "Perfect " .. matches[3] .. " left behind", "purple", "white")
  --if (StatTable.Level < 125 and not GlobalVar.Silent) then
  --  send("gtell |BP|o|P|oOO|BP|oo|P|OO|BP|oo|P|O|BP|Oo|P|o |N|a |BW|perfect " .. matches[3] .. "|N|!")
  --end
end




