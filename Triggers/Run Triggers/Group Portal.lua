-- Trigger: Group Portal 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'pp (.*)'$

-- Script Code:

if IsClass({"Mage", "Cleric", "Wizard", "Druid", "Stormlord"}) then
    -- Viz not in list due to often popping portals
    -- Prs is out of class    

  if StatTable.current_mana > 100 then
    send("cast portal " .. matches[2])
    if not GlobalVar.Silent then send("gtell ool") end
  else
    printGameMessage("Group Portal", "mana less than 100, portal not cast")
  end
end

