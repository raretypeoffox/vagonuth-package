-- Trigger: Room 2 - Sphere 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): It appears that a globe would be needed to fill the hole.

-- Script Code:
--The three-sided hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Sphere]")