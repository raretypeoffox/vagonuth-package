-- Script: RunStats
-- Attribute: isActive

-- Script Code:
-- rewrite 24 Nov 23

RunStats = RunStats or {}

-- Run XP
RunStats.CharName = RunStats.CharName or ""

RunStats.RunXp = RunStats.RunXp or 0
RunStats.RunKills = RunStats.RunKills or 0
RunStats.RunLevels = RunStats.RunLevels or 0
RunStats.RunHP = RunStats.RunHP or 0
RunStats.RunMP = RunStats.RunMP or 0
RunStats.RunMV = RunStats.RunMV or 0
RunStats.RunPrac = RunStats.RunPrac or 0
RunStats.RunHealXp = RunStats.RunHealXp or 0
RunStats.RunStartLevel = RunStats.RunStartLevel or 0
RunStats.SpellLevelProcs = RunStats.SpellLevelProcs or 0
if (RunStats.RunStartLevel == 0) then
  tempTimer(15, function() if StatTable.Level ~= nil and StatTable.Level < 51 then RunStats.RunStartLevel = StatTable.Level else RunStats.RunStartLevel = StatTable.SubLevel end end)
end

if GlobalVar.GUI then
  RunXPLabel:echo(RunStats.RunXp)
  RunKillsLabel:echo(RunStats.RunKills)
  RunLevelsLabel:echo(RunStats.RunLevels .. " Levels")
  RunStatsLabel:echo(RunStats.RunHP .. "HP / " .. RunStats.RunMP .. "MP" )
end

-- TODO: consider a check on StatTable.CharName to deal with gmcp issues

-- TODO: will be rewriting SessionXP to track seperately for each character
-- We will be using an array of tables, one for each character, eg., RunStats.SessionsXP[CharName] = 0
RunStats.SessionXp = RunStats.SessionXp or {}

function RunStats.SessionXpInit(char_name)
  if RunStats.SessionXp[char_name] then return false; end

  RunStats.SessionXp[char_name] = {}
  RunStats.SessionXp[char_name].SessionXp = 0
  RunStats.SessionXp[char_name].SessionKills = 0
  RunStats.SessionXp[char_name].SessionLevels = 0
  RunStats.SessionXp[char_name].SessionHP = 0
  RunStats.SessionXp[char_name].SessionMP = 0
  RunStats.SessionXp[char_name].SessionMV = 0
  RunStats.SessionXp[char_name].SessionPrac = 0
  RunStats.SessionXp[char_name].SessionHealXp = 0
  RunStats.SessionXp[char_name].SessionStartLevel = 0

  return true
end


function InitSessionXPOnLogin()
  -- Initialize the Session XP table if this is our first time logging in with this character this session
  RunStats.SessionXpInit(StatTable.CharName)

  -- Set the characters session start level if it hasn't been set yet
  if (RunStats.SessionXp[StatTable.CharName].SessionStartLevel == 0) then
    safeTempTimer("RunStatsInit", 5, function() 
      if StatTable.Level ~= nil and StatTable.Level < 51 then 
        RunStats.SessionXp[StatTable.CharName].SessionStartLevel = StatTable.Level 
      else 
        RunStats.SessionXp[StatTable.CharName].SessionStartLevel = StatTable.SubLevel 
      end
    end)
  end
  
end


safeEventHandler("InitSessionXPOnLoginID", "CustomProfileInit", "InitSessionXPOnLogin", false)
safeEventHandler("KillRunStatsInitOnDisco", "sysDisconnectionEvent", function() RunStats.Reset(); safeKillTimer("RunStatsInit"); safeKillTimer("RunStatsInit2") end, false)


function RunStats.Reset()
  RunStats.CharName = StatTable.CharName
  local char_name = RunStats.CharName

  if not RunStats.SessionXp[char_name]  then RunStats.SessionXpInit(char_name) end
  RunStats.SessionXp[char_name].SessionXp = RunStats.SessionXp[char_name].SessionXp + RunStats.RunXp
  RunStats.SessionXp[char_name].SessionKills = RunStats.SessionXp[char_name].SessionKills + RunStats.RunKills
  RunStats.SessionXp[char_name].SessionLevels = RunStats.SessionXp[char_name].SessionLevels + RunStats.RunLevels
  RunStats.SessionXp[char_name].SessionHP = RunStats.SessionXp[char_name].SessionHP + RunStats.RunHP
  RunStats.SessionXp[char_name].SessionMP = RunStats.SessionXp[char_name].SessionMP + RunStats.RunMP
  RunStats.SessionXp[char_name].SessionMV = RunStats.SessionXp[char_name].SessionMV + RunStats.RunMV
  RunStats.SessionXp[char_name].SessionPrac = RunStats.SessionXp[char_name].SessionPrac + RunStats.RunPrac
  RunStats.SessionXp[char_name].SessionHealXp = RunStats.SessionXp[char_name].SessionHealXp + RunStats.RunHealXp
  RunStats.RunXp = 0
  RunStats.RunKills = 0
  RunStats.RunLevels = 0
  RunStats.RunHP = 0
  RunStats.RunMP = 0
  RunStats.RunMV = 0
  RunStats.RunPrac = 0
  RunStats.RunHealXp = 0
  RunStats.SpellLevelProcs = 0
  tempTimer(5, function() if StatTable.Level ~= nil and StatTable.Level < 51 then RunStats.RunStartLevel = StatTable.Level else RunStats.RunStartLevel = StatTable.SubLevel end end)
  RunXPLabel:echo(RunStats.RunXp)
  RunKillsLabel:echo(RunStats.RunKills)
  RunLevelsLabel:echo(RunStats.RunLevels .. " Levels")
  RunStatsLabel:echo(RunStats.RunHP .. "HP / " .. RunStats.RunMP .. "MP" )
