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
RunStats.RunQuickenSuccess = RunStats.RunQuickenSuccess or 0
RunStats.RunQuickenFail = RunStats.RunQuickenFail or 0
RunStats.RunSurgeSuccess = RunStats.RunSurgeSuccess or 0
RunStats.RunSurgeFail = RunStats.RunSurgeFail or 0
RunStats.RunSurgeProcs = RunStats.RunSurgeProcs or 0
RunStats.RunLagReduceProcs = RunStats.RunLagReduceProcs or 0
RunStats.RunSpellCostProcs = RunStats.RunSpellCostProcs or 0
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
  RunStats.SessionXp[char_name].QuickenSuccess = 0
  RunStats.SessionXp[char_name].QuickenFail = 0
  RunStats.SessionXp[char_name].SurgeSuccess = 0
  RunStats.SessionXp[char_name].SurgeFail = 0
  RunStats.SessionXp[char_name].SurgeProcs = 0
  RunStats.SessionXp[char_name].LagReduceProcs = 0
  RunStats.SessionXp[char_name].SpellCostProcs = 0

  return true
end

function RunStats.AddQuickenSuccess()
  RunStats.RunQuickenSuccess = (RunStats.RunQuickenSuccess or 0) + 1
end

function RunStats.AddQuickenFail()
  RunStats.RunQuickenFail = (RunStats.RunQuickenFail or 0) + 1
end

function RunStats.AddSurgeSuccess()
  RunStats.RunSurgeSuccess = (RunStats.RunSurgeSuccess or 0) + 1
end

function RunStats.AddSurgeFail()
  RunStats.RunSurgeFail = (RunStats.RunSurgeFail or 0) + 1
end

function RunStats.AddSurgeProc()
  RunStats.RunSurgeProcs = (RunStats.RunSurgeProcs or 0) + 1
  RunStats.SpellLevelProcs = RunStats.RunSurgeProcs
end

function RunStats.AddLagReductionProc()
  RunStats.RunLagReduceProcs = (RunStats.RunLagReduceProcs or 0) + 1
end

function RunStats.AddSpellCostReductionProc()
  RunStats.RunSpellCostProcs = (RunStats.RunSpellCostProcs or 0) + 1
end

function RunStats.FormatCastingStat(success, fail)
  local s = tonumber(success) or 0
  local f = tonumber(fail) or 0
  local total = s + f
  if total == 0 then
    return "0/0 (N/A)"
  end
  local pct = (s / total) * 100
  return string.format("%d/%d (%.1f%%)", s, f, pct)
end

function RunStats.EchoCastingRun()
  local qSucc = RunStats.RunQuickenSuccess or 0
  local qFail = RunStats.RunQuickenFail or 0
  local sSucc = RunStats.RunSurgeSuccess or 0
  local sFail = RunStats.RunSurgeFail or 0
  local surgeProc = RunStats.RunSurgeProcs or 0
  local lagProc = RunStats.RunLagReduceProcs or 0
  local costProc = RunStats.RunSpellCostProcs or 0

  if (qSucc + qFail > 0) or (sSucc + sFail > 0) then
    cecho(string.format("<cyan>Run Casting:     <yellow>Quicken: <white>%s | <yellow>Surge: <white>%s\n",
      RunStats.FormatCastingStat(qSucc, qFail),
      RunStats.FormatCastingStat(sSucc, sFail)))
  end

  if (surgeProc > 0) or (lagProc > 0) or (costProc > 0) then
    cecho(string.format("<cyan>Weapon Procs:    <yellow>Surge Might: <white>%d | <yellow>Lag Reduction: <white>%d | <yellow>Cost Reduction: <white>%d\n",
      surgeProc, lagProc, costProc))
  end
end

