-- Trigger: Get Ammo on Ground 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^     A brace of (piercing|splinter|explosive|poison|Sableroix|green) (.*) are lying on the ground.$
-- 1 (regex): (piercing|splinter|explosive|poison|Sableroix|green) (.*) just now!

-- Script Code:
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

