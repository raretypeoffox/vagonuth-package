-- Trigger: AutoFletch-tool 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): You lack the proper tools.
-- 1 (substring): You discard your empty toolkit.

-- Script Code:
send("wear fletch")
send(GlobalVar.LastFletch)
send("score") 
