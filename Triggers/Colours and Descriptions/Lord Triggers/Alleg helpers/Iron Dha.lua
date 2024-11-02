-- Trigger: Iron Dha 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): Staggering to and fro, a sunburnt wretch begs for death.
-- 1 (substring): Whipping his own bloody back, a poor soul lurches about.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [Iron dha]")