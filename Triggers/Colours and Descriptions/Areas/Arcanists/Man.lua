-- Trigger: Man 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): Sparks dance across the shoulders of this tall man's silvery robe.
-- 1 (substring): Pacing and muttering, this green-robed man frowns thoughtfully.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<yellow> Man")