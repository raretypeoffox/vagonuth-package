-- Script: CheckMissing
-- Attribute: isActive

-- Script Code:
function CheckMissingGtell()
  local MissingPlayers = CheckMissing()

  if (next(MissingPlayers) == nil) then
    send("gtell |BW|All players accounted for!|N|")
  else
    local missing = ""
    for i=1,#MissingPlayers do
      missing = missing .. MissingPlayers[i] .. " "
    end
    send("gtell |BW|Missing: |Y|" .. missing .. "|N|")
  end
end

function CheckMissingEcho()
  local MissingPlayers = CheckMissing()
  
  if (next(MissingPlayers) == nil) then
    cecho("GroupChat","<yellow>All players accounted for!\n")
  else
    local missing = ""
      for i=1,#MissingPlayers do
        missing = missing .. MissingPlayers[i] .. " "
      end
      cecho("GroupChat","<white>Missing: <yellow>" .. missing .. "\n")
  end

end

function CheckMissing()

  local RoomPlayers = {}
  local GroupPlayers = {}
  local MissingPlayers = {}
  
  -- Add all groupmates to GroupPlayers
  for k,v in ipairs(gmcp.Char.Group.List) do
    table.insert(GroupPlayers,string.lower(v.name))
  end
  
  -- Only add Playable Characters in room to RoomPlayers
  for k,v in pairs(gmcp.Room.Players) do
    if (tonumber(v.name) == nil) then
      table.insert(RoomPlayers,string.lower(v.name))
    end
  end
  
  -- For Each GroupMate, check if they are in the room
  --for k,v in pairs(GroupPlayers) do
  for i=1,#GroupPlayers do
    if (ArrayHasValue(RoomPlayers,GroupPlayers[i]) == false) then
      table.insert(MissingPlayers,GroupPlayers[i])
    end
  end
  
  return MissingPlayers
end


