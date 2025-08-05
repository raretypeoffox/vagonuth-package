-- Script: Fail Count
-- Attribute: isActive

-- Script Code:
--=============================================================================
-- FailCount module for any spell — configurable at the top
--=============================================================================

FailCount = FailCount or {}

-- ────────────── Configuration ──────────────

FailCount.SpellName      = "identify" -- arcane
--FailCount.SpellName = "magic light"
--FailCount.SpellName      = "detect poison" -- divine
FailCount.SpellName      = string.lower(FailCount.SpellName)
--FailCount.SpellCastCmd   = "cast '" .. FailCount.SpellName .. "'"
FailCount.SpellCastCmd   = "cast '" .. FailCount.SpellName .. "' spear"

FailCount.SuccessPattern = "^Object 'heavy spear ocean' type weapon, extra flags glow hum anti-evil"
--FailCount.SuccessPattern = "^Object 'crude spear lordgear' type weapon, extra flags nolocate\.$"
--FailCount.SuccessPattern = "^It doesn't look poisoned\.$"
--FailCount.SuccessPattern = "^You twiddle your thumbs and The Light of \.w+'s Soul appears on you\.$"

FailCount.FailPattern    = "^You failed your " .. FailCount.SpellName .. " due to lack of concentration\!"
FailCount.OOMPattern     = "^You do not have enough mana to cast " .. FailCount.SpellName .. "\."

FailCount.LogFile        = getMudletHomeDir() .. "/failcount_results.txt"
FailCount.TriesMax       = FailCount.TriesMax       or 20000
FailCount.LogInterval    = FailCount.LogInterval    or 100
FailCount.PracticeRate   = FailCount.PracticeRate   or 0

--────────────────────────────────────────────────────────────────────────────────

-- running totals for *current block*
FailCount.Success      = FailCount.Success      or 0
FailCount.Fail         = FailCount.Fail         or 0

-- global try count & state
FailCount.Tries        = FailCount.Tries        or 0
FailCount.Status       = FailCount.Status       or false

-- remember which try we last logged
FailCount.LastLoggedTry = FailCount.LastLoggedTry or 0


function FailCount.CheckIfBlockComplete()
  if FailCount.Tries % FailCount.LogInterval == 0 then
    FailCount.LogResults()
    FailCount.LastLoggedTry = FailCount.Tries
    FailCount.Success,FailCount.Fail = 0,0
  end
end

function FailCount._record(which)
  if which=="success" then FailCount.Success = FailCount.Success+1
  else FailCount.Fail = FailCount.Fail+1 end
  
  FailCount.Tries=FailCount.Tries+1
  
  FailCount.CheckIfBlockComplete()
  FailCount.ShowResults()
  FailCount.TryNext()
end
function FailCount.RecordSuccess() FailCount._record("success") end
function FailCount.RecordFail()    FailCount._record("fail")    end


function FailCount.ShowResults()
  local block_tries = (FailCount.Success + FailCount.Fail)
  local sRate = FailCount.Tries > 0 and (FailCount.Success / block_tries)*100 or 0
  local fRate = FailCount.Tries > 0 and (FailCount.Fail    / block_tries)*100 or 0

  sRate = math.floor(sRate*10 + 0.5)/10
  fRate = math.floor(fRate*10 + 0.5)/10

  printMessage("\nFailCount",
    string.format(
      "Success: %4d (%.1f%%) | Fail: %4d (%.1f%%) | Tries: %d | Prac: %d",
      FailCount.Success, sRate,
      FailCount.Fail,    fRate,
      FailCount.Tries, FailCount.PracticeRate
    )
  )
end

function FailCount.TryNext()
  if not FailCount.Status then return end
  if FailCount.Tries >= FailCount.TriesMax then
    printMessage("FailCount",
      "Reached max tries ("..FailCount.TriesMax.."). Stopping."
    )
    return FailCount.Reset()
  end

  send("score")
  send(FailCount.SpellCastCmd)
end

-- Replace your old OnTingle with this:
function FailCount.OnTingle(event, arg, profile)
  if not FailCount.Status then return end

  if arg ~= FailCount.SpellName then
    -- unexpected tingle: abort
    FailCount.Status = false
    return
  end
  
  if FailCount.Tries > FailCount.LastLoggedTry then
    FailCount.LogResults()
    FailCount.LastLoggedTry = FailCount.Tries
  end

  FailCount.PracticeRate = FailCount.PracticeRate + 1

  FailCount.Success, FailCount.Fail = 0, 0

  printMessage("FailCount",
    string.format(
      "Tingle! New practice rate: %d%% — continuing...",
      FailCount.PracticeRate
    )
  )

