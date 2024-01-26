-- Trigger: Room 1 - Rhombus 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The hole looks like a cube would fit inside if it has been
-- 1 (start of line): warped slightly from its perfect shape.

-- Script Code:
--The square hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Rhombus]")