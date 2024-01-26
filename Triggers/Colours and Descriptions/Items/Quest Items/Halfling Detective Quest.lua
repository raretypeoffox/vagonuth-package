-- Trigger: Halfling Detective Quest 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a commission to explore the mountains
-- 1 (substring): a torn out journal entry
-- 2 (substring): a misty elixir
-- 3 (substring): This misty elixir emits a soft glow.
-- 4 (substring): A halfling searches the area for clues
-- 5 (substring): This half-orc walks nervously up the mountain.
-- 6 (substring): A halfling slave has fled

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Halfling]")