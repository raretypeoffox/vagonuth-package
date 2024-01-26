-- Trigger: Death Shroud down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): The grey shroud of death fades.

-- Script Code:
if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupLeader ~= "") then
  if StatTable.Fortitude then
    OnMobDeathQueue("cast 'death shroud'")
  end
end