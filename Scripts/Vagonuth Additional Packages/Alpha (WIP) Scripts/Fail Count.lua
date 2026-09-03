--=============================================================================
-- FailCount Module for Avatar MUD Spell Fail Testing
--=============================================================================
-- Automatically casts spells, records success/failure rates, monitors mana &
-- sleep regeneration, detects practice tingles, and logs structured batches
-- to failcount_results.txt for statistical analysis (fail_analyzer / wiki_generator).
--
-- Usage in Mudlet:
--   FailCount.Start("identify", 1000, "spear")
--   FailCount.Start("danger scan", 500)
--   FailCount.Start("detect poison", 1000, "water")
--   FailCount.Start("magic light", 200)
--   FailCount.Stop()
--=============================================================================

FailCount = FailCount or {}

-- ────────────── Internal State & Triggers/Timers ──────────────
FailCount._activeTriggers = FailCount._activeTriggers or {}
FailCount._activeTimers   = FailCount._activeTimers or {}
FailCount._activeHandlers = FailCount._activeHandlers or {}

-- ────────────── Helper: Environment Fallbacks ──────────────
function FailCount.Message(title, msg)
  if printMessage then
    printMessage(title, msg)
  elseif cecho then
    cecho(string.format("<cyan>[%s]<reset> %s\n", title or "FailCount", msg or ""))
  else
    print(string.format("[%s] %s", title or "FailCount", msg or ""))
  end
end

function FailCount._tempTrigger(name, pattern, func)
  if safeTempTrigger then
    safeTempTrigger(name, pattern, func, "regex")
  elseif tempRegexTrigger then
    if FailCount._activeTriggers[name] then
      killTrigger(FailCount._activeTriggers[name])
    end
    FailCount._activeTriggers[name] = tempRegexTrigger(pattern, func)
  end
end

function FailCount._killTrigger(name)
  if safeKillTrigger then
    safeKillTrigger(name)
  elseif FailCount._activeTriggers and FailCount._activeTriggers[name] then
    killTrigger(FailCount._activeTriggers[name])
    FailCount._activeTriggers[name] = nil
  end
end

function FailCount._tempTimer(name, interval, func)
  if safeTempTimer then
    safeTempTimer(name, interval, func)
  elseif tempTimer then
    if FailCount._activeTimers[name] then
      killTimer(FailCount._activeTimers[name])
    end
    FailCount._activeTimers[name] = tempTimer(interval, func)
  end
end

function FailCount._killTimer(name)
  if safeKillTimer then
    safeKillTimer(name)
  elseif FailCount._activeTimers and FailCount._activeTimers[name] then
    killTimer(FailCount._activeTimers[name])
    FailCount._activeTimers[name] = nil
  end
end

function FailCount._eventHandler(name, event, func, isOneShot)
  if safeEventHandler then
    safeEventHandler(name, event, func, isOneShot)
  elseif registerAnonymousEventHandler then
    if FailCount._activeHandlers[name] then
      killAnonymousEventHandler(FailCount._activeHandlers[name])
    end
    FailCount._activeHandlers[name] = registerAnonymousEventHandler(event, func, isOneShot)
  end
end

function FailCount._killEventHandler(name)
  if safeKillEventHandler then
    safeKillEventHandler(name)
  elseif FailCount._activeHandlers and FailCount._activeHandlers[name] then
    killAnonymousEventHandler(FailCount._activeHandlers[name])
    FailCount._activeHandlers[name] = nil
  end
end

-- ────────────── Spell Registry (Built-in Presets) ──────────────
FailCount.SpellRegistry = {
  ["identify"] = {
    class = "arcane",
    default_target = "spear",
    build_cmd = function(target)
      local tgt = target or "spear"
      return "cast 'identify' " .. tgt
    end,
    success_pattern = "^Object '"
  },
  ["magic light"] = {
    class = "arcane",
    default_target = nil,
    build_cmd = function()
      return "cast 'magic light'"
    end,
    success_pattern = "^A brilliant ball of light appears"
  },
  ["detect poison"] = {
    class = "divine",
    default_target = "water",
    build_cmd = function(target)
      local tgt = target or "water"
      return "cast 'detect poison' " .. tgt
    end,
    success_pattern = "^It doesn't look poisoned\\."
  },
  ["danger scan"] = {
    class = "psionic",
    default_target = nil,
    build_cmd = function()
      return "cast 'danger scan'"
    end,
    success_pattern = "^You concentrate and survey the area for danger\\.\\.\\."
  }
}

