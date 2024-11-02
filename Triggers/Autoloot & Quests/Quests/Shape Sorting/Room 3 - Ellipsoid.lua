-- Trigger: Room 3 - Ellipsoid 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The egg-shaped cavity may have given birth to one of the
-- 1 (start of line): creatures wandering about.

-- Script Code:
cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Ellipsoid]")