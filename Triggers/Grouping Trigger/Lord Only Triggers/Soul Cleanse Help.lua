-- Trigger: Soul Cleanse Help 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<caster>\w+) begins the chant to cleanse (?<target>\w+)'s soul\.\.\.$

-- Script Code:
if GMCP_name(matches.caster) == StatTable.CharName then return; end

if IsClass({"Cleric", "Paladin", "Monk", "Priest", "Druid", "Vizier"}) then
  TryAction("cast 'soul cleanse' " .. matches.target, 5)
end