-- Trigger: Wall vanishes 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^An imp grabs an (?<dir>\w+) wall of thorns and vanishes.$

-- Script Code:
--An imp grabs an eastern wall of thorns and vanishes.

-- test for up and down?

local dir = matches.dir:sub(1,1)
send("cast wall " .. dir)
