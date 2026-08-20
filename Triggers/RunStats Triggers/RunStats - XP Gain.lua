RunStats.RunXp = (RunStats.RunXp + matches[2])
RunStats.RunKills = RunStats.RunKills + 1
RunXPLabel:echo(RunStats.RunXp)
RunKillsLabel:echo(RunStats.RunKills)

--^You gain (\d+) experience points for aiding your team in winning this epoch
--^You gain (\d+) experience points for aiding your team in conquering this node