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
            
    if (StatTable.BrimstoneExhaust ~= nil and string.lower(GlobalVar.AutoCaster) == "brimstone") then
      AutoCastSetSpell("maelstrom")                 
    end
    
    -- Move this to trigger once migraine exhaust over trigger text captured
    if (StatTable.BrimstoneExhaust == nil and StatTable.Level == 125 and string.lower(GlobalVar.AutoCaster) == "maelstrom") then
      AutoCastSetSpell("brimstone")
    end
    
    if StatTable.Level == 125 then
    -- Use Unholy Bargain when avail and at max health
      if not StatTable.UnholyBargainExhaust and StatTable.current_health == StatTable.max_health and StatTable.current_moves > 2000 and StatTable.current_mana < (StatTable.max_mana - 1000) and not GroupLeader() then
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
      if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
      --printGameMessage("Debug", "Opponent health is " .. tonumber(gmcp.Char.Status.opponent_health))
      if tonumber(gmcp.Char.Status.opponent_health) < 30 then return end -- don't try this on that's almost dead
      
      local StanceTimer = 2
      if tonumber(gmcp.Char.Vitals.lag) > 0 then return end -- we only want to try this if we're out of lag
      if StatTable.Level == 125 then
        if not Grouped() then return end -- don't autostance if solo'ing as bld at lord
        
        -- Break trance at 700 mana to save mana for swapping stances or planing thorn
        if StatTable.BladetranceLevel > 0 and StatTable.current_mana < 700 then TryAction("bladetrance break", 10) end
        
        -- If we've manually set a nextstance, we'll do that one
        if GlobalVar.NextStance and
           ((StatTable.InspireTimer and StatTable.InspireTimer < StanceTimer) or
           (StatTable.BladedanceTimer and StatTable.BladedanceTimer < StanceTimer) or
           (StatTable.DervishTimer and StatTable.DervishTimer < StanceTimer) or
           (StatTable.VeilTimer and StatTable.VeilTimer < StanceTimer) or
           (StatTable.UnendTimer and StatTable.UnendTimer < (StanceTimer + 2))) then
           TryAction("stance " .. GlobalVar.NextStance, 10)
           GlobalVar.NextStance = nil
           return
        end
        
        -- General Timer, all non-veil/unending dances will swap to veil upon completion       
        if (StatTable.InspireTimer and StatTable.InspireTimer < StanceTimer) or
           (StatTable.BladedanceTimer and StatTable.BladedanceTimer < StanceTimer) or
           (StatTable.DervishTimer and StatTable.DervishTimer < StanceTimer) then
           
           
          TryAction("stance veil of blades",10)
          local manapct = (StatTable.current_mana / StatTable.max_mana)
          if manapct > 0.5 then
            TryAction("bladetrance enter", 10)
            if StatTable.current_mana > 10000 then
              TryAction("bladetrance deepen;bladetrance deepen", 10)
            elseif StatTable.current_mana > 5000 then
              TryAction("bladetrance deepen", 10)
            end
              
          end
        
        -- Veil and Undending swap into inspiring      
        elseif (StatTable.VeilTimer and StatTable.VeilTimer < StanceTimer) or
               (StatTable.UnendTimer and StatTable.UnendTimer < (StanceTimer + 2)) then
               
          TryAction("stance inspiring dance",10)
          if StatTable.Bladetrance then TryAction("bladetrance break", 10) end
        
        -- Emote when epiphany is near
        elseif StatTable.InspireTimer and StatTable.InspireTimer == StanceTimer then
          TryAction("emote |N| |BW|INSPIRING @ |BY|" .. StatTable.InspireTimer, 60)
        
        -- If we find we're not dancing for some reason, attempt to dance  
        elseif not BldDancing() then
          if not StatTable.InspireExhaust then TryAction("stance inspiring dance",10) 
          elseif not StatTable.VeilExhaust then TryAction("stance veil of blades",10)
          elseif not StatTable.UnendExhaust then TryAction("stance unending dance",10)
          else TryAction("stance bladedance",10)
          end
        end
      elseif StatTable.SubLevel > 101 then
        -- hero code
        if not StatTable.BladedanceTimer and not StatTable.DervishTimer and not StatTable.InspireTimer then 
          if not StatTable.BladedanceExhaust then TryAction("stance bladedance", 10) 
          elseif not StatTable.DervishExhaust then TryAction("stance dervish", 10) end
        end
      
      end
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
      end
    elseif MyClass == "Shadowfist" then
      if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
      if StatTable.ArmorClass > -1000 and StatTable.Level == 51 then
        if not StatTable.DaggerHand then
          TryFunction("GameLoopDaggerHand", Battle.DoAfterCombat, {"cast 'dagger hand'"}, 60)       
        end
      end
      if StatTable.Level == 125 or StatTable.SubLevel > 100 then
      
        -- Vampire fang will be prioritzed when health is less than 75% max, otherwise spectral is prioritized
        if not StatTable.VampireFangExhaust and StatTable.current_health < (StatTable.max_health * 0.75) then
          UseSkillAfterExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "stance vampire fang")
        else
          UseSkillAfterExhaust(StatTable.SpectralFang, StatTable.SpectralFangExhaust, "stance spectral fang")
          if StatTable.SpectralFangExhaust then UseSkillAfterExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "stance vampire fang") end
        end
        
      end    
    elseif MyClass == "Soldier" then
      if not GlobalVar.AutoStance then return end -- only swap if GlobalVar.AutoStance is on
      if StatTable.Level == 125 then
        UseSkillAfterExhaust(StatTable.StanceEchelon, StatTable.EchelonExhaust, "stance echelon")
      end
    elseif MyClass == "Cleric" then
      if GlobalVar.Pantheon and not StatTable.ArtificerBlessing and not StatTable.Discordia and not StatTable.DivineAdjutant and not StatTable.DivineGrace and
         not StatTable.GloriousConquest and not StatTable.GrimHarvest and not StatTable.HallowedNimbus and not StatTable.ProtectiveVigil and
         not StatTable.SylvanBenediction and not StatTable.UnholyRampage then
         
         if TryLock("GameLoopPantheon", 30) then 
           printMessage("TESTING", "Cleric Pantheon down, would cast after battle")
           Battle.DoAfterCombat("cast '" .. GlobalVar.Pantheon .. "'") 
         end
      end

    
    
      
    elseif MyClass == "Priest" then
         
     
    elseif MyClass == "Psionicist" then

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
  if (StatTable.current_health == StatTable.max_health and StatTable.current_mana == StatTable.max_mana and StatTable.Foci and StatTable.Position == "Sleep" and (not SafeArea() or Grouped())) then TryAction("stand",100) end
  
  if MyClass ~= "Sorcerer" and MyClass ~= "Shadowfist" and MyRace ~= "Demonseed" and StatTable.Alignment < 750 and StatTable.Level >= 51 then
    if (MyClass == "Priest" and StatTable.Level == 125 and StatTable.CriticalInjured == 0) then
      TryAction("quicken 3" .. getCommandSeparator() .. "preach absolve" .. getCommandSeparator() .. "quicken off",60)
    else

      if IsMDAY then TryAction("emote alignment has dropped below 750 - please |BW|preach absolve|N|", 600) end

    end
  end
  
  
  -- Monitor rescue
  if AR.Status and AR.MonitorRescue then
    if StatTable.current_mon > 0 and StatTable.max_mon > 0 and StatTable.Monitor ~= "" then
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
    
   if StatTable.Level == 125 then
      if (StatTable.Fear or StatTable.Blindness or StatTable.Flash or StatTable.Scramble or StatTable.Overconfidence) and (StatTable.CriticalInjured == 0 or not Battle.Combat) then
        --TryCast("preach clarify", 30)
        if TryFunction("PreachClarify", Battle.NextAct, {"preach clarify", 7}, 15) then
          printGameMessage("GameLoop", "Attempting to preach clarify")
        end
      end
      if (StatTable.Poison or StatTable.Virus or StatTable.Weaken) and (StatTable.CriticalInjured == 0 or not Battle.Combat) then

        if TryFunction("PreachPanacea", Battle.NextAct, {"quicken 5" .. getCommandSeparator() .. "preach panacea" .. getCommandSeparator() .. "quicken off", 7}, 15) then
          printGameMessage("GameLoop", "Attempting to preach panacea")
        end
      end
    end
      
  end
  
  
  -- Call Class and Race specific GameLoops if we are in combat
  if Battle.Combat then
    GameLoopClass(MyClass)
    GameLoopRace(MyRace)
    
  elseif not SafeArea() then -- out of combat stuff, not in safe area
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


