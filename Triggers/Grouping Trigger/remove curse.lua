-- Trigger: remove curse 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (lua function): if(StatTable.Class == "Sorcerer" or StatTable.Class == "Cleric") then return true end
-- 1 (regex): ^\*?(\w+)\*? tells the group 'rc'$

-- Script Code:
Battle.DoAfterCombat("cast 'remove curse' " .. multimatches[2][2])