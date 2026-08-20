local DeadPlayer = matches[2]

-- Not our groupmate, return

if not GlobalVar.GroupMates[GMCP_name(DeadPlayer)] or GMCP_name(DeadPlayer) == StatTable.CharName then return end

-- Provide a game message
printGameMessage("Death!", DeadPlayer .. " was immo'd!!", "red", "white")
QuickBeep()