-- ────────────── Core Configuration & Defaults ──────────────
FailCount.SpellName      = FailCount.SpellName or "identify"
FailCount.SpellTarget    = FailCount.SpellTarget or nil
FailCount.SpellCastCmd   = FailCount.SpellCastCmd or "cast 'identify' spear"
FailCount.SuccessPattern = FailCount.SuccessPattern or "^Object '"
FailCount.FailPattern    = FailCount.FailPattern or "^(?:You failed your identify due to lack of concentration!|You lost your concentration\\.)"
FailCount.OOMPattern     = FailCount.OOMPattern or "^You (?:do not|don't) have enough mana"

FailCount.LogFile        = (getMudletHomeDir and getMudletHomeDir() or ".") .. "/failcount_results.txt"
FailCount.TriesMax       = FailCount.TriesMax or 20000
FailCount.LogInterval    = FailCount.LogInterval or 100
FailCount.ScoreInterval  = FailCount.ScoreInterval or 10 -- Send score every 10 tries to prevent spam-kick
FailCount.PracticeRate   = FailCount.PracticeRate or 0

-- ────────────── Running State ──────────────
FailCount.Success        = 0
FailCount.Fail           = 0
FailCount.Tries          = 0
FailCount.Status         = false
FailCount.IsSleeping     = false
FailCount.LastLoggedTry  = 0


-- ────────────── Helper: Configure Active Spell ──────────────
function FailCount.ConfigureSpell(spellName, target, customSuccessPattern)
  if not spellName or type(spellName) ~= "string" then
    spellName = FailCount.SpellName or "identify"
  end

  local sName = string.lower(spellName:match("^%s*(.-)%s*$"))
  FailCount.SpellName = sName
  FailCount.SpellTarget = target

  local preset = FailCount.SpellRegistry[sName]
  if preset then
    FailCount.SpellCastCmd   = preset.build_cmd(target or preset.default_target)
    FailCount.SuccessPattern = customSuccessPattern or preset.success_pattern
  else
    -- Fallback for unlisted/custom spells
    if target and target ~= "" then
      FailCount.SpellCastCmd = string.format("cast '%s' %s", sName, target)
    else
      FailCount.SpellCastCmd = string.format("cast '%s'", sName)
    end
    FailCount.SuccessPattern = customSuccessPattern or "^You cast " .. sName
  end

  -- Auto-generate fail and out-of-mana triggers matching MUD message syntax (PCRE regex)
  FailCount.FailPattern = "^(?:You failed your " .. sName .. " due to lack of concentration|You lost your concentration)"
  FailCount.OOMPattern  = "^You (?:do not|don't) have enough mana"
end

-- Safely configure default spell at startup
FailCount.ConfigureSpell(FailCount.SpellName, FailCount.SpellTarget)


-- ────────────── Position & Sleeping State Helpers ──────────────
function FailCount.SleepIfNotSleeping()
  if not FailCount.IsSleeping then
    send("sleep")
    FailCount.IsSleeping = true
  end
end

function FailCount.WakeIfSleeping()
  if FailCount.IsSleeping then
    send("wake")
    FailCount.IsSleeping = false
  end
end


-- ────────────── Cast Cycle & Block Tracking ──────────────
function FailCount.CheckIfBlockComplete()
  local block_tries = FailCount.Success + FailCount.Fail
  if block_tries >= FailCount.LogInterval then
    FailCount.LogResults()
    FailCount.LastLoggedTry = FailCount.Tries
    FailCount.Success = 0
    FailCount.Fail    = 0
  end
end

function FailCount._record(which)
  if which == "success" then
    FailCount.Success = FailCount.Success + 1
  else
    FailCount.Fail = FailCount.Fail + 1
  end

  FailCount.Tries = FailCount.Tries + 1

  FailCount.CheckIfBlockComplete()
  FailCount.ShowResults()
  FailCount.TryNext()
end

function FailCount.RecordSuccess()
  if FailCount.Status then FailCount._record("success") end
end

function FailCount.RecordFail()
  if FailCount.Status then FailCount._record("fail") end
end

