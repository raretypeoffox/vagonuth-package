-- Script: Battle.Init
-- Attribute: isActive

-- Script Code:
Battle = Battle or {}
Battle.Combat = Battle.Combat or false
Battle.NextAction = Battle.NextAction or nil
Battle.NextActionTime = Battle.NextActionTime or 0
Battle.NextActionWait = Battle.NextActionWait or nil
Battle.NextActionTimerID = Battle.NextActionTimerID or nil

Battle.Recent = Battle.Recent or false

Battle.Stomper = Battle.Stomper or false

Battle.OnCombatEventHandler = Battle.OnCombatEventHandler or nil
Battle.EndCombatEventHandler = Battle.EndCombatEventHandler or nil
Battle.ActEventHandler = Battle.ActEventHandler or nil

Battle.LagAdjustSeq = Battle.LagAdjustSeq or 0
Battle.StormlordThunderheadRoomKey = Battle.StormlordThunderheadRoomKey or nil
Battle.StormlordLastSpell = Battle.StormlordLastSpell or nil
Battle.StormlordCallLightningPending = Battle.StormlordCallLightningPending or false
Battle.StormlordCallLightningWasBoosted = Battle.StormlordCallLightningWasBoosted or false

local ACT_WAIT_TIME_SECONDS = 0.5 -- constant, amount of time to wait before calling another loop of Battle.Act
local STORMLORD_LOW_MANA = 5000
local STORMLORD_THUNDERHEAD_WAIT = 5

-- Adds compatability for people not running the inventory package
function Battle.GetSpellLagMod()
  if type(_G["GetSpellLagMod"]) == "function" then return GetSpellLagMod() else return 1 end
end

function Battle.GetSpellCostMod(spell_type)
  if type(_G["GetSpellCostMod"]) == "function" then return GetSpellCostMod(spell_type) else return 1 end
end

function Battle.GetSkillLagMod()
  if type(_G["GetSkillLagMod"]) == "function" then return GetSkillLagMod() else return 1 end
end

local function scheduleActTimer(delay)
  Battle.LagAdjustSeq = Battle.LagAdjustSeq + 1
  local mySeq = Battle.LagAdjustSeq
  return tempTimer(delay, function()
    if mySeq ~= Battle.LagAdjustSeq then return end
    Battle.Act()
  end)
end

-- Note would cause a bug if Battle.NextAct was called while Battle.NextAction was already set, could build a queue system
-- Should be fixed with the 'if Battle.NextAction' condition below, not an optimal solution though as doesn't consider lag
function Battle.NextAct(NextAction, NextActionTime)
  if not NextAction or not NextActionTime then
    printMessage("Battle.NextAct() error", "need to supply two arguments to function")
    return false
  end
  
  -- If we are not in combat, send the command now
  if not Battle.Combat then 
    send(NextAction)
    return true
  end
  
  -- There was already a Battle.NextAction queued up. Send it out now so that we don't lose it.
  if Battle.NextAction then
    TryAction(Battle.NextAction, NextActionTime)
  end
  
  -- This is reached when we are in combat
  -- Set up Battle.NextAction so that its called by Battle.Act on its next loop

  Battle.NextAction = NextAction
  Battle.NextActionTime = NextActionTime
  return true
end

-- Main loop, called repeatedly during combat
function Battle.Act() 
  --printMessage("Battle.Act()","called")
  
  -- If we're not in combat, end the loop
  if not Battle.Combat then return end
  
  -- If we are in more than 1 second of lag, likely an external event. Wait for lag to be over before trying Battle.Act()
  local lag = tonumber(gmcp.Char.Vitals.lag)

  if lag > 1 then
    Battle.NextActionTimerID = tempTimer(0.1, function() Battle.Act() end)
    return
  end
  
  -- If we do not have a NextAction set then check if we have AutoCast / AutoHeal / AutoSkill
  if not (Battle.NextAction or Battle.NextActionTime) then
    if GlobalVar.AutoCast and GlobalVar.AutoCaster ~= "" then
       Battle.NextAction, Battle.NextActionTime = Battle.AutoCast()
    elseif GlobalVar.AutoHeal then
       Battle.NextAction, Battle.NextActionTime = Battle.AutoHeal()
    elseif GlobalVar.AutoSkill and GlobalVar.SkillStyle ~= "" then
       Battle.NextAction, Battle.NextActionTime = Battle.AutoSkill()
    end
  end
         
  -- if Battle.NextAction exists and we're in combat, send action and call Battle.Act again once out of lag
  if Battle.NextAction and Battle.NextActionTime and Battle.Combat then
    send(Battle.NextAction)
    Battle.LagStartTime = os.clock()
    Battle.LastSpellLag = Battle.NextActionTime
    Battle.NextActionTimerID = scheduleActTimer(Battle.NextActionTime)
    
  -- If Battle.NextAction doesn't exist but NextActionTime does, then just call Battle.Act in NextActionTime
  elseif Battle.NextAction == nil and Battle.NextActionTime and Battle.Combat then
    Battle.NextActionTimerID = scheduleActTimer(Battle.NextActionTime)
  
  -- Neither Action nor Time exists, call again in ACT_WAIT_TIME_SECONDS seconds until combat is over
  elseif Battle.Combat then
    Battle.NextActionTimerID = scheduleActTimer(ACT_WAIT_TIME_SECONDS)
  end
  
  Battle.NextAction = nil
  Battle.NextActionTime = nil
