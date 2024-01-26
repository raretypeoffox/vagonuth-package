-- Trigger: Earth Boss 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): Larger than all the others, this juggernaut bellows a challenge.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<purple> [BOSS] Jug")