-- Trigger: Recommend Rites 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line):     resist pain
-- 1 (start of line):     bloodlust

-- Script Code:
selectCurrentLine()
replace("")
cecho(line .. "<red>+<reset><yellow>*<reset>")
deselect()
