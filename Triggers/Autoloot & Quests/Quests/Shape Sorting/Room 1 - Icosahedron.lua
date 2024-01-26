-- Trigger: Room 1 - Icosahedron 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): A score of triangles are cut into the white surface.

-- Script Code:
--The square hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Icosahedron]")