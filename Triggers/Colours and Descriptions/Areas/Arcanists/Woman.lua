-- Trigger: Woman 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A mist of frost follows in the wake of this woman's pale blue robe.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<yellow> Woman")