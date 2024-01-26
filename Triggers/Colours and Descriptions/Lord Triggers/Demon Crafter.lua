-- Trigger: Demon Crafter 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): (Black Aura) A demon chisels obscenities about Bo'vul onto the wall.

-- Script Code:
cecho (string.rep (" ",70-tonumber(string.len(line))) .. "<yellow> [Crafter]")