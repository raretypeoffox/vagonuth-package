-- Trigger: mass fly 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): mass fly

-- Script Code:
if IsNotClass({"Wizard", "Mage"}) then return end
if StatTable.Level < 125 and StatTable.SubLevel < 500 then return end

TryAction("cast 'mass fly", 5)