function RunStats.EchoCastingSession(char_name)
  local char_name = char_name or StatTable.CharName
  if not char_name or not RunStats.SessionXp[char_name] then return end
  local sess = RunStats.SessionXp[char_name]
  local isCurrent = (StatTable.CharName == char_name)
  local qSucc = (sess.QuickenSuccess or 0) + (isCurrent and (RunStats.RunQuickenSuccess or 0) or 0)
  local qFail = (sess.QuickenFail or 0) + (isCurrent and (RunStats.RunQuickenFail or 0) or 0)
  local sSucc = (sess.SurgeSuccess or 0) + (isCurrent and (RunStats.RunSurgeSuccess or 0) or 0)
  local sFail = (sess.SurgeFail or 0) + (isCurrent and (RunStats.RunSurgeFail or 0) or 0)
  local surgeProc = (sess.SurgeProcs or 0) + (isCurrent and (RunStats.RunSurgeProcs or 0) or 0)
  local lagProc = (sess.LagReduceProcs or 0) + (isCurrent and (RunStats.RunLagReduceProcs or 0) or 0)
  local costProc = (sess.SpellCostProcs or 0) + (isCurrent and (RunStats.RunSpellCostProcs or 0) or 0)

  if (qSucc + qFail > 0) or (sSucc + sFail > 0) then
    cecho(string.format("<cyan>Session Casting: <yellow>Quicken: <white>%s | <yellow>Surge: <white>%s\n",
      RunStats.FormatCastingStat(qSucc, qFail),
      RunStats.FormatCastingStat(sSucc, sFail)))
  end

  if (surgeProc > 0) or (lagProc > 0) or (costProc > 0) then
    cecho(string.format("<cyan>Session Procs:   <yellow>Surge Might: <white>%d | <yellow>Lag Reduction: <white>%d | <yellow>Cost Reduction: <white>%d\n",
      surgeProc, lagProc, costProc))
  end
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

  if not RunStats.SessionXp[char_name] then RunStats.SessionXpInit(char_name) end
  RunStats.SessionXp[char_name].SessionXp = RunStats.SessionXp[char_name].SessionXp + RunStats.RunXp
  RunStats.SessionXp[char_name].SessionKills = RunStats.SessionXp[char_name].SessionKills + RunStats.RunKills
  RunStats.SessionXp[char_name].SessionLevels = RunStats.SessionXp[char_name].SessionLevels + RunStats.RunLevels
  RunStats.SessionXp[char_name].SessionHP = RunStats.SessionXp[char_name].SessionHP + RunStats.RunHP
  RunStats.SessionXp[char_name].SessionMP = RunStats.SessionXp[char_name].SessionMP + RunStats.RunMP
  RunStats.SessionXp[char_name].SessionMV = RunStats.SessionXp[char_name].SessionMV + RunStats.RunMV
  RunStats.SessionXp[char_name].SessionPrac = RunStats.SessionXp[char_name].SessionPrac + RunStats.RunPrac
  RunStats.SessionXp[char_name].SessionHealXp = RunStats.SessionXp[char_name].SessionHealXp + RunStats.RunHealXp
  RunStats.SessionXp[char_name].QuickenSuccess = (RunStats.SessionXp[char_name].QuickenSuccess or 0) + (RunStats.RunQuickenSuccess or 0)
  RunStats.SessionXp[char_name].QuickenFail = (RunStats.SessionXp[char_name].QuickenFail or 0) + (RunStats.RunQuickenFail or 0)
  RunStats.SessionXp[char_name].SurgeSuccess = (RunStats.SessionXp[char_name].SurgeSuccess or 0) + (RunStats.RunSurgeSuccess or 0)
  RunStats.SessionXp[char_name].SurgeFail = (RunStats.SessionXp[char_name].SurgeFail or 0) + (RunStats.RunSurgeFail or 0)
  RunStats.SessionXp[char_name].SurgeProcs = (RunStats.SessionXp[char_name].SurgeProcs or 0) + (RunStats.RunSurgeProcs or 0)
  RunStats.SessionXp[char_name].LagReduceProcs = (RunStats.SessionXp[char_name].LagReduceProcs or 0) + (RunStats.RunLagReduceProcs or 0)
  RunStats.SessionXp[char_name].SpellCostProcs = (RunStats.SessionXp[char_name].SpellCostProcs or 0) + (RunStats.RunSpellCostProcs or 0)

  RunStats.RunXp = 0
  RunStats.RunKills = 0
  RunStats.RunLevels = 0
  RunStats.RunHP = 0
  RunStats.RunMP = 0
  RunStats.RunMV = 0
  RunStats.RunPrac = 0
  RunStats.RunHealXp = 0
  RunStats.SpellLevelProcs = 0
  RunStats.RunQuickenSuccess = 0
  RunStats.RunQuickenFail = 0
  RunStats.RunSurgeSuccess = 0
  RunStats.RunSurgeFail = 0
  RunStats.RunSurgeProcs = 0
  RunStats.RunLagReduceProcs = 0
  RunStats.RunSpellCostProcs = 0

  tempTimer(5, function() if StatTable.Level ~= nil and StatTable.Level < 51 then RunStats.RunStartLevel = StatTable.Level else RunStats.RunStartLevel = StatTable.SubLevel end end)
  if GlobalVar.GUI then
    RunXPLabel:echo(RunStats.RunXp)
    RunKillsLabel:echo(RunStats.RunKills)
    RunLevelsLabel:echo(RunStats.RunLevels .. " Levels")
    RunStatsLabel:echo(RunStats.RunHP .. "HP / " .. RunStats.RunMP .. "MP" )
  end
