local rc_target = matches[2]
if IsClass({"Sorcerer", "Cleric", "Vizier", "Druid"}) and not Battle.Combat and tonumber(gmcp.Char.Vitals.lag) == 0 then
  TryAction("cast 'remove curse' " .. rc_target, 5)
end