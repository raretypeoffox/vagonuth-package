-- Alias: Up
-- Attribute: isActive

-- Pattern: ^(u|up)$

-- Script Code:
local dir = string.lower(matches[2])

AddDir(dir)
send(dir,false)

if GroupLeader() and Grouped() then
  send("scan", false)
end