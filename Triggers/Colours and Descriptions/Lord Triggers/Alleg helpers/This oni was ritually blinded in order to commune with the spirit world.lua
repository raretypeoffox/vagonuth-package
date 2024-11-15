-- Trigger: This oni was ritually blinded in order to commune with the spirit world. 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): This oni was ritually blinded in order to commune with the spirit world.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Blindfold]")