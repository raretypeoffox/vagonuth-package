-- Trigger: Vile Philosophy 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You purge your mind of some of your darker thoughts.

-- Script Code:
if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupLeader ~= "") then
  if StatTable.Fortitude then
    OnMobDeathQueue("cast 'vile philosophy'")
  end
end