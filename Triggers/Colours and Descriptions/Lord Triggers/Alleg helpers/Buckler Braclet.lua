-- Trigger: Buckler Braclet 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A she-Fae gazes at the moon.
-- 1 (substring): Lithe and Graceful, a black-skinned Fae dances in the garden.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Buckler Bracelet]")