-- Trigger: Summon Planar Anchor 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+ begins to summon the Planar Anchor!$

-- Script Code:
if StatTable.Class == "Mage" or
  StatTable.Class == "Cleric" or
  StatTable.Class == "Paladin" or
  StatTable.Class == "Psionicist" or
  StatTable.Class == "Sorcerer" or
  StatTable.Class == "Priest" or
  StatTable.Class == "Wizard" or
  StatTable.Class == "Mindbender" or
  StatTable.Class == "Druid" or
  StatTable.Class == "Stormlord" then
  TryAction("cast 'planar anchor' summon", 30)
end
