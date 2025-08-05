-- Trigger: AutoFletch-tool 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You lack the proper tools.

-- Script Code:
send("wear fletch")
send(GlobalVar.LastFletch)
send("score") 
