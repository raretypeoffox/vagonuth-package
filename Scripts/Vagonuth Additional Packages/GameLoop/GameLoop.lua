-- Script: GameLoop
-- Attribute: isActive

-- Script Code:
local function TryGameLoopAction(action, wait)
  if type(BuffManager) == "table" and type(BuffManager.TryAction) == "function" then
    return BuffManager.TryAction(action, wait)
  end

  return TryAction(action, wait)
end

local function UseSkillAfterExhaust(Skill, SkillExhaust, Command)
  if Skill == nil and SkillExhaust == nil then
    if TryGameLoopAction(Command, 30) then
      printGameMessageVerbose("GameLoop", Command)
    end
  end 
end

local function GroupHasClass(classList)
  if not GlobalVar.GroupMates then return false end

  for _, groupie in pairs(GlobalVar.GroupMates) do
    for _, class in ipairs(classList) do
      if groupie.class == class then
        return true
      end
    end
  end

  return false
end

-- note: only ran while we're in combat
function GameLoopClass(MyClass)
  if MyClass == "Sorcerer" then       

    if StatTable.Level == 125 then
      if (StatTable.BrimstoneExhaust ~= nil and string.lower(GlobalVar.AutoCaster) == "brimstone") then
        AutoCastSetSpell("maelstrom")                 
      end
      
      -- Move this to trigger once migraine exhaust over trigger text captured
      if (StatTable.BrimstoneExhaust == nil and StatTable.Level == 125 and string.lower(GlobalVar.AutoCaster) == "maelstrom") then
        AutoCastSetSpell("brimstone")
      end
    end
  elseif MyClass == "Black Circle Initiate" then
  
    
    if StatTable.Level == 125 then
      if not StatTable.QuickcastExhaust then
        if tonumber(gmcp.Char.Vitals.lag) == 0 and tonumber(gmcp.Char.Status.opponent_level) > 140 and (StatTable.EnemyHP / StatTable.EnemyMaxHP) > 0.40 then
          TryGameLoopAction("quickcast mindwipe eye", 30)
        end
      end
    elseif StatTable.Level == 51 then
      if not StatTable.QuickcastExhaust and StatTable.SubLevel > 250 then
        if tonumber(gmcp.Char.Vitals.lag) == 0 and tonumber(gmcp.Char.Status.opponent_level) > 60 and (StatTable.EnemyHP / StatTable.EnemyMaxHP) > 0.40 then
          TryGameLoopAction("quickcast fear", 30)
        end
      end
    end
    
    

    
  elseif MyClass == "Bladedancer" then
    GameLoopBLD()
  elseif MyClass == "Warrior" then
      if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
      if StatTable.Level < 48 then return end
      if AR.Status then
        UseSkillAfterExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "stance protective")
        if StatTable.StanceProtectiveExhaust then UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot") end
      else
        UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot")
      end
  elseif MyClass == "Bodyguard" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    if StatTable.Level < 48 then return end
    
    if AR.Status then
      UseSkillAfterExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "stance protective")
      if StatTable.StanceProtectiveExhaust then UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot") end
    else
      UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot")
    end      
    
  elseif MyClass == "Ripper" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    if StatTable.Level < 48 then return end
    if AR.Status then
      UseSkillAfterExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "stance protective")
      if StatTable.StanceProtectiveExhaust then UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot") end
    else
      UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot")
    end
  elseif MyClass == "Berserker" then
    if not GlobalVar.AutoStance then return end
    if StatTable.Level == 51 and not StatTable.Rally then TryGameLoopAction("rally", 60) end
  
  elseif MyClass == "Paladin" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    if StatTable.Level < 48 then return end
    if AR.Status then
      UseSkillAfterExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "stance protective")
      if StatTable.StanceProtectiveExhaust then UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot") end
    else
      UseSkillAfterExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "stance surefoot")
    end
  elseif MyClass == "Monk" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    if AR.Status and (StatTable.Level == 125 or StatTable.SubLevel > 101) then
      UseSkillAfterExhaust(StatTable.BearStance, StatTable.BearStanceExhaust, "stance bear")
      if not StatTable.BearStance then UseSkillAfterExhaust(StatTable.EmuStance, StatTable.EmuStanceExhaust, "stance emu") end
    end
    if StatTable.Level == 125 then
      -- qi loop      
      local chakra = Battle.EnemiesChakra[gmcp.Char.Status.opponent_name] or nil
      
      if StatTable.OuterQi >= 10 then
         if tonumber(gmcp.Char.Status.opponent_level) > 180 then --or StatTable.OuterQi == 23 (ie max)
            if StatTable.SubLevel >= 250 then
              TryGameLoopAction("qi wave", 5)
            else
              TryGameLoopAction("qi blast", 5)
            end
         end
      end
      
      -- if there are groupies to rescue or we're in lag, try again later.
      -- TODO: perhaps check if we're the only tank?
      if (AR.Status and table.size(AR.RescueStack) > 0) or tonumber(gmcp.Char.Vitals.lag) > 0 then
        return
      elseif chakra and StatTable.SubLevel >= 100 and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi invert " .. (chakra and chakra or ""), 15)
      elseif chakra and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi strike " .. (chakra and chakra or ""), 15)
      elseif StatTable.StoneFist and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi punch", 5)
      elseif StatTable.DaggerHand and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi thrust", 5)
      else
        TryGameLoopAction("kick", 5)
      end
      
    end
  elseif MyClass == "Shadowfist" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    
    if StatTable.Level == 51 and StatTable.SubLevel > 100 then
      -- Vampire fang will be prioritzed when health is less than 75% max, otherwise spectral is prioritized
      if not StatTable.VampireFangExhaust and StatTable.current_health < (StatTable.max_health * 0.75) then
        UseSkillAfterExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "stance vampire fang")
      else
        UseSkillAfterExhaust(StatTable.SpectralFang, StatTable.SpectralFangExhaust, "stance spectral fang")
        if StatTable.SpectralFangExhaust then UseSkillAfterExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "stance vampire fang") end
      end
      
    elseif StatTable.Level == 125 then
      -- Vampire fang will be prioritzed when health is less than 75% max, otherwise spectral is prioritized
      if not (StatTable.VampireFang or StatTable.SpectralFang) then
        if not StatTable.VampireFangExhaust and (StatTable.current_health < (StatTable.max_health * 0.75) or StatTable.SpectralFangExhaust) then
          BuffManager.Add("stance vampire fang", 1)
          TryGameLoopAction("ctr vital stay", 5)
        elseif not StatTable.SpectralFangExhaust then
          BuffManager.Add("stance spectral fang", 1)
          TryGameLoopAction("ctr push stay", 5)
        end
      end
      
      -- qi loop      
      local chakra = Battle.EnemiesChakra[gmcp.Char.Status.opponent_name] or nil
      
      -- outer qi logic
      if StatTable.OuterQi >= 10 then
        if tonumber(gmcp.Char.Status.opponent_level) > 180 then --or StatTable.OuterQi == 23 (ie max)
          if StatTable.SubLevel >= 250 then
            TryGameLoopAction("qi wave", 5)
          else
            TryGameLoopAction("qi blast", 5)
          end
        end
      end

      -- inner qi logic
      -- if there are groupies to rescue or we're in lag, try again later.
      -- TODO: perhaps check if we're the only tank?
      if (AR.Status and table.size(AR.RescueStack) > 0) or tonumber(gmcp.Char.Vitals.lag) > 0 then
        return
      elseif chakra and StatTable.SubLevel >= 100 and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi drain " .. (chakra and chakra or ""), 15)
      elseif chakra and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi strike " .. (chakra and chakra or ""), 15)
      elseif StatTable.StoneFist and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi punch", 5)
      elseif StatTable.DaggerHand and StatTable.InnerQi >= 7 then
        TryGameLoopAction("qi thrust", 5)
      else
        TryGameLoopAction("vital", 5)
      end
    end
  elseif MyClass == "Soldier" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    if StatTable.Level == 125 or StatTable.SubLevel >= 101 then
      if not StatTable.StanceEchelon and not StatTable.EchelonExhaust then
        BuffManager.Add("stance echelon", 1)
      elseif not StatTable.StanceEchelon and not StatTable.StanceSquare and not StatTable.SquareExhaust then
        BuffManager.Add("stance square", 1)
      end       

    end
  elseif MyClass == "Cleric" then

    
  elseif MyClass == "Priest" then
       
   
  end -- end of MyClass
  
  
  