end

safeEventHandler("RunResetOnInit", "CustomProfileInit", RunStats.Reset, false)

function RunStats.Report()
  send("gtell |R|XP Gained: |BP|".. format_int(RunStats.RunXp) .. "|R| Kills: |BW|".. RunStats.RunKills .. " |R|HP/MP Gained: |BW|" .. RunStats.RunHP .. "|N|/|BW|" .. RunStats.RunMP .. "|R| Levels: |BW|".. RunStats.RunLevels .. "|N|")
end

function RunStats.Echo()
  print("XP Gained: ".. format_int(RunStats.RunXp) .. " Kills: ".. RunStats.RunKills .. " HP/MP Gained: " .. RunStats.RunHP .. "/" .. RunStats.RunMP .. " Levels: ".. RunStats.RunLevels .. "\n")
end

function RunStats.ReportSession(char_name)
  local char_name = char_name or StatTable.CharName
  send("gtell |R|SESSION XP Gained: |BP|".. format_int(RunStats.SessionXp[char_name].SessionXp + RunStats.RunXp) .. "|R| Kills: |BW|".. (RunStats.SessionXp[char_name].SessionKills + RunStats.RunKills) .. " |R|HP/MP Gained: |BW|" .. (RunStats.SessionXp[char_name].SessionHP + RunStats.RunHP) .. "|N|/|BW|" .. (RunStats.SessionXp[char_name].SessionMP + RunStats.RunMP) .. "|R| Levels: |BW|".. RunStats.SessionXp[char_name].SessionLevels + RunStats.RunLevels .. "|N|")
end

function RunStats.EchoSession(char_name)
  local char_name = char_name or StatTable.CharName
  print(string.format("%-15sSESSION Stats: XP: %s Kills: %d HP/MP Gained: %d/%d Levels: %d\n",
                    char_name,
                    format_int(RunStats.SessionXp[char_name].SessionXp + RunStats.RunXp),
                    RunStats.SessionXp[char_name].SessionKills + RunStats.RunKills,
                    RunStats.SessionXp[char_name].SessionHP + RunStats.RunHP,
                    RunStats.SessionXp[char_name].SessionMP + RunStats.RunMP,
                    RunStats.SessionXp[char_name].SessionLevels + RunStats.RunLevels))
end

function RunStats.EchoSessionAll()
  local default_formatting = "%-15s%10s%10s%10s%15s%15s\n"
  cecho(string.format(default_formatting, "Character", "XP Earned", "Kills", "Levels", "HP/MP Gains", "Avg Gains"))
  cecho("----------------------------------------------------------------------------\n")
  
  for char_name, _ in pairs(RunStats.SessionXp) do
      if RunStats.SessionXp[char_name].SessionXp > 0 or StatTable.CharName == char_name then
        
        local formatStr = 
                      (string.format(default_formatting,
                      char_name,
                      
                      format_int(RunStats.SessionXp[char_name].SessionXp + tonumber((StatTable.CharName == char_name) and RunStats.RunXp or 0)),
                      
                      RunStats.SessionXp[char_name].SessionKills + tonumber((StatTable.CharName == char_name) and RunStats.RunKills or 0),
                      
                      RunStats.SessionXp[char_name].SessionLevels + tonumber((StatTable.CharName == char_name) and RunStats.RunLevels or 0),                
                      
                      string.format("%s / %s", RunStats.SessionXp[char_name].SessionHP + tonumber((StatTable.CharName == char_name) and RunStats.RunHP or 0),
                      RunStats.SessionXp[char_name].SessionMP + tonumber((StatTable.CharName == char_name) and RunStats.RunMP or 0)),
                      
                      ((RunStats.SessionXp[char_name].SessionLevels + tonumber((StatTable.CharName == char_name) and RunStats.RunLevels or 0) > 0) and
                      
                      string.format("%.2f / %.2f", 
                      (RunStats.SessionXp[char_name].SessionHP + tonumber((StatTable.CharName == char_name) and RunStats.RunHP or 0))/
                      (RunStats.SessionXp[char_name].SessionLevels + tonumber((StatTable.CharName == char_name) and RunStats.RunLevels or 0)),
                      
                      
                      (RunStats.SessionXp[char_name].SessionMP + tonumber((StatTable.CharName == char_name) and RunStats.RunMP or 0))/
                      (RunStats.SessionXp[char_name].SessionLevels + tonumber((StatTable.CharName == char_name) and RunStats.RunLevels or 0))) 
                      or "0.00 / 0.00")                 
                      
                      
                      ))
        cecho(formatStr)
      end
  end
end



