-- Trigger: Room 3 - Hexagonal Prism 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The six-sided hole extends straight down, keeping the same
-- 1 (start of line): shape down below.

-- Script Code:
cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Hexagonal Prism]")