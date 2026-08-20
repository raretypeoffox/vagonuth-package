if GMCP_name(matches.caster) == StatTable.CharName then return; end

if IsClass({"Cleric", "Paladin", "Monk", "Priest", "Druid", "Vizier"}) then
  TryAction("cast 'soul cleanse' " .. matches.target, 5)
end