-- Trigger: RunStats - XP Gain 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You receive (\d+) experience points.$
-- 1 (regex): ^You have received an award of (\d+) experience points!$

-- Script Code:
RunStats.RunXp = (RunStats.RunXp + matches[2])
RunStats.RunKills = RunStats.RunKills + 1
RunXPLabel:echo(RunStats.RunXp)
RunKillsLabel:echo(RunStats.RunKills)