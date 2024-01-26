-- Alias: disable torch
-- Attribute: isActive

-- Pattern: ^(c|cast) (tor|tor (.*))$

-- Script Code:
-- Command to realias cast tor to cast torment rather than cast torch
-- To solve my problem of constantly throwing my torch at mobs as a Sorcerer :)
-- e.g., "cast tor elf" will cast torment, not torch on the elf

local target
if matches[3] == "tor" then target = "" else target = string.sub(matches[3], 4) end
send("cast torment" .. target,false)