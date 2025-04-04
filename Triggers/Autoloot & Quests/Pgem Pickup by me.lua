-- Trigger: Pgem Pickup by me 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You get a perfect (diamond|emerald|ruby|amethyst|sapphire)\.$

-- Script Code:
if (Grouped() and not GroupLeader()) then
  printGameMessage("PGEM!", "Perfect " .. matches[2] .. " picked up by me!", "purple", "white")
  send("give " .. matches[2] .. " " .. (IsMDAY() and StaticVars.PGemHolder or GlobalVar.GroupLeader))
end