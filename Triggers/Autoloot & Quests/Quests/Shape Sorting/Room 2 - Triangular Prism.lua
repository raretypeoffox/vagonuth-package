-- Trigger: Room 2 - Triangular Prism 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The three-sided hole extends straight down, keeping the same
-- 1 (start of line): shape down below.

-- Script Code:
--The three-sided hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Triangular Prism]")