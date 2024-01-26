-- Trigger: Get Ammo from Cor 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): is DEAD!!

-- Script Code:
local ammotype

if (StatTable.Class == "Fusilier") then
  ammotype = "sling stones"
elseif (StatTable.Class == "Archer" or StatTable.Class == "Druid" or StatTable.Class == "Assassin") then
  ammotype = "arrows"
elseif (StatTable.Class == "Soldier") then
  ammotype = "bolts"
else
  ammotype = "nil"
end

-- Change ammotype to your preferred type if you wish to override class defaults above
-- ammotype = "bolts"
-- ammotype = "bullets"

if ammotype ~= "nil" then
  send("get '" .. ammotype .. "' corpse")
end
