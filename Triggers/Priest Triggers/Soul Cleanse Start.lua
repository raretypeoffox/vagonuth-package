-- Trigger: Soul Cleanse Start 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'soul cleanse (\w+)

-- Script Code:
--'ritual purification wand crystal'
local CleanseTarget = matches[2]
local BagName
local EquipHeld

if StaticVars.SoulCleanse[StatTable.CharName] then 
  BagName = StaticVars.SoulCleanse[StatTable.CharName][1]
  EquipHeld = StaticVars.SoulCleanse[StatTable.CharName][2]
else
  BagName = StaticVars.SoulCleanse.Defaults[1]
  EquipHeld = StaticVars.SoulCleanse.Defaults[2]
end

-- Only triggers if we're awake
if not (StatTable.Position == "Stand") then return; end

printGameMessage("Soul Cleanse", "Leader requested soul cleanse for " .. CleanseTarget)

send("get 'ritual purification wand crystal' " .. BagName)
send("wear 'ritual purification wand crystal'")
TryAction("cast 'soul cleanse' " .. CleanseTarget, 5)
send("wear " .. EquipHeld)
send("put 'ritual purification wand crystal' " .. BagName)