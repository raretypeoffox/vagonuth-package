-- Trigger: Group Portal 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'pp (.*)'$

-- Script Code:
if (StatTable.Class == "Mage" or StatTable.Class == "Cleric" or StatTable.Class == "Wizard" or
    StatTable.Class == "Druid" or StatTable.Class == "Stormlord" or StatTable.Class == "Vizier"
    --or StatTable.Class == "Priest" -- Prs is out of class but often helpful
    ) then
    
    

  if StatTable.current_mana > 100 then
    send("cast portal " .. matches[2])
    send("gtell ool")
  else
    if not GlobalVar.Silent then print("Group Portal: mana less than 100, portal not cast") end
  end
end

