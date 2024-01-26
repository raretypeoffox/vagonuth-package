-- Trigger: RunStats - Heal XP 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Tul-Sith grants you (\d+) exp!

-- Script Code:
RunStats.RunXp = RunStats.RunXp + tonumber(matches[2])
RunStats.RunHealXp = RunStats.RunHealXp + tonumber(matches[2])
RunXPLabel:echo(RunStats.RunXp)
