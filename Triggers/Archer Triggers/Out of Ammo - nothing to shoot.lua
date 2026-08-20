if (GlobalVar.ReloadType ~= nil) then
  TryAction("wear '" .. GlobalVar.ReloadType .. "'", 30)
else
  if (StatTable.Class == "Fusilier") then
    TryAction("wear stone", 30)
  elseif (StatTable.Class == "Soldier") then
    TryAction("wear bolt", 30)
  else
    TryAction("wear arrow", 30)
  end
end