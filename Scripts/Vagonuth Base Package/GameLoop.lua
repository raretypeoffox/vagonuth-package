-- Script: GameLoop
-- Attribute: isActive

-- Script Code:
 
 local function UseSkillAfterExhaust(Skill, SkillExhaust, Command)
  if Skill == nil and SkillExhaust == nil then
    if TryAction(Command, 30) then
      printGameMessageVerbose("GameLoop", Command)
    end
  end 
 end
 
 -- note: only ran while we're in combat
 function GameLoopClass(MyClass)
  local mana_pct = StatTable.current_mana / StatTable.max_mana

  if MyClass == "Sorcerer" then       

    
    if StatTable.Level == 125 then
      if (StatTable.BrimstoneExhaust ~= nil and string.lower(GlobalVar.AutoCaster) == "brimstone") then
        AutoCastSetSpell("maelstrom")                 
      end
      
      -- Move this to trigger once migraine exhaust over trigger text captured
      if (StatTable.BrimstoneExhaust == nil and StatTable.Level == 125 and string.lower(GlobalVar.AutoCaster) == "maelstrom") then
        AutoCastSetSpell("brimstone")
      end
      
    -- Use Unholy Bargain when avail and at max health
      if not StatTable.UnholyBargainExhaust and StatTable.current_health >= StatTable.max_health and StatTable.current_moves > 2000 and StatTable.current_mana < (StatTable.max_mana - 1000) and not GroupLeader() then
        TryQueue("cast 'unholy bargain'", 60)
      end      
    end
  elseif MyClass == "Stormlord" then
    if StatTable.Level == 125 then
      if not StatTable.Solitude and not StatTable.GaleStratum and mana_pct > 0.5 then
        TryAction("cast stratum gale", 30)
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
    if not StatTable.Alertness and Grouped() and StatTable.current_moves > 1000 and TryLock("GameLoopAlertness", 30) then Battle.DoAfterCombat("alertness") end
    
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
    if StatTable.Level == 51 and not StatTable.Rally then TryAction("rally", 60) end
  
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
      if not StatTable.StoneFist then Battle.DoAfterCombat("cast 'stone fist'") end
      
      -- qi loop      
      local chakra = Battle.EnemiesChakra[gmcp.Char.Status.opponent_name] or nil
      
      if StatTable.OuterQi >= 10 then
         if tonumber(gmcp.Char.Status.opponent_level) > 180 then --or StatTable.OuterQi == 23 (ie max)
            if StatTable.SubLevel >= 250 then
              TryAction("qi wave", 5)
            else
              TryAction("qi blast", 5)
            end
         end
      end
      
      if StatTable.SubLevel >= 200 and not StatTable.FlowLikeWater and not StatTable.FlowLikeWaterExhaust and StatTable.InnerQi >= 5 then
        Battle.DoAfterCombat("cast 'flow like water'")

      
      -- if there are groupies to rescue or we're in lag, try again later.
      -- TODO: perhaps check if we're the only tank?
      elseif (AR.Status and table.size(AR.RescueStack) > 0) or tonumber(gmcp.Char.Vitals.lag) > 0 then
        return
      elseif chakra and StatTable.SubLevel >= 100 and StatTable.InnerQi >= 7 then
        TryAction("qi invert " .. (chakra and chakra or ""), 15)
      elseif chakra and StatTable.InnerQi >= 7 then
        TryAction("qi strike " .. (chakra and chakra or ""), 15)
      elseif StatTable.StoneFist and StatTable.InnerQi >= 7 then
        TryAction("qi punch", 5)
      elseif StatTable.DaggerHand and StatTable.InnerQi >= 7 then
        TryAction("qi thrust", 5)  
      else
        TryAction("kick", 5)
      end
      
    end
  elseif MyClass == "Shadowfist" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    
    if StatTable.Level == 51 and StatTable.SubLevel > 100 then
      if not StatTable.DaggerHand then Battle.DoAfterCombat("cast 'dagger hand'") end
      
      -- Vampire fang will be prioritzed when health is less than 75% max, otherwise spectral is prioritized
      if not StatTable.VampireFangExhaust and StatTable.current_health < (StatTable.max_health * 0.75) then
        UseSkillAfterExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "stance vampire fang")
      else
        UseSkillAfterExhaust(StatTable.SpectralFang, StatTable.SpectralFangExhaust, "stance spectral fang")
        if StatTable.SpectralFangExhaust then UseSkillAfterExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "stance vampire fang") end
      end
      
    elseif StatTable.Level == 125 then
      if not StatTable.StoneFist then Battle.DoAfterCombat("cast 'stone fist'") end

      -- Vampire fang will be prioritzed when health is less than 75% max, otherwise spectral is prioritized
      if not (StatTable.VampireFang or StatTable.SpectralFang) then
        if not StatTable.VampireFangExhaust and (StatTable.current_health < (StatTable.max_health * 0.75) or StatTable.SpectralFangExhaust) then
          Battle.DoAfterCombat("stance vampire fang")
          TryAction("ctr vital stay", 5)
        elseif not StatTable.SpectralFangExhaust then
          Battle.DoAfterCombat("stance spectral fang")
          TryAction("ctr push stay", 5)
        end
      end
      
      -- qi loop      
      local chakra = Battle.EnemiesChakra[gmcp.Char.Status.opponent_name] or nil
      
      -- outer qi logic
      if StatTable.OuterQi >= 10 then
        if tonumber(gmcp.Char.Status.opponent_level) > 180 then --or StatTable.OuterQi == 23 (ie max)
          if StatTable.SubLevel >= 250 then
            TryAction("qi wave", 5)
          else
            TryAction("qi blast", 5)
          end
        end
      end

      -- inner qi logic
      if StatTable.SubLevel >= 200 and not StatTable.BurningFury and not StatTable.BurningFuryExhaust and StatTable.InnerQi >= 5 then
          Battle.DoAfterCombat("cast 'burning fury'")
      -- if there are groupies to rescue or we're in lag, try again later.
      -- TODO: perhaps check if we're the only tank?
      elseif (AR.Status and table.size(AR.RescueStack) > 0) or tonumber(gmcp.Char.Vitals.lag) > 0 then
        return
      elseif chakra and StatTable.SubLevel >= 100 and StatTable.InnerQi >= 7 then
        TryAction("qi drain " .. (chakra and chakra or ""), 15)
      elseif chakra and StatTable.InnerQi >= 7 then
        TryAction("qi strike " .. (chakra and chakra or ""), 15)
      elseif StatTable.StoneFist and StatTable.InnerQi >= 7 then
        TryAction("qi punch", 5)
      elseif StatTable.DaggerHand and StatTable.InnerQi >= 7 then
        TryAction("qi thrust", 5)  
      else
        TryAction("vital", 5)
      end
    end
  elseif MyClass == "Soldier" then
    if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
    if StatTable.Level == 125 or StatTable.SubLevel >= 101 then
      if not StatTable.StanceEchelon and not StatTable.EchelonExhaust then
        Battle.DoAfterCombat("stance echelon")
      elseif not StatTable.StanceEchelon and not StatTable.StanceSquare and not StatTable.SquareExhaust then
        Battle.DoAfterCombat("stance square")
      end       

    end
  elseif MyClass == "Cleric" then
    if GlobalVar.Pantheon and not StatTable.ArtificerBlessing and not StatTable.Discordia and not StatTable.DivineAdjutant and not StatTable.DivineGrace and
       not StatTable.GloriousConquest and not StatTable.GrimHarvest and not StatTable.HallowedNimbus and not StatTable.ProtectiveVigil and
       not StatTable.SylvanBenediction and not StatTable.UnholyRampage then
       
       if TryLock("GameLoopPantheon", 30) then 
         Battle.DoAfterCombat("cast '" .. GlobalVar.Pantheon .. "'") 
       end
    end

  
  
    
  elseif MyClass == "Priest" then
       
   
  elseif MyClass == "Psionicist" then
  
  
  elseif MyClass == "Mindbender" then
    if StatTable.Level == 125 and not StatTable.HiveMind and StatTable.current_mana > 1000 then
      Battle.DoAfterCombat("cast 'hive mind'") 
    end

  end -- end of MyClass
 end
 
 function GameLoopRace(MyRace)
   if MyRace == "Troll" then
      if (GlobalVar.AutoRevive and (StatTable.current_health / StatTable.max_health) < GlobalVar.AutoReviveHPpct and StatTable.current_health > 100 and StatTable.Foci) then 
        UseSkillAfterExhaust(StatTable.RacialRevival, StatTable.RacialRevivalFatigue, "racial revival")
      end
   elseif MyRace == "Firedrake" and StatTable.Level == 125 then
        if not StatTable.RacialBreathFatigue and not GroupLeader() then TryAction("racial breath", 30) end
  
  
   elseif MyRace == "Kzinti" then
   
      if (StatTable.Level == 125 and StatTable.DamRoll > 200) or (StatTable.Level == 51 and StatTable.DamRoll >  100) then
        UseSkillAfterExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "racial frenzy")
      end
      
  elseif MyRace == "Orc" then
      if (StatTable.Level == 125 and (StatTable.DamRoll > 200 or StatTable.HitRoll > 200)) or (StatTable.Level == 51 and (StatTable.DamRoll >  100 or StatTable.HitRoll > 100)) then
        UseSkillAfterExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "racial frenzy")
      end
  elseif MyRace == "Ignatur" then
    
    if StatTable.Level == 51 and not RacialFireaura and not StatTable.RacialFireauraFatigue then
      TryAction("racial fireaura", 30)
    end
  
  
  
   end -- end of MyRace
 end
 

 function GameLoop()
  
  local MyClass = StatTable.Class
  local MyRace = StatTable.Race
  
  if not MyClass or not MyRace then return end
  
  -- Misc Run Scripts
  if (StatTable.current_health == StatTable.max_health and StatTable.current_mana == StatTable.max_mana and StatTable.Foci and StatTable.Position == "Sleep" and (not SafeArea() or Grouped())) then TryAction("stand",30) end
  
  if MyClass ~= "Sorcerer" and MyClass ~= "Shadowfist" and MyRace ~= "Demonseed" and
     StatTable.Alignment < 750 and StatTable.Level >= 51 and
     (not AltList or not AltList.Chars[StatTable.CharName].Insig or not AltList.Chars[StatTable.CharName].Insig.AcolyteOfTheTemple) then
    
    if (MyClass == "Priest" and StatTable.Level == 125 and StatTable.CriticalInjured == 0 and not Battle.Combat) then
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
            TryAction("rescue " .. StatTable.Monitor, 5)
        end
    end
  end
 
  -- Reset Bladetrance level if needed
  if not StatTable.Bladetrance then 
   StatTable.BladetranceLevel = 0
  elseif StatTable.Bladetrance and StatTable.BladetranceLevel == 0 then
    TryAction("bladetrance", 30)
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
  
  
  -- Call Class and Race specific GameLoops if we are in combat
  if Battle.Combat then
    GameLoopClass(MyClass)
    GameLoopRace(MyRace)
    
  elseif not SafeArea() and StatTable.Position == "Stand" then -- out of combat stuff, not in safe area
    if MyClass == "Cleric" then castPantheonSpell() end
    if MyClass == "Psionicist" then castKineticEnhancers() end
  end
    
    if StatTable.Level == 125 then
      if StatTable.Curse and StatTable.Curse ~= "continuous" and
        IsNotClass({"Priest", "Berserker", "Shadowfist", "Bodyguard", "Black Circle Initiate"}) then
        --Battle.DoAfterCombat("cast 'remove curse'")
        -- 
        if not Battle.Combat then TryAction("cast 'remove curse'", 60) end
      elseif StatTable.Curse and StatTable.Class == "Priest" then
        TryAction("quicken 3" .. getCommandSeparator() .. "preach absolve" .. getCommandSeparator() .. "quicken off", 30)   
      end
    end

  --else printGameMessage("GameLoop", "Not in combat") 
  raiseEvent("CustomGameLoop") -- can be used if you want to write your own custom commands
end


