-- Alias: questpoints
-- Attribute: isActive

-- Pattern: ^(?i)qp(?: (.*))?$

-- Script Code:
local cmd = string.sub(matches[1], 3)
cmd = "questpoints" .. cmd
send(cmd,false)