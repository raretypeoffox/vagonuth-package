-- Trigger: bashdoor 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^bd (n|w|e|s|u|d|north|west|east|south|up|down)

-- Script Code:
if StatTable.Level < 250 and IsClass({"Sorcerer", "Soldier", "Priest", "Assassin", "Wizard", "Druid", "Vizier"}) then return end -- these classes don't have bashdoor

TryAction("bashdoor " .. matches[2], 5)