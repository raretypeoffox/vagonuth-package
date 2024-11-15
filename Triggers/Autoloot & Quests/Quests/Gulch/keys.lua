-- Trigger: keys 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): golden scarab medallion
-- 1 (substring): well-maintained pickaxe
-- 2 (substring): A heap of ancient stoneworking tools lies here, slowly turning to rust.
-- 3 (substring): This elegant key consists of interlocking metallic leaves.
-- 4 (substring): the key to the royal burial chamber

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .."<yellow> [key]")