-- Trigger: inpu turnin 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a stray chess piece
-- 1 (substring): handle of a broken knife

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .."<yellow> [inpu turnin]")