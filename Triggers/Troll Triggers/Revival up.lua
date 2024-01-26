-- Trigger: Revival up 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You start to revive yourself!

-- Script Code:
if not GlobalVar.Silent then send("gtell |BW|Revival|N| is |BY|UP|N|") end