end

function GameLoopRace(MyRace)
   if MyRace == "Troll" then
      if (GlobalVar.AutoRevive and (StatTable.current_health / StatTable.max_health) < GlobalVar.AutoReviveHPpct and StatTable.current_health > 100 and StatTable.Foci) then 
        UseSkillAfterExhaust(StatTable.RacialRevival, StatTable.RacialRevivalFatigue, "racial revival")
      end
   elseif MyRace == "Firedrake" and StatTable.Level == 125 then
      if not StatTable.RacialBreathFatigue and 
         not GroupLeader() 
         and StatTable.Level == 125 and
         tonumber(gmcp.Char.Status.opponent_level) > 180 then 
          TryGameLoopAction("racial breath", 30)
        end
  
   elseif MyRace == "Dragon" then
      if not StatTable.RacialBreathFatigue and 
         not GroupLeader() 
         and StatTable.Level == 125 and
         tonumber(gmcp.Char.Status.opponent_level) > 180 then 
          TryGameLoopAction("racial breath full", 30)
        end
   elseif MyRace == "Kzinti" then
   
      if (StatTable.Level == 125 and StatTable.DamRoll > 200) or (StatTable.Level == 51 and StatTable.DamRoll >  100) then
        UseSkillAfterExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "racial frenzy")
      end
      
  elseif MyRace == "Half-Orc" then
      if (StatTable.Level == 125 and (StatTable.DamRoll > 200 or StatTable.HitRoll > 200)) or (StatTable.Level == 51 and (StatTable.DamRoll >  100 or StatTable.HitRoll > 100)) then
        UseSkillAfterExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "racial frenzy")
      end
  elseif MyRace == "Orc" then
      if (StatTable.Level == 125 and (StatTable.DamRoll > 200 or StatTable.HitRoll > 200)) or (StatTable.Level == 51 and (StatTable.DamRoll >  100 or StatTable.HitRoll > 100)) then
        UseSkillAfterExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "racial frenzy")
      end
  elseif MyRace == "Ignatur" then
    
    if StatTable.Level == 51 and not RacialFireaura and not StatTable.RacialFireauraFatigue then
      TryGameLoopAction("racial fireaura", 30)
    end
  
  elseif MyRace == "Illithid" then
    local level_diff = (StatTable.Level == 125 and 25 or 10)
    
    if not StatTable.MindFlay and tonumber(gmcp.Char.Vitals.lag) == 0 and tonumber(gmcp.Char.Status.opponent_level) > (StatTable.Level + level_diff) then
      TryGameLoopAction("racial mindflay", 30)
    end
    

  
  
  
   end -- end of MyRace
