-- Trigger: Re-bash 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) stands and faces (.*) enemies!

-- Script Code:
StatTable.Bash = "Up"
send("bash")
--enableTrigger("Failed Bash")