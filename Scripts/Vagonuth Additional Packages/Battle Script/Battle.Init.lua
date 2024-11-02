-- Script: Battle.Init
-- Attribute: isActive

-- Script Code:
Battle = Battle or {}
Battle.Combat = Battle.Combat or false
--Battle.Queue = Battle.Queue or {}
Battle.NextAction = Battle.NextAction or nil
Battle.NextActionTime = Battle.NextActionTime or 0
Battle.NextActionWait = Battle.NextActionWait or nil
Battle.NextActionTimerID = Battle.NextActionTimerID or nil

Battle.Recent = Battle.Recent or false

Battle.Stomper = Battle.Stomper or false

Battle.OnCombatEventHandler = Battle.OnCombatEventHandler or nil
Battle.EndCombatEventHandler = Battle.EndCombatEventHandler or nil
Battle.ActEventHandler = Battle.ActEventHandler or nil

local ACT_WAIT_TIME_SECONDS = 0.5 -- constant, amount of time to wait before calling another loop of Battle.Act

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
    send(Battle.NextAction)
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
  --local lag = 0 -- server prompt bug
  if lag > 1 then
    --printMessage("Battle.Act()", "In lag, waiting " .. lag .. " seconds before calling again")
    --Battle.NextActionTimerID = tempTimer(lag, function() Battle.Act() end)
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
    Battle.NextActionTimerID = tempTimer(Battle.NextActionTime, function() Battle.Act() end)
    
  -- If Battle.NextAction doesn't exist but NextActionTime does, then just call Battle.Act in NextActionTime
  elseif Battle.NextAction == nil and Battle.NextActionTime and Battle.Combat then
    Battle.NextActionTimerID = tempTimer(Battle.NextActionTime, function() Battle.Act() end)
  
  -- Neither Action nor Time exists, call again in ACT_WAIT_TIME_SECONDS seconds until combat is over
  elseif Battle.Combat then
    Battle.NextActionTimerID = tempTimer(ACT_WAIT_TIME_SECONDS, function() Battle.Act() end)
  end
  
  Battle.NextAction = nil
  Battle.NextActionTime = nil
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
  
  if StatTable.Class == "Stormlord" and StatTable.Level == 125 then Battle.StormlordCombat() end
  
  
  local current_lag = tonumber(gmcp.Char.Vitals.lag)
  if (current_lag > 0) then
    Battle.NextActionTimerID = tempTimer(current_lag, function() Battle.Act() end)
  else
    Battle.Act()
  end
  
  TryLook()
  
end

function Battle.EndCombat()
  --pdebug("Called Battle.EndCombat()")
  Battle.Combat = false
  safeTempTimer("Battle.Recent.EndofCombat", 30, function() Battle.Recent = false; end)
  safeEventHandler("Battle.Recent.SetFalseOnMyDeath", "OnMyDeath", function() Battle.Recent = false; end, false)
  safeEventHandler("Battle.Recent.SetFalseOnPlane", "OnPlane", function() Battle.Recent = false; end, false)
  Battle.KillAct()
end

function Battle.KillEventHandlers()
  if Battle.OnCombatEventHandler then killAnonymousEventHandler(Battle.OnCombatEventHandler) end
  if Battle.OnCombatEventHandler then killAnonymousEventHandler(Battle.OnCombatEventHandler) end
  if Battle.OnCombatEventHandler then killAnonymousEventHandler(Battle.OnCombatEventHandler) end
end