end

-- No longer call Reset() or Init() here!
-- You still register it in Init:
safeEventHandler("FailCountOnTingle", "OnTingle", FailCount.OnTingle, false)


function FailCount.Init(tries)
  -- reset counters & config
  FailCount.TriesMax = tries or FailCount.TriesMax
  FailCount.Success  = 0
  FailCount.Fail     = 0
  FailCount.Tries    = 0
  FailCount.LastLoggedTry = 0
  FailCount.PracticeRate = 0
  FailCount.Status   = true
  
  send("slearn " .. FailCount.SpellName)

  safeTempTrigger("FailCountSuccess",
    FailCount.SuccessPattern,
    function() if FailCount.Status then FailCount.RecordSuccess() end end,
    "regex"
  )

  safeTempTrigger("FailCountFail",
    FailCount.FailPattern,
    function() if FailCount.Status then FailCount.RecordFail() end end,
    "regex"
  )

  safeTempTrigger("FailCountOOM",
    FailCount.OOMPattern,
    function()
      if not FailCount.Status then return end
      send("sleep")
      local sleep_timer = (StatTable.Level == 125 and 300 or 120)
      tempTimer(sleep_timer, function()
        send("wake")
        FailCount.TryNext()
      end)
    end,
    "regex"
  )
  
  safeTempTrigger("FailCountPracticeRate",
    "^You have practiced " .. FailCount.SpellName .. " to (\\d+) percent",
    function()
      FailCount.PracticeRate = matches[2]
    end,
    "regex"
  )
  
  safeEventHandler("FailCountOnTingle", "OnTingle", FailCount.OnTingle, false)
  
  FailCount._charname = StatTable.CharName
  safeEventHandler("FailCountOnDisconnect", "sysDisconnectionEvent", function()
    if FailCount.Status then
      reconnect()
    end  
  end, true)
  
  safeEventHandler("FailCountOnReconnect", "sysConnectionEvent", function()
    if FailCount.Status then
      tempTimer(5, [[send(FailCount._charname)]])
      tempTimer(10, [[send("look")]])
      tempTimer(10, [[FailCount.TryNext()]])
    end
  end, true)
  
  FailCount.TryNext()
end

function FailCount.Reset()
  -- log any leftover that hasn't yet been recorded
  if FailCount.Tries > FailCount.LastLoggedTry then
    FailCount.LogResults()
    FailCount.LastLoggedTry = FailCount.Tries
  end

  FailCount.Status = false
  FailCount.ShowResults()

  safeKillTrigger("FailCountSuccess")
  safeKillTrigger("FailCountFail")
  safeKillTrigger("FailCountOOM")
  safeKillTrigger("FailCountTooManyLights")
  safeKillTrigger("FailCountPracticeRate")
  safeKillEventHandler("FailCountOnTingle")

end

function FailCount.LogResults()
  if not FailCount._headerCheck then 
    local needHeader = false
  
    local check, err = io.open(FailCount.LogFile, "r")
    if not check then
      needHeader = true
    else
      local first = check:read(1)
      if not first then
        needHeader = true
      end
      check:close()
    end
  
    if needHeader then
      local h = io.open(FailCount.LogFile, "a")
      h:write(
        "Timestamp\tCharName\tRace\tClass\tSpell\tPracticeRate\tSuccess\tFail\n"
      )
      h:close()
    end
    FailCount._headerCheck = true
  end

  local f, err = io.open(FailCount.LogFile, "a")
  if not f then
    cecho("<red>Error opening log: "..err.."\n")
    return
  end

  local ts    = os.date("%Y-%m-%dT%H:%M:%S")
  local name  = StatTable.CharName or "Unknown"
  local race  = StatTable.Race     or "Unknown"
  local cls   = StatTable.Class    or "Unknown"

  f:write(string.format(
    "%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\n",
    ts, name, race, cls, FailCount.SpellName, FailCount.PracticeRate,
    FailCount.Success,
    FailCount.Fail
  ))
  f:close()
end




