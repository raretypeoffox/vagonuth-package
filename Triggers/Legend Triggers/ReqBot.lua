-- Trigger: ReqBot 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You dream of (\w+) telling you 'req ?(\w+)?'$
-- 1 (regex): ^(\w+) tells you 'req ?(\w+)?'$

-- Script Code:
if gmcp.Room.Info.name ~= "A Sphere of Silver Light" then return end

-- Determine who is sending the req and for which target.
-- Convert names to lowercase here
local sender = string.lower(matches[2])
local target = (matches[3] == "" or matches[3] == nil) and sender or string.lower(matches[3])

-- Add the new request to our queue.
addReqRequest(sender, target)
