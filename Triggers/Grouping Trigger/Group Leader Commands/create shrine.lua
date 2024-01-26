-- Trigger: create shrine 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): shrine
-- 1 (substring): create shrine

-- Script Code:
if(StatTable.Level == 125) then 
  if(StatTable.Class == "Cleric" or StatTable.Class == "Vizier" or StatTable.Class == "Priest" or StatTable.Class == "Monk" or StatTable.Class == "Druid") then 
    if (StatTable.Position == "Sleep") then send("stand") end
    TryAction("cast 'create shrine'" .. getCommandSeparator() .. "sleep",100)
  end

end
