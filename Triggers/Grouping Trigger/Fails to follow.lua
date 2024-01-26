-- Trigger: Fails to follow 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) fails to follow$

-- Script Code:
if not GlobalVar.Silent then send("gtell |BR|" .. matches[2] .. " fails to follow!|N|") end

