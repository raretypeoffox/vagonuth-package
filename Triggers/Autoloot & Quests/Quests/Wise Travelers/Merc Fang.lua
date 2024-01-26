-- Trigger: Merc Fang 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A large wolf walks through the halls.
-- 1 (substring): mercury wolf fangs

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .."<green> [WT - Metallic]")