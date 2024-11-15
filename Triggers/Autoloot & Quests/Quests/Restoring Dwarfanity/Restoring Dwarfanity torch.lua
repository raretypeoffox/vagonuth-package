-- Trigger: Restoring Dwarfanity torch 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A discarded half-orc torch.

-- Script Code:
send("get torch")
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Restoring Dwarfanity]")