end

function Battle.OnLagReduce()
  if not Battle.LagStartTime or not Battle.LastSpellLag then return end
  if Battle.StormlordLastSpell == "thunderhead" then return end

  local elapsed   = os.clock() - Battle.LagStartTime
  local gmcpLag = tonumber(gmcp.Char.Vitals.lag)
  local procLag = Battle.LastSpellLag * 0.4
  local adjustedLag = gmcpLag and math.min(gmcpLag, procLag) or procLag
  local remaining = math.max(0, adjustedLag - elapsed)

  if Battle.NextActionTimerID then killTimer(Battle.NextActionTimerID) end

  Battle.NextActionTimerID = scheduleActTimer(remaining)
  
  Battle.LagStartTime = nil
  Battle.LastSpellLag = nil
end

function Battle.KillAct()
  if (Battle.NextActionTimerID) then killTimer(Battle.NextActionTimerID); Battle.NextActionTimerID = nil end
  if Battle.NextAction then send(Battle.NextAction) end
  
  Battle.NextAction = nil
  Battle.NextActionTime = nil

end


function Battle.OnCombat()
  --pdebug("Called Battle.OnCombat()")
  if Battle.Combat then return end
  Battle.Combat = true
  Battle.Recent = true
  GameLoop()
  
  local current_lag = tonumber(gmcp.Char.Vitals.lag)
  if (current_lag > 0) then
    Battle.NextActionTimerID = scheduleActTimer(current_lag)
  else
    Battle.Act()
  end
  
  if StatTable.Class ~= "Stormlord" then
    TryLook()
  end
  
end

function Battle.EndCombat()
  --pdebug("Called Battle.EndCombat()")
  Battle.Combat = false
  Battle.Stomper = false
  Battle.StormlordLastSpell = nil
  Battle.StormlordCallLightningPending = false
  Battle.StormlordCallLightningWasBoosted = false
  safeTempTimer("Battle.Recent.EndofCombat", 30, function() Battle.Recent = false; end)
  safeEventHandler("Battle.Recent.SetFalseOnMyDeath", "OnMyDeath", function() Battle.Recent = false; end, false)
  safeEventHandler("Battle.Recent.SetFalseOnPlane", "OnPlane", function() Battle.Recent = false; end, false)
  Battle.KillAct()

  -- Trigger BuffManager to process any queued out-of-combat buffs
  if type(BuffManager) == "table" and type(BuffManager.Process) == "function" then
    BuffManager.Process()
  end
end

function Battle.KillEventHandlers()
  if Battle.OnCombatEventHandler then killAnonymousEventHandler(Battle.OnCombatEventHandler) end
  if Battle.OnCombatEventHandler then killAnonymousEventHandler(Battle.OnCombatEventHandler) end
  if Battle.OnCombatEventHandler then killAnonymousEventHandler(Battle.OnCombatEventHandler) end
end

