-- Trigger: Auto-continue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): [B]ack,[H]elp,[R]efresh, or [C]ontinue:

-- Script Code:
deleteLine()
send("c",false)