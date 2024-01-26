-- Trigger: RunStats - Level Gain 
-- Attribute: isActive
-- Attribute: isSoundTrigger


-- Trigger Patterns:
-- 0 (regex): ^Your gain is: (\d+)\/(\d+) hp, (\d+)\/(\d+) m, (\d+)\/(\d+) mv (\d+)\/(\d+) prac.
-- 1 (regex): ^You raise a level!!  Your gain is: (\d+)\/(\d+) hp, (\d+)\/(\d+) m, (\d+)\/(\d+) mv (\d+)\/(\d+) prac.

-- Script Code:
RunStats.RunLevels = (RunStats.RunLevels + 1)
RunStats.RunHP = (RunStats.RunHP + matches[2])
RunStats.RunMP = (RunStats.RunMP + matches[4])
RunStats.RunMV = (RunStats.RunMV + matches[6])
RunStats.RunPrac = (RunStats.RunPrac + matches[8])
RunLevelsLabel:echo(RunStats.RunLevels .. " Levels")
RunStatsLabel:echo(RunStats.RunHP .. "HP / " .. RunStats.RunMP .. "MP" )

RunStats.HPGain = matches[2]
RunStats.HPMax = matches[3]
RunStats.MPGain = matches[4]
RunStats.MPMax = matches[5]
RunStats.MVGain = matches[6]
RunStats.MVMax = matches[7]
RunStats.PracGain = matches[8]
RunStats.PracMax = matches[9]

-- TODO: rewrite level DB someday
--tempTimer( 5, [[DBman.AddNewLevel(gmcp.Char.Status.character_name,gmcp.Char.Status.race,gmcp.Char.Status.class,gmcp.Char.Status.level,gmcp.Char.Status.sublevel,gmcp.Char.Status.area_name)]] )


if not GlobalVar.Silent then send("emote gained |BR|".. matches[2] .."|R| hp, |BB|" .. matches[4] .." |B|mana|N|, and |BW|" .. matches[8] .. "|W| pracs|N|.") end


printGameMessage("Level!", StatTable.CharName .. " [" .. (RunStats.RunStartLevel + RunStats.RunLevels) .. "]: " .. matches[2] .. "HP / " .. matches[4] .. "Ma")