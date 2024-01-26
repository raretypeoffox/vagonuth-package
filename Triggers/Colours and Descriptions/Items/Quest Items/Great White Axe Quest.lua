-- Trigger: Great White Axe Quest 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a broken large axe blade
-- 1 (substring): a broken and warped axe blade
-- 2 (substring): a broken axe blade
-- 3 (substring): a broken axe shaft
-- 4 (substring): a broken axe head
-- 5 (substring): a broken blackened axe shaft
-- 6 (substring): a broken axe handle burned white

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Great White Axe]")