-- Trigger: Room 2 - Frustum 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The indentation appears to be a perfect circle that gets
-- 1 (start of line): smaller and smaller until the hole ends at a smaller circle.

-- Script Code:
--The three-sided hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Frustum]")