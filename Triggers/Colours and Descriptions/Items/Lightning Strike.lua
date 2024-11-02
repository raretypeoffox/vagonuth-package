-- Trigger: Lightning Strike 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a length of chain and an anchor
-- 1 (substring): a long, crystal shaft

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<green> [Lightning Strike]")