end

safeEventHandler("RunResetOnInit", "CustomProfileInit", RunStats.Reset, false)

function RunStats.Report()
  send("gtell |R|XP Gained: |BP|".. format_int(RunStats.RunXp) .. "|R| Kills: |BW|".. RunStats.RunKills .. " |R|HP/MP Gained: |BW|" .. RunStats.RunHP .. "|N|/|BW|" .. RunStats.RunMP .. "|R| Levels: |BW|".. RunStats.RunLevels .. "|N|")
  RunStats.EchoCastingRun()
end

function RunStats.Echo()
  cecho(string.format("<cyan>Run Stats:       <yellow>XP: <white>%s | <yellow>Kills: <white>%s | <yellow>HP/MP Gained: <white>%s/%s | <yellow>Levels: <white>%s\n",
    format_int(tonumber(RunStats.RunXp) or 0),
    tostring(RunStats.RunKills or 0),
    tostring(RunStats.RunHP or 0),
    tostring(RunStats.RunMP or 0),
    tostring(RunStats.RunLevels or 0)))
  RunStats.EchoCastingRun()
end

function RunStats.ReportSession(char_name)
  local char_name = char_name or StatTable.CharName
  send("gtell |R|SESSION XP Gained: |BP|".. format_int(RunStats.SessionXp[char_name].SessionXp + RunStats.RunXp) .. "|R| Kills: |BW|".. (RunStats.SessionXp[char_name].SessionKills + RunStats.RunKills) .. " |R|HP/MP Gained: |BW|" .. (RunStats.SessionXp[char_name].SessionHP + RunStats.RunHP) .. "|N|/|BW|" .. (RunStats.SessionXp[char_name].SessionMP + RunStats.RunMP) .. "|R| Levels: |BW|".. RunStats.SessionXp[char_name].SessionLevels + RunStats.RunLevels .. "|N|")
end

