-- Trigger: Quaff 


-- Trigger Patterns:
-- 0 (substring): a sliver of boiled tree bark
-- 1 (substring): a potion of crushed rose petals
-- 2 (substring): glacial Milk
-- 3 (substring): a murky grey vial

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<white> [Quaff]")