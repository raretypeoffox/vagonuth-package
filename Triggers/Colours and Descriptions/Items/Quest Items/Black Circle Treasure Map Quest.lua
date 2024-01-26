-- Trigger: Black Circle Treasure Map Quest 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): You see three red glowing eyes watching!
-- 1 (substring): A shimmering humanoid outline circles you inquisitively.
-- 2 (substring): A translucent shape changes color to match its surroundings.

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Black Circle]")