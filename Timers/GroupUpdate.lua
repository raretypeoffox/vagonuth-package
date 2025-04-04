-- Timer: GroupUpdate
-- Attribute: isActive

-- Time: 00:00:01.000

-- Script Code:
if IsMDAY() and not GroupLeader() then
  GroupUpdateTicks = GroupUpdateTicks or 0
  if GroupUpdateTicks >= 5 then
    sendGMCP("Char.Group.List")
    GroupUpdateTicks = 0
  else
    GroupUpdateTicks = GroupUpdateTicks + 1
  end
else
  sendGMCP("Char.Group.List")
end