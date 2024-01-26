-- Trigger: Quiet Rooms 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Spire of Knowledge Apex

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<red> [QUIET]")