-- Trigger: Required Rites 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line):     might
-- 1 (start of line):     deathblow
-- 2 (start of line):     prime strike
-- 3 (start of line):     rage control

-- Script Code:

selectCurrentLine()
replace("")
cecho(line .. "<red>+<reset>")
deselect()