function Battle.AutoCast()
  if StatTable.Class == "Stormlord" and StatTable.Level == 125 then
    return Battle.AutoCastStormlord()
  end

  local autocast_minmana = 0
  local autocast_spell = GlobalVar.AutoCaster
  local nextaction = ""
  local spelllag = (5 * Battle.GetSpellLagMod()) -- assumes in class, ie 5 second, casting
  
  if GlobalVar.AutoCaster == "acid rain" or GlobalVar.AutoCaster == "meteor swarm" or GlobalVar.AutoCaster == "banshee wail" or GlobalVar.AutoCaster == "storm of vengeance" then
    spelllag = (6 * Battle.GetSpellLagMod())  
  end
  
  -- If Quicken on, reduce spelllag
  -- Note: inexact science, still working to figure out how much quicken affects spell casting speed
  -- At Quicken 9, Fdk Psi Shz has 2 lag, normally should be 4 seconds (5 seconds * 20% shz reduction)
  -- Assuming Quicken 9 cuts spell time in half, then using pro-rated scale for remainder
  if GlobalVar.QuickenStatus then spelllag = spelllag * (1 - (StatTable.Quicken / 18)) end
  
  if (StatTable.Level == 125) then
    autocast_minmana = 500
  elseif (StatTable.Level == 51) then
    autocast_minmana = 100
  elseif (StatTable.Level < 51) then
    autocast_minmana = 50
  end
  
  -- Psi stomp protector
  if StatTable.Class == "Psionicist" then
    if not StatTable.KineticChain and Battle.Stomper then
      if StatTable.Level == 51 and StatTable.SubLevel >= 101 then
        return "cast rupture", spelllag
      elseif StatTable.Level == 125 then
        return "cast mindwipe", spelllag
      end
    end  
  end
  
  if tonumber(gmcp.Char.Status.mana) > autocast_minmana then
    local surge_level = GetSurgeLevel(autocast_spell)

    if surge_level > 1 then
      if StatTable.Class == "Wizard" and StatTable.EtherCrash == 1 and GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE then
        AutoCastSetSpell(GlobalVar.AutoCasterSingle)
      end

      nextaction = "surge " .. surge_level .. getCommandSeparator() .. "cast '" .. autocast_spell .. "'" .. getCommandSeparator() .. "surge off"
    else
      nextaction = "cast '" .. autocast_spell .. "'"
    end 
    return nextaction, spelllag
  else
    return nil, ACT_WAIT_TIME_SECONDS
  end
end

function Battle.AutoHeal()
  local shadowed = (gmcp.Room.Info.zone == "{ LORD } Ctibor  Netherworld" and true or false)

  --pdebug("Called Battle.AutoHeal()")
  local spelllag = (5 * Battle.GetSpellLagMod()) -- assumes in class, ie 5 second lag (div and comf are always in class)
  
  -- Could make these variable settings in the future
  local MonitorHPPct = (StatTable.Level == 125) and 0.875 or 0.725 -- at what % (expressed in decimal) should we auto heal at
  MonitorHPPct = math.floor((MonitorHPPct + (math.random() * 0.05)) * 1000 + 0.5) / 1000 -- adds a random number between 0 and 5% so that when multiple people use the package, they don't all start healing at the exact same amonut
  
  local MinManaPct = (StatTable.Level == 125) and 0.1 or 0.25 -- at what mana level should we stop auto healing at
  local MinMana = (MinManaPct * StatTable.max_mana) or 0
  -- At Lord, save enough mana for create shrine + planeshift
  local MinMana = (StatTable.Level == 125) and (2500 * Battle.GetSpellCostMod("divine") + 500 * Battle.GetSpellCostMod("arcane")) or 300
  
  --lua print(((2500 * GetSpellCostModRacial(StatTable.Race, "divine") + 500 * GetSpellCostModRacial(StatTable.Race, "arcane"))))
  
  
  local HealTarget = GlobalVar.AutoHealTarget
  local PreachAtHero = true
  
  -- If we're a Priest, check to see if we should be preaching
  if StatTable.Class == "Priest" and StatTable.current_mana > MinMana then
    if (StatTable.Level == 125 and not shadowed) and StatTable.InjuredCount > 2  then
      if StatTable.CriticalInjured > 2 then
        return "augment 2" .. getCommandSeparator() .. "preach comfort" .. getCommandSeparator() .. "augment off", spelllag
      else
        return "preach comfort", 7 * Battle.GetSpellLagMod()
      end
    elseif (StatTable.Level == 51 or shadowed) and PreachAtHero and StatTable.CriticalInjured > 2 then
      return "preach divinity", 7 * Battle.GetSpellLagMod()
    end
  end
  
  -- Auto Heal Lowest HP % - set our heal target to the lowest HP groupie if lowest hp % mode activated
  if GlobalVar.AutoHealLowest and GlobalVar.VizMonitor ~= "" then 
    HealTarget = GlobalVar.VizMonitor -- GlobalVizMonitor holds the name of the lowest hp groupmate (excluding us!), check below to see if our hp is lower
    if (StatTable.current_health / StatTable.max_health) < (GlobalVar.GroupMates[HealTarget].hp / GlobalVar.GroupMates[HealTarget].maxhp) then HealTarget = StatTable.CharName
    elseif (StatTable.current_health / StatTable.max_health) < 0.1 then HealTarget = StatTable.CharName end   
  end
  
  -- If heal target doesn't exist or isn't a group mate, return
  if not HealTarget or not GlobalVar.GroupMates[HealTarget] or not GlobalVar.GroupMates[HealTarget].hp or not GlobalVar.GroupMates[HealTarget].maxhp then
    return nil, ACT_WAIT_TIME_SECONDS
  end
  
  if GlobalVar.AutoHealExclusionList[HealTarget] then return nil, ACT_WAIT_TIME_SECONDS end
  
  local HealTargetHPPct = GlobalVar.GroupMates[HealTarget].hp / GlobalVar.GroupMates[HealTarget].maxhp

  if HealTargetHPPct < MonitorHPPct and StatTable.current_mana > MinMana then
    if StatTable.Level == 125 and not shadowed then
      if HealTargetHPPct < (MonitorHPPct * 0.5) and StatTable.current_mana > (MinMana * 2) then
        return "augment 3" .. getCommandSeparator() .. "cast comfort " .. HealTarget .. getCommandSeparator() .. "augment off", spelllag
      elseif HealTargetHPPct < (MonitorHPPct * 0.75) and StatTable.current_mana > (MinMana * 2) then
        return "augment 2" .. getCommandSeparator() .. "cast comfort " .. HealTarget .. getCommandSeparator() .. "augment off", spelllag
      else
        return "cast comfort " .. HealTarget, spelllag
      end
    elseif StatTable.Level == 51 or shadowed then
      return "cast divinity " .. HealTarget, spelllag
    else
      return "cast 'cure light' " .. HealTarget, spelllag
    end
  end
  
  if StatTable.current_mana < MinMana then
    TryFunction("LowManaHealBeepMsg", printGameMessage, {"Alert!", "Low mana, not autohealing", "red", "white"}, 300)
    TryFunction("LowManaHealBeep", QuickBeep, nil, 300)
  end
    
  return nil, ACT_WAIT_TIME_SECONDS
