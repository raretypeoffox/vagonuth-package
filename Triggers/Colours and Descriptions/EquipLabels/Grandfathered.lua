-- Trigger: Grandfathered 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a Magical Kangaroo Pouch
-- 1 (substring): the girdle of might
-- 2 (substring): a fire red choker
-- 3 (substring): poison clan insignia
-- 4 (substring): gauntlets of ogre power
-- 5 (substring): thieves patch

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<pink> [Grandfathered]")