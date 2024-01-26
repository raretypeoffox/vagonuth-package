-- Trigger: Room 1 - Tetrahedron 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The hole is a perfect triangle shape with triangular, wedged sides cut
-- 1 (start of line): into the wall.

-- Script Code:
--The square hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Tetrahedron]")