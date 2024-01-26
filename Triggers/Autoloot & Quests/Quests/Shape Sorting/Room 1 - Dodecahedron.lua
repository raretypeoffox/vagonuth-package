-- Trigger: Room 1 - Dodecahedron 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The depression has a pentagonal shape with eleven of the exacting
-- 1 (start of line): same shape revealed inside the hole.

-- Script Code:
--The square hole extends straight down, keeping the same
--shape down below.

cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Dodecahedron]")