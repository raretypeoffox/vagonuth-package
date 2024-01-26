-- Trigger: Cure Poison 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) shivers and suffers.$

-- Script Code:
-- Stay out of lag if rescueing
if AR.Status then return; end
if Battle.Combat then return; end

-- Stay out of lag if leading the group
if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupMates[GMCP_name(matches[2])] and StatTable.current_mana > 100) then

  -- Do you have access to cure poison? Excluded caster classes (as it'll interupt their casting) and Viz (could mess up their mana management)
  if (StatTable.Class == "Cleric" or StatTable.Class == "Druid" or StatTable.Class == "Warrior" or StatTable.Class == "Paladin" or 
      StatTable.Class == "Rogue" or StatTable.Class == "Monk"or StatTable.Class == "Archer" or StatTable.Class == "Soldier" or 
      StatTable.Class == "Fusilier" or StatTable.Class == "Assassin" or StatTable.Class == "Black Circle Initiate" or StatTable.Class == "Rogue") then
    
    TryAction("cast 'cure poison' " .. matches[2], 5)
  end
end

