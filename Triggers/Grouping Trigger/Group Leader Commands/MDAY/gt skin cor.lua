-- Trigger: gt skin cor 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^skin (\d+)?.?cor

-- Script Code:
if IsNotClass({"Archer", "Soldier", "Fusilier"}) then return end

if AltList.Chars[StatTable.CharName].Worship ~= "Durr" then return end


send(matches[1])