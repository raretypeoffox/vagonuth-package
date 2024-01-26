-- Trigger: Out of Ammo - nothing to shoot 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You have nothing to shoot!

-- Script Code:
if (GlobalVar.ReloadType ~= nil) then
  send("wear '" .. GlobalVar.ReloadType .. "'")
else
  if (StatTable.Class == "Fusilier") then
    send("wear stone")
  elseif (StatTable.Class == "Soldier") then
    send("wear bolt")
  else
    send("wear arrow")
  end
end