end

function GameLoopOutOfCombatBuffs(MyClass)
  if not GlobalVar.AutoBuff then return end
  if SafeArea() then return end
  if (tonumber(StatTable.Foci) or 0) <= 1 then return end
  if Battle.Combat then return end
  if StatTable.Position ~= "Stand" then return end

  local mana_pct = ((StatTable.max_mana or 0) > 0) and (StatTable.current_mana / StatTable.max_mana) or 0

  if MyClass == "Sorcerer" then
    local min_moves = GroupHasClass({"Pal", "Paladin"}) and 20000 or 2000

    if StatTable.Level >= 51 and not StatTable.DeathShroud then
      BuffManager.Add("cast 'death shroud'", 1)
    end
    if StatTable.Level == 125 and StatTable.SubLevel >= 200 and not StatTable.VilePhilosophy then
      BuffManager.Add("cast 'vile philosophy'", 1)
    end
    if StatTable.max_mana > 5000 and not StatTable.Mystical then
      BuffManager.Add("cast mystical", 1)
    end
    if StatTable.Level == 125 and not StatTable.UnholyBargainExhaust and StatTable.current_health >= StatTable.max_health and StatTable.current_moves > min_moves and StatTable.current_mana < (StatTable.max_mana - 1000) and not GroupLeader() then
      BuffManager.Add("cast 'unholy bargain'", 1)
    end

  elseif MyClass == "Wizard" then
    if StatTable.max_mana > 5000 and not StatTable.Mystical then
      BuffManager.Add("cast mystical", 1)
    end

  elseif MyClass == "Mage" then
    if StatTable.max_mana > 5000 and not StatTable.Mystical then
      BuffManager.Add("cast mystical", 1)
    end

  elseif MyClass == "Necromancer" then
    if StatTable.max_mana > 5000 and not StatTable.Mystical then
      BuffManager.Add("cast mystical", 1)
    end

  elseif MyClass == "Stormlord" then
    if StatTable.Level == 125 and not StatTable.Solitude and not StatTable.GaleStratum and mana_pct > 0.5 then
      BuffManager.Add("cast stratum gale", 1)
    end

  elseif MyClass == "Black Circle Initiate" then
    if StatTable.Level == 125 then
      if not StatTable.KahbyssInsight and not StatTable.KahbyssInsightExhaust then
        BuffManager.Add("cast 'kahbyss insight'", 1)
      elseif not StatTable.SenseWeakness and not StatTable.SenseWeaknessExhaust then
        BuffManager.Add("cast 'sense weakness'", 1)
      end
    elseif StatTable.Level == 51 and StatTable.SubLevel > 250 and not StatTable.SenseWeakness and not StatTable.SenseWeaknessExhaust then
      BuffManager.Add("cast 'sense weakness'", 1)
    end

  elseif MyClass == "Bodyguard" then
    if not StatTable.Alertness and Grouped() and StatTable.current_moves > 1000 and TryLock("GameLoopAlertness", 30) then
      BuffManager.Add("alertness", 1)
    end

  elseif MyClass == "Monk" then
    if StatTable.Level == 125 then
      if not StatTable.StoneFist then BuffManager.Add("cast 'stone fist'", 1) end
      if StatTable.SubLevel >= 200 and not StatTable.FlowLikeWater and not StatTable.FlowLikeWaterExhaust and StatTable.InnerQi >= 5 then
        BuffManager.Add("cast 'flow like water'", 1)
      end
    end

  elseif MyClass == "Shadowfist" then
    if StatTable.Level == 51 and StatTable.SubLevel > 100 then
      if not StatTable.DaggerHand then BuffManager.Add("cast 'dagger hand'", 1) end
    elseif StatTable.Level == 125 then
      if not StatTable.StoneFist then BuffManager.Add("cast 'stone fist'", 1) end
      if StatTable.SubLevel >= 200 and not StatTable.BurningFury and not StatTable.BurningFuryExhaust and StatTable.InnerQi >= 5 then
        BuffManager.Add("cast 'burning fury'", 1)
      end
    end

  elseif MyClass == "Psionicist" then
    if StatTable.Level == 125 and not StatTable.IllusoryShield and StatTable.current_mana > 1000 then
      BuffManager.Add("cast 'illusory shield'", 1)
    end
    if StatTable.Level == 125 and not StatTable.KineticChain and not StatTable.KineticChainExhaust and StatTable.current_mana > 10000 then
      BuffManager.Add("cast 'kinetic chain'", 1)
    end
    if StatTable.Level == 125 and StatTable.SubLevel > 200 and not StatTable.Gravitas and StatTable.current_mana > 1000 then
      BuffManager.Add("cast 'gravitas'", 1)
    end

  elseif MyClass == "Mindbender" then
    if StatTable.Level == 125 and not StatTable.IllusoryShield and StatTable.current_mana > 1000 then
      BuffManager.Add("cast 'illusory shield'", 1)
    end
    if StatTable.Level == 125 and not StatTable.HiveMind and StatTable.current_mana > 1000 then
      BuffManager.Add("cast 'hive mind'", 1)
    end

  elseif MyClass == "Fury" then
    if StatTable.Level >= 51 and not StatTable.Wildmind and StatTable.current_mana > 250 then
      BuffManager.Add("cast 'wildmind'", 1)
    end

  elseif MyClass == "Druid" then
    if StatTable.Level == 125 and not StatTable.SiderealReflections then
      BuffManager.Add("cast 'sidereal reflections'", 1)
    end

  elseif MyClass == "Paladin" then
    if StatTable.Oath ~= "" and GlobalVar.PaladinRescue then
      if StatTable.Level == 51 and StatTable.SubLevel >= 250 and not StatTable.JoinedBoon and not StatTable.HeroicBoon then
        BuffManager.Add("cast 'joined boon'", 1)
      end
      if StatTable.Level == 125 and not StatTable.SharedBoon and not StatTable.ValorousBoon and not StatTable.FinalBoon then
        BuffManager.Add("cast 'shared boon'", 1)
      end
    end
  end
