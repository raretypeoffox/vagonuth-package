-- Trigger: Room 3 - Square Pyramid 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The cavity appears to be a perfect square that gets
-- 1 (start of line): smaller and smaller until the hole ends at a point.

-- Script Code:
cecho (string.rep (" ",70-tonumber(string.len(line))) .."<yellow> [Square Pyramid]")