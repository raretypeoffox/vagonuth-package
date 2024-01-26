-- Trigger: Room 1 - Cylinder 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The circular hole extends straight down, keeping the same
-- 1 (start of line): shape down below.

-- Script Code:
--The square hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Cylinder]")