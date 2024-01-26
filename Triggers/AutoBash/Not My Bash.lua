-- Trigger: Not My Bash 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) bashes into (.*) and (.*) goes down!
-- 1 (regex): ^(.*) struggles to stand, but fails!

-- Script Code:
StatTable.Bash = "Down"
--disableTrigger("Failed Bash")