-- Trigger: Groupie Immo'd 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.* summons black imps to kill (\w+)!!!$

-- Script Code:
local DeadPlayer = matches.charname

-- Not our groupmate, return

if not GlobalVar.GroupMates[GMCP_name(DeadPlayer)] or GMCP_name(DeadPlayer) == StatTable.CharName then return end

-- Provide a game message
printGameMessage("Death!", DeadPlayer .. " was immo'd!!", "red", "white")