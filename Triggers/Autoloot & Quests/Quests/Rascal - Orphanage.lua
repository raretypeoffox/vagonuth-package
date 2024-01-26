-- Trigger: Rascal - Orphanage 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): An orphan holds something that OBVIOUSLY doesn't belong to them.

-- Script Code:
send("tickle rascal")
tempTimer(1, [[send("tickle rascal")]])
tempTimer(4,[[send("where rascal")]])