end

function Battle.AutoSkill()
  local nextaction = ""
  local skilllag = (5 * Battle.GetSkillLagMod()) -- assumes in class, ie 5 second, casting- TODO: adjust base time, i.e. 5, for class/skill
  
  nextaction = GlobalVar.SkillStyle

  return nextaction, skilllag
end

function Battle.DoAfterCombat(action)
  if type(BuffManager) == "table" and type(BuffManager.Add) == "function" then
    BuffManager.Add(action, 1)
  else
    -- Fallback legacy command sending if BuffManager is not yet loaded
    send(action)
  end
end

function Battle.GetStormlordRoomKey()
  local info = gmcp and gmcp.Room and gmcp.Room.Info or nil
  if not info then return nil end

  if info.num then return tostring(info.num) end
  if info.id then return tostring(info.id) end
  if info.vnum then return tostring(info.vnum) end

  local exits = {}
  for exitName, _ in pairs(info.exits or {}) do
    table.insert(exits, tostring(exitName))
  end
  table.sort(exits)

  return table.concat({
    tostring(info.zone or ""),
    tostring(info.name or ""),
    table.concat(exits, ","),
  }, "|")
end

function Battle.StormlordRoomHasThunderhead()
  local roomKey = Battle.GetStormlordRoomKey()
  return roomKey and Battle.StormlordThunderheadRoomKey == roomKey
end

function Battle.MarkStormlordThunderheadRoom()
  Battle.StormlordThunderheadRoomKey = Battle.GetStormlordRoomKey()
end

function Battle.StormlordMobCount()
  if type(AutoCastCountMobs) == "function" then
    return AutoCastCountMobs()
  end

  local Players = gmcp and gmcp.Room and gmcp.Room.Players or {}
  local MobCount = 0

  for _, mob in pairs(Players) do
    -- Mobs have numbered "names" vs PCs who have real names, can eliminate PCs by removing non-numbered names
    local fullname = mob.fullname or ""
    if tonumber(mob.name) and not fullname:find("%(CHARMED%)") then
      MobCount = MobCount + 1
    end
  end

  return MobCount
end

function Battle.StormlordRoomAllowsAOE()
  if type(AutoCastRoomAllowsAOE) == "function" then
    return AutoCastRoomAllowsAOE()
  end

  return true
end

function Battle.StormlordSpellLag()
  local spelllag = (5 * Battle.GetSpellLagMod())

  if GlobalVar.QuickenStatus then
    spelllag = spelllag * (1 - (StatTable.Quicken / 18))
  end

  return spelllag
end

