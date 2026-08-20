local groupie_attacker = GMCP_name(matches.attacker)
if GlobalVar.GroupMates[groupie_attacker] then
  DamageCounter.AddDmg(matches.attacker, "nil")
else
  local abom_name = DamageCounter.ExtractAbomination and DamageCounter.ExtractAbomination(matches.attacker)
  local groupie_victim = GMCP_name(matches.victim)
  if groupie_victim == "You" then groupie_victim = GMCP_name(StatTable.CharName) end
  local victim_is_groupie = (GlobalVar.GroupMates and GlobalVar.GroupMates[groupie_victim]) or (groupie_victim == GMCP_name(StatTable.CharName))
  if abom_name and not victim_is_groupie then
    DamageCounter.AddDmg(abom_name, "nil")
  end
end