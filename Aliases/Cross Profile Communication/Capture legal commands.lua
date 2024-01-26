-- Alias: Capture legal commands
-- Attribute: isActive

-- Pattern: ^#(?i)(\bbid\b|\bdo\b|\bcpc\b|\bsay\b|\ball\b|\bhelp\b|\bversion\b|\becho\b|\btell\b)(?-i)\s*(.*)$

-- Script Code:
local cmd = matches[2]
local args = matches[3]

cpc:handleCommand(cmd,args)