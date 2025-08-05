-- Trigger: air hammer rc 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) utters the words, 'air hammer'\.$

-- Script Code:
local rc_target = matches[2]
if IsClass({"Sorcerer", "Cleric", "Vizier", "Druid"}) and not Battle.Combat and tonumber(gmcp.Char.Vitals.lag) == 0 then
  TryAction("cast 'remove curse' " .. rc_target, 5)
end