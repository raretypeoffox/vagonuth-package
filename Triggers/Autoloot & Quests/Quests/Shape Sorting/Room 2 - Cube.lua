-- Trigger: Room 2 - Cube 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The interior of the indentation is perfectly regular. Each of the
-- 1 (start of line): cube hole's five square sides meets at a right angle.

-- Script Code:
--The three-sided hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Cube]")