function RunStats.EchoSession(char_name)
  local char_name = char_name or StatTable.CharName
  if not char_name or not RunStats.SessionXp[char_name] then return end
  local sess = RunStats.SessionXp[char_name]
  local isCurrent = (StatTable.CharName == char_name)
  local xp = (sess.SessionXp or 0) + (isCurrent and (RunStats.RunXp or 0) or 0)
  local kills = (sess.SessionKills or 0) + (isCurrent and (RunStats.RunKills or 0) or 0)
  local hp = (sess.SessionHP or 0) + (isCurrent and (RunStats.RunHP or 0) or 0)
  local mp = (sess.SessionMP or 0) + (isCurrent and (RunStats.RunMP or 0) or 0)
  local levels = (sess.SessionLevels or 0) + (isCurrent and (RunStats.RunLevels or 0) or 0)

  cecho(string.format("\n<cyan>Session Stats:   <yellow>[<white>%s<yellow>] XP: <white>%s | <yellow>Kills: <white>%s | <yellow>HP/MP Gained: <white>%s/%s | <yellow>Levels: <white>%s\n",
    char_name,
    format_int(tonumber(xp) or 0),
    tostring(kills),
    tostring(hp),
    tostring(mp),
    tostring(levels)))
  RunStats.EchoCastingSession(char_name)
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

  -- Display casting stats section if any casting activity or procs were recorded
  local hasCasting = false
  for char_name, sess in pairs(RunStats.SessionXp) do
    local isCurrent = (StatTable.CharName == char_name)
    local qTotal = (sess.QuickenSuccess or 0) + (sess.QuickenFail or 0) + (isCurrent and ((RunStats.RunQuickenSuccess or 0) + (RunStats.RunQuickenFail or 0)) or 0)
    local sTotal = (sess.SurgeSuccess or 0) + (sess.SurgeFail or 0) + (isCurrent and ((RunStats.RunSurgeSuccess or 0) + (RunStats.RunSurgeFail or 0)) or 0)
    local pTotal = (sess.SurgeProcs or 0) + (sess.LagReduceProcs or 0) + (sess.SpellCostProcs or 0) + (isCurrent and ((RunStats.RunSurgeProcs or 0) + (RunStats.RunLagReduceProcs or 0) + (RunStats.RunSpellCostProcs or 0)) or 0)
    if qTotal > 0 or sTotal > 0 or pTotal > 0 then
      hasCasting = true
      break
    end
  end

  if hasCasting then
    cecho("\n<cyan>Session Casting Stats & Weapon Procs:\n")
    local casting_formatting = "%-15s%-25s%-25s%-30s\n"
    cecho(string.format(casting_formatting, "Character", "Quicken (Succ/Fail/Rate)", "Surge (Succ/Fail/Rate)", "Weapon Procs (Surge/Lag/Cost)"))
    cecho("----------------------------------------------------------------------------------------------------\n")
    for char_name, sess in pairs(RunStats.SessionXp) do
      local isCurrent = (StatTable.CharName == char_name)
      local qSucc = (sess.QuickenSuccess or 0) + (isCurrent and (RunStats.RunQuickenSuccess or 0) or 0)
      local qFail = (sess.QuickenFail or 0) + (isCurrent and (RunStats.RunQuickenFail or 0) or 0)
      local sSucc = (sess.SurgeSuccess or 0) + (isCurrent and (RunStats.RunSurgeSuccess or 0) or 0)
      local sFail = (sess.SurgeFail or 0) + (isCurrent and (RunStats.RunSurgeFail or 0) or 0)
      local surgeProc = (sess.SurgeProcs or 0) + (isCurrent and (RunStats.RunSurgeProcs or 0) or 0)
      local lagProc = (sess.LagReduceProcs or 0) + (isCurrent and (RunStats.RunLagReduceProcs or 0) or 0)
      local costProc = (sess.SpellCostProcs or 0) + (isCurrent and (RunStats.RunSpellCostProcs or 0) or 0)
      local pTotal = surgeProc + lagProc + costProc
      if (qSucc + qFail > 0) or (sSucc + sFail > 0) or pTotal > 0 or StatTable.CharName == char_name then
        local procsStr = string.format("%d / %d / %d", surgeProc, lagProc, costProc)
        cecho(string.format(casting_formatting,
          char_name,
          RunStats.FormatCastingStat(qSucc, qFail),
          RunStats.FormatCastingStat(sSucc, sFail),
          procsStr))
      end
    end
  end
end



