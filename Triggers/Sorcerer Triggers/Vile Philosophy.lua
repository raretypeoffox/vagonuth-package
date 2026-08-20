if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupLeader ~= "") then
  if StatTable.Fortitude then
    OnMobDeathQueue("cast 'vile philosophy'")
  end
end