function FailCount.ShowResults()
  local block_tries = FailCount.Success + FailCount.Fail
  local sRate = block_tries > 0 and (FailCount.Success / block_tries) * 100 or 0
  local fRate = block_tries > 0 and (FailCount.Fail    / block_tries) * 100 or 0

  sRate = math.floor(sRate * 10 + 0.5) / 10
  fRate = math.floor(fRate * 10 + 0.5) / 10

  FailCount.Message("\nFailCount",
    string.format(
      "Spell: %s | Success: %4d (%.1f%%) | Fail: %4d (%.1f%%) | Tries: %d/%d | Prac: %d%%",
      FailCount.SpellName,
      FailCount.Success, sRate,
      FailCount.Fail,    fRate,
      FailCount.Tries,   FailCount.TriesMax,
      FailCount.PracticeRate
    )
  )
end

function FailCount.TryNext()
  if not FailCount.Status then return end

  -- Reached maximum tries: safely sleep and stop
  if FailCount.Tries >= FailCount.TriesMax then
    FailCount.Message("FailCount",
      string.format("Reached max tries (%d). Sleeping and stopping.", FailCount.TriesMax)
    )
    FailCount.SleepIfNotSleeping()
    return FailCount.Reset()
  end

  -- Send score every N tries (default: 10) to break repetitive command anti-spam filter
  if FailCount.Tries % FailCount.ScoreInterval == 0 then
    send("score")
  end

  send(FailCount.SpellCastCmd)
end


-- ────────────── Mana & Out-of-Mana (OOM) Recovery ──────────────
function FailCount.GetManaInterval()
  local level = (StatTable and tonumber(StatTable.Level)) or 0
  -- Lord (125) and Legend (250) check every 60s; Hero (51+) and Lowmort check every 30s
  return (level >= 125) and 60 or 30
end

function FailCount.HandleOOM()
  if not FailCount.Status then return end

  FailCount.SleepIfNotSleeping()
  local interval = FailCount.GetManaInterval()
  FailCount.Message("FailCount", string.format("Out of mana. Sleeping (checking mana every %ds)...", interval))

  FailCount._tempTimer("FailCountManaCheck", interval, FailCount.CheckMana)
end

function FailCount.CheckMana()
  if not FailCount.Status then return end

  send("score")

  -- Allow brief time for GMCP vitals / score to process before evaluating mana
  FailCount._tempTimer("FailCountManaEval", 0.5, function()
    if not FailCount.Status then return end

    local cur_mana = (StatTable and tonumber(StatTable.current_mana))
      or (gmcp and gmcp.Char and gmcp.Char.Vitals and tonumber(gmcp.Char.Vitals.mp))
      or 0
    local max_mana = (StatTable and tonumber(StatTable.max_mana))
      or (gmcp and gmcp.Char and gmcp.Char.Vitals and tonumber(gmcp.Char.Vitals.maxmp))
      or 1
    local interval = FailCount.GetManaInterval()

    if cur_mana >= max_mana then
      FailCount.Message("FailCount", string.format("Mana full (%d/%d). Waking and resuming...", cur_mana, max_mana))
      FailCount.WakeIfSleeping()
      FailCount.TryNext()
    else
      local pct = max_mana > 0 and (cur_mana / max_mana) * 100 or 0
      FailCount.Message("FailCount", string.format("Mana regenerating: %d/%d (%.1f%%) — sleeping, checking again in %ds", cur_mana, max_mana, pct, interval))
      FailCount._tempTimer("FailCountManaCheck", interval, FailCount.CheckMana)
    end
  end)
end


-- ────────────── Tingle (Practice Advance) Handling ──────────────
function FailCount.OnTingle(event, arg, profile)
  if not FailCount.Status then return end

  if arg and string.lower(tostring(arg)) ~= FailCount.SpellName then
    FailCount.Message("FailCount", "Unexpected tingle (" .. tostring(arg) .. "). Stopping FailCount.")
    FailCount.Reset()
    return
  end

  -- Flush any partial block under the current practice rate before advancing
  if (FailCount.Success + FailCount.Fail) > 0 then
    FailCount.LogResults()
    FailCount.LastLoggedTry = FailCount.Tries
  end

  FailCount.PracticeRate = FailCount.PracticeRate + 1
  FailCount.Success = 0
  FailCount.Fail    = 0

  FailCount.Message("FailCount",
    string.format(
      "Tingle! New practice rate: %d%% — continuing...",
      FailCount.PracticeRate
    )
  )
end


-- ────────────── Start, Init & Reset Lifecycle ──────────────
function FailCount.Start(spellName, tries, target, customSuccess)
  if spellName then
    FailCount.ConfigureSpell(spellName, target, customSuccess)
  end
  FailCount.Init(tries)
end

