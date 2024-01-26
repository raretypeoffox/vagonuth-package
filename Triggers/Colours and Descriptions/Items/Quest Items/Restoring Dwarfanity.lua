-- Trigger: Restoring Dwarfanity 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a silver key
-- 1 (substring): an ornate lockbox
-- 2 (substring): a juicy steak
-- 3 (substring): a half-orc torch
-- 4 (substring): The mammoth iwei guards its den with deadly ferocity.
-- 5 (substring): a luminescent stalk
-- 6 (substring): a baby eyestalk
-- 7 (substring): a limp eyestalk
-- 8 (substring): A small uwei darts by.
-- 9 (substring): A medium uwei eyes you thrice.
-- 10 (substring): A medium uwei swims powerfully through the undercurrents.

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Restoring Dwarfanity]")

-- Stalks required:
-- Mammoth
-- Medium
-- Baby