function Battle.StormlordCast(spell, allowSurge)
  Battle.StormlordLastSpell = spell
  Battle.StormlordCallLightningPending = (spell == "call lightning")
  Battle.StormlordCallLightningWasBoosted = false

  if spell == "thunderhead" then
    Battle.MarkStormlordThunderheadRoom()
  end

  if allowSurge then
    local surge_level = GetSurgeLevel(spell)

    if surge_level > 1 then
      return "surge " .. surge_level .. getCommandSeparator() .. "cast '" .. spell .. "'" .. getCommandSeparator() .. "surge off"
    end
  end

  return "cast '" .. spell .. "'"
end

function Battle.AutoCastStormlord()
  if not GlobalVar.AutoCast then
    Battle.StormlordLastSpell = nil
    Battle.StormlordCallLightningPending = false
    Battle.StormlordCallLightningWasBoosted = false
    return nil, ACT_WAIT_TIME_SECONDS
  end

  local spelllag = Battle.StormlordSpellLag()
  local status = gmcp and gmcp.Char and gmcp.Char.Status or {}
  local mana = tonumber(status.mana) or tonumber(StatTable.current_mana) or 0
  local mobCount = Battle.StormlordMobCount()

  if not Battle.StormlordRoomHasThunderhead() then
    return Battle.StormlordCast("thunderhead", false), STORMLORD_THUNDERHEAD_WAIT
  end

  if not Battle.StormlordRoomAllowsAOE() then
    if not StatTable.Thunderhead then
      return Battle.StormlordCast("thunderhead", false), STORMLORD_THUNDERHEAD_WAIT
    end

    return nil, ACT_WAIT_TIME_SECONDS
  end

  if mana < STORMLORD_LOW_MANA then
    if mobCount >= 3 then
      if not StatTable.Blizzard then
        return Battle.StormlordCast("blizzard", false), spelllag
      end

      return nil, ACT_WAIT_TIME_SECONDS
    end

    if not StatTable.Thunderhead then
      return Battle.StormlordCast("thunderhead", false), STORMLORD_THUNDERHEAD_WAIT
    end

    return nil, ACT_WAIT_TIME_SECONDS
  end

  return Battle.StormlordCast("call lightning", true), spelllag
end

function Battle.StormlordCallLightningFailed()
  if Battle.StormlordLastSpell ~= "call lightning" then return end

  Battle.StormlordThunderheadRoomKey = nil
  Battle.StormlordLastSpell = nil
  Battle.StormlordCallLightningPending = false
  Battle.StormlordCallLightningWasBoosted = false

  if Battle.Combat and GlobalVar.AutoCast then
    if Battle.NextActionTimerID then killTimer(Battle.NextActionTimerID) end
    Battle.NextActionTimerID = scheduleActTimer(ACT_WAIT_TIME_SECONDS)
  end
end

function Battle.StormlordCallLightningBoosted()
  if Battle.StormlordLastSpell ~= "call lightning" then return end
  if not Battle.StormlordCallLightningPending then return end

  Battle.StormlordCallLightningWasBoosted = true
  Battle.MarkStormlordThunderheadRoom()
end

function Battle.StormlordCallLightningLanded()
  if Battle.StormlordLastSpell ~= "call lightning" then return end
  if not Battle.StormlordCallLightningPending then return end

  if not Battle.StormlordCallLightningWasBoosted then
    Battle.StormlordThunderheadRoomKey = nil
  end

  Battle.StormlordCallLightningPending = false
  Battle.StormlordCallLightningWasBoosted = false
end



Battle.KillEventHandlers()
Battle.OnCombatEventHandler = registerAnonymousEventHandler("OnCombat", "Battle.OnCombat", false)
Battle.EndCombatEventHandler = registerAnonymousEventHandler("EndCombat", "Battle.EndCombat", false)
safeTempTrigger("StormlordCallLightningNoThunderhead", "You must be out of doors.", function() Battle.StormlordCallLightningFailed() end, "begin")
safeTempTrigger("StormlordCallLightningBoosted", "You harness the fury of a Stormlord's might!", function() Battle.StormlordCallLightningBoosted() end, "begin")
safeTempTrigger("StormlordCallLightningLanded", "Lightning strikes your foes!", function() Battle.StormlordCallLightningLanded() end, "begin")
--Battle.ActEventHandler = registerAnonymousEventHandler("ActCombat", "Battle.Act", false)


-- bug found:
-- was trying to aug 2 comf a group mate in a big gear room
-- 3 mobs died in quick sucession,
-- aug 2; cast comf fired off 3 times in a row (once after each death)