function Battle.AutoCast()
  local autocast_minmana = 0
  local autocast_stopsurge = 3500
  local autocast_spell = GlobalVar.AutoCaster
  local nextaction = ""
  local surge_level = GlobalVar.SurgeLevel or 1
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
    if (StatTable.Class == "Mage" or StatTable.Class == "Stormlord") then
      autocast_stopsurge = (9000 * Battle.GetSpellCostMod("arcane")) or 7000
    elseif (StatTable.Class == "Wizard") then
      autocast_stopsurge = (10000 * Battle.GetSpellCostMod("arcane")) or 8000
    elseif (StatTable.Class == "Sorcerer") then
      autocast_stopsurge = (10000 * Battle.GetSpellCostMod("arcane")) or 8000
    end
  elseif (StatTable.Level == 51) then
    autocast_minmana = 100
  elseif (StatTable.Level < 51) then
    autocast_minmana = 50
  end
  
  -- Psi stomp protector
  if StatTable.Class == "Psionicist" then
    if not StatTable.KineticChain and Battle.Stomper then
      if StatTable.Level == 51 then
        return "cast rupture", spelllag
      elseif StatTable.Level == 125 then
        return "cast mindwipe", spelllag
      end
    end  
  end
  
  if tonumber(gmcp.Char.Status.mana) > autocast_minmana then
    -- Surge if above autocast_stopsurge mana
    if (tonumber(gmcp.Char.Status.mana) >= autocast_stopsurge and surge_level > 1) then
    
      -- up the surge level when EtherLink / EtherCrash up    
      if StatTable.Class == "Wizard" and (StatTable.EtherLink or StatTable.EtherCrash == 1) and GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE then
        if StatTable.EtherCrash == 1 then 
          surge_level = 5
          AutoCastSetSpell(GlobalVar.AutoCasterSingle)
        end
      end        
      

      -- Add a surge level if current mana exceeds 4x the stop surge mana (eg 8000 mana * 4 = 32000 mana)
      if surge_level == 2 and tonumber(gmcp.Char.Status.mana) > (autocast_stopsurge * 4) then
        surge_level = surge_level + 1
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
  GlobalVar.AutoHealExclusionList = GlobalVar.AutoHealExclusionList or {}

  --pdebug("Called Battle.AutoHeal()")
  local spelllag = (5 * Battle.GetSpellLagMod()) -- assumes in class, ie 5 second lag (div and comf are always in class)
  
  -- Could make these variable settings in the future
  local MonitorHPPct = (StatTable.Level == 125) and 0.875 or 0.725 -- at what % (expressed in decimal) should we auto heal at
  MonitorHPPct = math.floor((MonitorHPPct + (math.random() * 0.05)) * 1000 + 0.5) / 1000 -- adds a random number between 0 and 5% so that when multiple people use the package, they don't all start healing at the exact same amonut
  
  local MinManaPct = (StatTable.Level == 125) and 0.15 or 0.25 -- at what mana level should we stop auto healing at
  local MinMana = (MinManaPct * StatTable.max_mana) or 0
  -- At Lord, save enough mana for create shrine + planeshift
  --local MinMana = (StatTable.Level == 125) and (2500 * Battle.GetSpellCostMod("divine") + 500 * Battle.GetSpellCostMod("arcane")) or 300
  
  --lua print(((2500 * GetSpellCostModRacial(StatTable.Race, "divine") + 500 * GetSpellCostModRacial(StatTable.Race, "arcane"))))
  
  
  local HealTarget = GlobalVar.AutoHealTarget
  local PreachAtHero = true
  
  -- If we're a Priest, check to see if we should be preaching
  if StatTable.Class == "Priest" and StatTable.current_mana > MinMana then
    if StatTable.Level == 125 and StatTable.InjuredCount > 2 then
      if StatTable.CriticalInjured > 2 then
        return "augment 2" .. getCommandSeparator() .. "preach comfort" .. getCommandSeparator() .. "augment off", spelllag
      else
        return "preach comfort", 7 * Battle.GetSpellLagMod()
      end
    elseif StatTable.Level == 51 and PreachAtHero and StatTable.CriticalInjured > 2 then
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
    if StatTable.Level == 125 then
      if HealTargetHPPct < (MonitorHPPct * 0.5) and StatTable.current_mana > (MinMana * 2) then
        return "augment 3" .. getCommandSeparator() .. "cast comfort " .. HealTarget .. getCommandSeparator() .. "augment off", spelllag
      elseif HealTargetHPPct < (MonitorHPPct * 0.75) and StatTable.current_mana > (MinMana * 2) then
        return "augment 2" .. getCommandSeparator() .. "cast comfort " .. HealTarget .. getCommandSeparator() .. "augment off", spelllag
      else
        return "cast comfort " .. HealTarget, spelllag
      end
    elseif StatTable.Level == 51 then
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

Battle.DoAfterCombatTable = Battle.DoAfterCombatTable or {}

function Battle.DoAfterCombat(action, retryCount)
  retryCount = retryCount or 0  
  
  if retryCount == 0 then 
    if Battle.DoAfterCombatTable[action] then return end
    Battle.DoAfterCombatTable[action] = true 
  end
  
  if Battle.Combat or StatTable.Position == "Sleep" or StatTable.Position == "Rest" then
    OnMobDeathQueue(action)
    safeEventHandler("BattleDoAfterCombatQueueID", "OnMobDeath", function() Battle.DoAfterCombatTable[action] = nil end, true)
    return
  end

  local lag = tonumber(gmcp.Char.Vitals.lag)
  if lag > 0 then
    if retryCount < 5 then -- Limit retries to 5 times
      tempTimer(lag, function() Battle.DoAfterCombat(action, retryCount + 1) end)
    else
      printGameMessage("Battle", "Unable to perform action after combat: " .. action)
      Battle.DoAfterCombatTable[action] = nil
    end
    return
  end

  send(action)
  Battle.DoAfterCombatTable[action] = nil
end

function Battle.StormlordCombat()
    
  local Players = gmcp.Room.Players
  local MobCount = 0

  -- Sort all Players into enemies and friendlies
  for PlayerName,_ in pairs(Players) do
    -- Mobs have numbered "names" vs PCs who have real names, can eliminate PCs by removing non-numbered names
    if tonumber(Players[PlayerName].name) then
      MobCount = MobCount + 1
    end
  end
  
  if MobCount > 2 then
    if StatTable.Blizzard then return end
    send("cast blizzard")
  else
    send("cast thunderhead")
  end
end



Battle.KillEventHandlers()
Battle.OnCombatEventHandler = registerAnonymousEventHandler("OnCombat", "Battle.OnCombat", false)
Battle.EndCombatEventHandler = registerAnonymousEventHandler("EndCombat", "Battle.EndCombat", false)
--Battle.ActEventHandler = registerAnonymousEventHandler("ActCombat", "Battle.Act", false)


-- bug found:
-- was trying to aug 2 comf a group mate in a big gear room
-- 3 mobs died in quick sucession,
-- aug 2; cast comf fired off 3 times in a row (once after each death)

--augment 2;cast comfort Jampton;augment off

--Donquixote utters the words, 'brimstone'.
--Donquixote's brimstone strikes Kinetisch with terminal brutality!
--Kinetisch is DEAD!!

--Alwyn utters the words, 'meteor swarm'.
--A torrent of meteors streams from Alwyn's hands at his foes!
--Alwyn's Meteor Swarm strikes Leger with terminal brutality!
--augment 2;cast comfort Jampton;augment off
--Leger is DEAD!!

--Alwyn's Meteor Swarm strikes Leger with >***ERADICATING***< brutality!
--augment 2;cast comfort Jampton;augment off
--Leger is DEAD!!

--Pohi's air Banshee Wail strikes Leger with *ERADICATING* force!
--augment 2;cast comfort Jampton;augment off