-- hack for legends for now, remove this trigger later (handled by buffmanager)
if StatTable.Level ~= 250 then return end

if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupLeader ~= "") then
  if StatTable.Fortitude then
    OnMobDeathQueue("cast mystical")
  end
end