function FailCount.Init(tries)
  -- Reset counters and state
  FailCount.TriesMax      = tries or FailCount.TriesMax or 20000
  FailCount.Success       = 0
  FailCount.Fail          = 0
  FailCount.Tries         = 0
  FailCount.LastLoggedTry = 0
  FailCount.PracticeRate  = 0
  FailCount.Status        = true
  FailCount.IsSleeping    = false

  -- Request practice percentage from MUD
  send("slearn " .. FailCount.SpellName)

  -- Register PCRE triggers for Mudlet
  FailCount._tempTrigger("FailCountSuccess",
    FailCount.SuccessPattern,
    FailCount.RecordSuccess
  )

  FailCount._tempTrigger("FailCountFail",
    FailCount.FailPattern,
    FailCount.RecordFail
  )

  FailCount._tempTrigger("FailCountOOM",
    FailCount.OOMPattern,
    FailCount.HandleOOM
  )

  FailCount._tempTrigger("FailCountPracticeRate",
    "^You have practiced " .. FailCount.SpellName .. " to (\\d+) percent",
    function()
      FailCount.PracticeRate = (matches and tonumber(matches[2])) or FailCount.PracticeRate
    end
  )

  FailCount._eventHandler("FailCountOnTingle", "OnTingle", FailCount.OnTingle, false)

  FailCount._charname = (StatTable and StatTable.CharName)
    or (gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.name)
    or "Unknown"

  FailCount._eventHandler("FailCountOnDisconnect", "sysDisconnectionEvent", function()
    if FailCount.Status and reconnect then
      reconnect()
    end
  end, true)

  FailCount._eventHandler("FailCountOnReconnect", "sysConnectionEvent", function()
    if FailCount.Status then
      FailCount._tempTimer("FailCountReconnect1", 5, function() if FailCount._charname ~= "Unknown" then send(FailCount._charname) end end)
      FailCount._tempTimer("FailCountReconnect2", 10, function() send("look") end)
      FailCount._tempTimer("FailCountReconnect3", 12, function() FailCount.TryNext() end)
    end
  end, true)

  FailCount.TryNext()
end

function FailCount.Stop()
  FailCount.Reset()
end

function FailCount.Reset()
  -- Log any remaining unlogged casts in the active block
  if (FailCount.Success + FailCount.Fail) > 0 then
    FailCount.LogResults()
    FailCount.LastLoggedTry = FailCount.Tries
  end

  FailCount.Status = false
  FailCount.ShowResults()

  FailCount._killTimer("FailCountManaCheck")
  FailCount._killTimer("FailCountManaEval")
  FailCount._killTimer("FailCountReconnect1")
  FailCount._killTimer("FailCountReconnect2")
  FailCount._killTimer("FailCountReconnect3")

  FailCount._killTrigger("FailCountSuccess")
  FailCount._killTrigger("FailCountFail")
  FailCount._killTrigger("FailCountOOM")
  FailCount._killTrigger("FailCountPracticeRate")

  FailCount._killEventHandler("FailCountOnTingle")
  FailCount._killEventHandler("FailCountOnDisconnect")
  FailCount._killEventHandler("FailCountOnReconnect")
end


-- ────────────── TSV Result Logger (Exact Data Format) ──────────────
function FailCount.LogResults()
  -- Ensure headers exist if creating a new file or starting fresh
  if not FailCount._headerCheck then
    local needHeader = false
    local check = io.open(FailCount.LogFile, "r")
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
      if h then
        h:write("Timestamp\tCharName\tRace\tClass\tSpell\tPracticeRate\tSuccess\tFail\n")
        h:close()
      end
    end
    FailCount._headerCheck = true
  end

  -- Only write if there are recorded casts in this batch
  if (FailCount.Success + FailCount.Fail) == 0 then
    return
  end

  local f, err = io.open(FailCount.LogFile, "a")
  if not f then
    if cecho then
      cecho("<red>Error opening log: " .. tostring(err) .. "\n")
    else
      FailCount.Message("FailCount", "Error opening log: " .. tostring(err))
    end
    return
  end

  local ts    = os.date("%Y-%m-%dT%H:%M:%S")
  local name  = (StatTable and StatTable.CharName)
    or (gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.name)
    or "Unknown"
  local race  = (StatTable and StatTable.Race)
    or (gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.race)
    or "Unknown"
  local cls   = (StatTable and StatTable.Class)
    or (gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.class)
    or "Unknown"

  f:write(string.format(
    "%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\n",
    ts, name, race, cls, FailCount.SpellName, FailCount.PracticeRate,
    FailCount.Success,
    FailCount.Fail
  ))
  f:close()
end
