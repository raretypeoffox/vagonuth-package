-- Trigger: lock - picked 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): pick the lock on a small wooden lockbox

-- Script Code:
send("open lockbox" .. getCommandSeparator() .. "get all lockbox" .. getCommandSeparator() .. "drop lockbox" .. getCommandSeparator() .. "sac lockbox" .. getCommandSeparator() .. "inspect lockbox")