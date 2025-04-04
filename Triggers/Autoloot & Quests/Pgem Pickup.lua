-- Trigger: Pgem Pickup 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) gets a perfect (diamond|emerald|ruby|amethyst|sapphire)\.$

-- Script Code:
if (GlobalVar.GroupMates[GMCP_name(matches[2])]) then
  printGameMessage("PGEM!", "Perfect " .. matches[3] .. " picked up by " .. matches[2], "purple", "white")
  --if (StatTable.Level < 125 and not GlobalVar.Silent) then
  --  send("gtell |BW|" .. matches[2] .. "|N| picks up the perfect |BP|" .. matches[3] .. "|N|!")
  --end
end