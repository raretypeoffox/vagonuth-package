local ammotype = nil
if (StatTable.Class == "Fusilier") then
  ammotype = "sling stones"
elseif (StatTable.Class == "Archer" or StatTable.Class == "Druid") then
  ammotype = "arrows"
elseif (StatTable.Class == "Soldier") then
  ammotype = "bolts"
end

-- Change ammotype to your preferred type if you wish to override class defaults above
-- ammotype = "bolts"
-- ammotype = "bullets"
if (ammotype ~= nil) then
  if (ammotype == matches[3]) then
    send("get '" .. matches[3] .. "'")
  end
end