end


function GameLoop()
  
  local MyClass = StatTable.Class
  local MyRace = StatTable.Race
  
  if not MyClass or not MyRace then return end
  
  -- Misc Run Scripts
  if (StatTable.current_health >= StatTable.max_health and StatTable.current_mana >= StatTable.max_mana and StatTable.current_moves >= StatTable.max_moves and StatTable.Foci and StatTable.Position == "Sleep" and (not SafeArea() or Grouped())) then TryAction("stand",30) end
  
  if MyClass ~= "Sorcerer" and MyClass ~= "Shadowfist" and MyRace ~= "Demonseed" and MyRace ~= "Illithid" and
     StatTable.Alignment < 750 and StatTable.Level >= 51 and
     (not AltList or not AltList.Chars[StatTable.CharName].Insig or not AltList.Chars[StatTable.CharName].Insig.AcolyteOfTheTemple) then
    
    if (MyClass == "Priest" and StatTable.Level == 125 and StatTable.CriticalInjured == 0 and not Battle.Combat and tonumber(gmcp.Char.Vitals.lag) == 0) then
      if StatTable.Alignment < 700 then TryAction("quicken 3" .. cs .. "cast absolve" .. cs .. "quicken off", 60) end
      TryAction("quicken 3" .. cs .. "preach absolve" .. cs .. "quicken off",60)
    else
      if IsMDAY() then 
        TryAction("emote alignment has dropped below 750 - please |BW|preach absolve|N|", 600) 
      else
        TryFunction("printAlignmentWarningID", printGameMessage, {"Warning!", "Alignment is below 750!"}, 600)
      end    
    end
  end
  
  
  -- Monitor rescue
  if AR.Status and AR.MonitorRescue and IsGroupMate(StatTable.Monitor) then
    if tonumber(gmcp.Char.Vitals.monhp) and StatTable.current_mon > 0 and StatTable.max_mon > 0 and StatTable.Monitor ~= "" then
        local MonitorHPpct = StatTable.current_mon / StatTable.max_mon
        if MonitorHPpct < AR.MontorRescueHPpct then
            TryGameLoopAction("rescue " .. StatTable.Monitor, 5)
        end
    end
  end
 
  -- Reset Bladetrance level if needed
  if not StatTable.Bladetrance then 
   StatTable.BladetranceLevel = 0
  elseif StatTable.Bladetrance and StatTable.BladetranceLevel == 0 then
    TryGameLoopAction("bladetrance", 30)
  end

  
  -- Wear leveling gear if enabled and tnl less than 300 (should go elsewhere)
  if (GlobalVar.LevelReady == false and GlobalVar.LevelGear == true) then
    if (StatTable.current_tnl <= 300) then
      send("level")
      GlobalVar.LevelReady = true
    end
  end
  
  -- Priest specific out of combat stuff
  if MyClass == "Priest" and (StatTable.Position == "Stand" or StatTable.Position == "Fighting") then
    if (StatTable.Level > 51 or StatTable.SubLevel > 250) and not StatTable.Intervention and Battle.Recent then
      -- how do we know when intervention is down on target?
      -- todo fix the below, only works on self (first arg should be nil for others)
      UseSkillAfterExhaust(StatTable.Intervention, StatTable.InterventionExhaust, "cast intervention " .. (GlobalVar.InterventionTarget and GlobalVar.InterventionTarget or ""))    
    end
    
   if StatTable.Level == 125 and gmcp.Char.Vitals.lag == "0" then
      if (StatTable.Fear or StatTable.Blindness or StatTable.Flash or StatTable.Scramble or StatTable.Overconfidence) and (StatTable.CriticalInjured == 0 or not Battle.Combat) then
        --TryCast("preach clarify", 30)
        if TryFunction("PreachClarify", Battle.NextAct, {"preach clarify", 7}, 15) then
          printGameMessage("GameLoop", "Attempting to preach clarify")
        end
      elseif (StatTable.Poison or StatTable.Virus or StatTable.Weaken) and (StatTable.CriticalInjured == 0 or not Battle.Combat) then

        if TryFunction("PreachPanacea", Battle.NextAct, {"quicken 5" .. getCommandSeparator() .. "preach panacea" .. getCommandSeparator() .. "quicken off", 7}, 15) then
          printGameMessage("GameLoop", "Attempting to preach panacea")
        end
      --elseif StatTable.InjuredCount > 0 and (StatTable.current_mana / StatTable.max_mana) > 0.5 and not SafeArea() then
        --if StatTable.Augment then TryAction("augment off", 120) end
        --TryCast("cast comfort " .. GlobalVar.VizMonitor, 10)      
      end
    end
      
  end
  
  GameLoopOutOfCombatBuffs(MyClass)
  
  -- Call Class and Race specific GameLoops if we are in combat
  if not GlobalVar.AutoStance then return end
  if Battle.Combat then
    GameLoopClass(MyClass)
    GameLoopRace(MyRace)
    
  elseif not SafeArea() and StatTable.Position == "Stand" then -- out of combat stuff, not in safe area
    if MyClass == "Cleric" then castPantheonSpell()
    elseif MyClass == "Psionicist" then castKineticEnhancers()
    elseif MyClass == "Mage" then castHighMagickSpell()
    end
    if StatTable.Level == 125 then
      if StatTable.Curse and StatTable.Curse ~= "continuous" and
        IsNotClass({"Priest", "Berserker", "Shadowfist", "Bodyguard", "Black Circle Initiate"}) then
          if not Battle.Combat then TryAction("cast 'remove curse'", 60) end
      elseif StatTable.Curse and StatTable.Class == "Priest" then
        TryAction("quicken 3" .. getCommandSeparator() .. "preach absolve" .. getCommandSeparator() .. "quicken off", 30)   
      end
    end  
  end
    


  --else printGameMessage("GameLoop", "Not in combat") 
  raiseEvent("CustomGameLoop") -- can be used if you want to write your own custom commands
end


