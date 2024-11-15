-- Script: Layout Update
-- Attribute: isActive

-- Script Code:
-------------------------------------------------
-- Character Panel /Affects Update Script   
-- Updates all the gauges / labels in the bottom panel as well as the affects panel
-------------------------------------------------

function applyLabelStyle(label, borderColor, bgColor)
    label:setStyleSheet([[
        border-width: 1px;
        border-style: solid;
        border-color: ]] .. borderColor .. [[;
        background-color: ]] .. bgColor .. [[;
        border-radius: 3px;
    ]])
end

function setLabelProperties(label, affect, activeText, missingText, skillCommand)
    if not affect then
        label:echo("<center>" .. missingText .. "</center>")
        applyLabelStyle(label, "yellow", "rgba(255, 0, 0, 0.5)")
        label:setClickCallback(function() send(skillCommand) end)
    else
        label:echo("<center>" .. activeText .. " - " .. affect .. "</center>")
        applyLabelStyle(label, "green", "green")
        label:setClickCallback("")
    end
end

function setLabelPropertiesExhaust(label, affect, affectExhaust, activeText, missingText, skillCommand)
    if not affect and not affectExhaust then
        label:echo("<center>" .. missingText .. "</center>")
        applyLabelStyle(label, "yellow", "rgba(255, 0, 0, 0.5)")
        label:setClickCallback(function() send(skillCommand) end)
    elseif not affect and affectExhaust then
        label:echo("<center>" .. activeText .. " - " .. affectExhaust .. "</center>")
        applyLabelStyle(label, "yellow", "rgba(255, 255, 0, 0.5)")
        label:setClickCallback(function() send(skillCommand) end)
    else
        label:echo("<center>" .. activeText .. " - " .. affect .. "</center>")
        applyLabelStyle(label, "green", "green")
        label:setClickCallback("")
    end
end

function setLabelPropertiesDebuff(label, affect, activeText)
    if affect then
        label:echo("<center>" .. activeText .. " - " .. affect .. "</center>")
        applyLabelStyle(label, "gray", "gray")
        label:setClickCallback("")
    end
end

function setNextAvailableLabel(...)
  for _, label in ipairs(Layout.Labels) do
    if label.hidden then
      setLabelProperties(label, ...)
      label:show()
      break
    end
  end
end

function setNextAvailableLabelIfActive(Stat, labelShort, labelLong, command)
    if Stat then
        setNextAvailableLabel(Stat, labelShort, labelLong, command)
    end
end

function setNextAvailableLabelExhaust(...)
  for _, label in ipairs(Layout.Labels) do
    if label.hidden then
      setLabelPropertiesExhaust(label, ...)
      label:show()
      break
    end
  end
end

function setNextAvailableLabelDebuff(...)
  for _, label in ipairs(Layout.Labels) do
    if label.hidden then
      setLabelPropertiesDebuff(label, ...)
      label:show()
      break
    end
  end
end


 -- called on update to GMCP_Vitals()
function UpdateGUI()
    local MyClass = StatTable.Class -- local variables are inherently faster in Lua, as they exist in the virtual machine registers
    local MyRace = StatTable.Race
    local MyLevel = StatTable.Level
    local MySubLevel = StatTable.SubLevel
       
      -- character data / gauges
      CharNameLabel:echo("<center>" .. string.upper(StatTable.CharName) .. "</center>")
      CharInfoLabel:echo("<center>" .. string.upper(MyRace) .." " .. string.upper(MyClass) .. "</center>")
      if (MyLevel < 51) then
        CharLevelLabel:echo("<center>Level: " .. MyLevel .. "</center>")
      elseif (MyLevel == 51) then
        CharLevelLabel:echo("<center>Hero: " .. MySubLevel .. "</center>")
      elseif (MyLevel == 125) then
        CharLevelLabel:echo("<center>Lord: " .. MySubLevel .. "</center>")
      else
        CharLevelLabel:echo("<center>Level:(" .. MyLevel ..") " .. MySubLevel .. "</center>")
      end
      CharHitDamLabel:echo("<center>HR: " .. StatTable.HitRoll .."      DR: " .. StatTable.DamRoll .. "</center>")
      CharACLabel:echo("<center>AC: " .. StatTable.ArmorClass .."</center>")
      
      RunXPLabel:echo("<center>" .. RunStats.RunXp .. " XP</center>")
      RunKillsLabel:echo("<center>" .. RunStats.RunKills .. " Kills</center>")
      RunLevelsLabel:echo("<center>" .. RunStats.RunLevels .. " Levels</center>")
      RunStatsLabel:echo("<center>" .. RunStats.RunHP .. "HP / " .. RunStats.RunMP .. "MA</center>" )
      
      MainHPBar:setValue(StatTable.current_health,StatTable.max_health,"<h3><b><center>".. StatTable.current_health .. "/" .. StatTable.max_health .. "  HP</b></center></h3>")
      MainMPBar:setValue(StatTable.current_mana,StatTable.max_mana,"<h3><b><center>".. StatTable.current_mana .. "/" .. StatTable.max_mana .. "  Mana</b></center></h3>")
      MoveBar:setValue(StatTable.current_moves,StatTable.max_moves,"<h3><b><center>".. StatTable.current_moves .. "/" .. StatTable.max_moves .. "  Moves</b></center></h3>")
      TNLBar:setValue(math.min(StatTable.current_tnl, StatTable.max_tnl), StatTable.max_tnl, "<h3><b><span style='color: black'><center>" .. StatTable.current_tnl .. "/" .. StatTable.max_tnl .. "  TNL</b></center></h3>")
      
      
      
      if (StatTable.current_mon == nil or StatTable.current_mon == "" or StatTable.current_mon == null or StatTable.Monitor == nil) then
          MonitorBar:setValue(1,1,"<h3><b><center> NO MONITOR</b></center></h2>") 
      else
          MonitorBar:setValue(StatTable.current_mon,StatTable.max_mon,"<h3><b><center>".. RemoveColourCodes(StatTable.Monitor) .. ":" .. StatTable.current_mon .. "/" .. StatTable.max_mon .. "  HP</b></center></h3>")
      end
      
      if not(StatTable.Enemy == nil or StatTable.Enemy == "") then 
          EnemyBar:setValue(StatTable.EnemyHP,StatTable.EnemyMaxHP,"<b><center>Fighting: " .. RemoveColourCodes(StatTable.Enemy) ..  " LV:" .. gmcp.Char.Status.opponent_level .. "</b></center>")
      else
          EnemyBar:setValue(0,100,"<h3><b><center> NO TARGET</b></center></h3>") 
      end
      
      -- Item and Weight and Aligment
      WeightBar:setValue(math.min(StatTable.Weight, StatTable.MaxWeight), StatTable.MaxWeight, "<h3><b><center>" .. StatTable.Weight .. "/" .. StatTable.MaxWeight .. "  lbs</b></center></h3>")
      ItemsBar:setValue(StatTable.Items,StatTable.MaxItems,"<h3><b><center>".. StatTable.Items .. "/" .. StatTable.MaxItems .. "  items</b></center></h3>")
      AlignmentBar:setValue((StatTable.Alignment + 1000),2000,"<h3><b><center> Align: " .. StatTable.Alignment .. "</b></center></h3>")
      
      -- Lag / Qi / Savespell
      LagLabel:echo("<center>lag: " .. tonumber(gmcp.Char.Vitals.lag) .. "</center>")
      
      if StatTable.Class == "Monk" then
        QiLabel:show()
        applyLabelStyle(QiLabel, "green", "green")
        QiLabel:echo("<center>" .. StatTable.InnerQi .. " / " .. StatTable.OuterQi .. "</center>")     
      elseif StatTable.Class == "Bladedancer" then
        QiLabel:show()
        if StatTable.BladetranceLevel > 0 then
          applyLabelStyle(QiLabel, "green", "green")
          QiLabel:echo("<center>BT " .. StatTable.BladetranceLevel .. "</center>")   
        else
          applyLabelStyle(QiLabel, "yellow", "rgba(255, 0, 0, 0.5)")   
          QiLabel:echo("<center>BT off</center>")
        end
      elseif IsClass({"Priest", "Cleric", "Druid", "Paladin"}) then
        QiLabel:show()
        if GlobalVar.AutoHeal then
          applyLabelStyle(QiLabel, "green", "green")
          QiLabel:echo("<center>AH ON</center>")   
        else
          applyLabelStyle(QiLabel, "yellow", "rgba(255, 0, 0, 0.5)")   
          QiLabel:echo("<center>AH off</center>")
        end
      else
        QiLabel:hide()
      end


      if StatTable.Savespell then
        if StatTable.current_health == StatTable.max_health
        and StatTable.max_mana == StatTable.current_mana
        and StatTable.current_moves >= StatTable.max_moves * 0.8
        and StatTable.current_moves <= StatTable.max_moves then
          SavespellLabel:echo("<center>S/S Active</center>")
          applyLabelStyle(SavespellLabel, "green", "green")
        else
          SavespellLabel:echo("<center>S/S ON</center>")
          applyLabelStyle(SavespellLabel, "yellow", "rgba(255, 0, 0, 0.5)")
        end
        SavespellLabel:setClickCallback([[UseSkill("config -savespell")]])
      else
          SavespellLabel:echo("<center>S/S OFF</center>")
          applyLabelStyle(SavespellLabel, "yellow", "rgba(255, 0, 0, 0.5)")
          SavespellLabel:setClickCallback([[UseSkill("config +savespell")]])
      end
      
      -- Skills/spells that apply to all (Rows 1 - 5)
      setLabelProperties(MoveHiddenLabel, StatTable.MoveHidden, "Move Hidden", "Not Hidden", "move hidden")
      setLabelProperties(SneakLabel, StatTable.Sneak, "Sneak", "Not Sneaky", "sneak")
      setLabelProperties(InvisLabel, StatTable.Invis, "Invis", "Visible", "cast invis")
      setLabelProperties(SancLabel, StatTable.Sanctuary, "Sanc", "Sanctuary", "cast sanctuary")
      setLabelProperties(WaterLabel, StatTable.WaterBreathing, "Water", "Water", "cast 'water breathing'")
      if StatTable.Frenzy == nil and StatTable.Fervor == nil then
        setLabelProperties(FrenzyLabel, nil, "Frenzy", "Frenzy", MyClass == "Paladin" and "cast fervor" or "cast frenzy")
      elseif MyClass == "Paladin" and StatTable.Fervor then
        setLabelProperties(FrenzyLabel, StatTable.Fervor, "Fervor", "Fervor", "cast fervor")
      else
        setLabelProperties(FrenzyLabel, StatTable.Frenzy, "Frenzy", "Frenzy", "cast frenzy")
      end

      setLabelProperties(FortLabel, StatTable.Fortitude, "Fort", "Fortitude", "cast fort")
      setLabelProperties(FociLabel, StatTable.Foci, "Foci", "Foci", "cast foci")
      setLabelProperties(AwenLabel, StatTable.Awen, "Awen", "Awen", "cast awen")
      setLabelProperties(InvincLabel, StatTable.Invincibility, "Invinc", "Invinc", "cast invinc")
      setLabelProperties(BarkLabel, StatTable.Barkskin, "Bark", "Barkskin", "cast barkskin")
      setLabelProperties(SteelLabel, StatTable.SteelSkeleton, "Steel", "Steel Skel.", "cast 'steel skeleton'")
      setLabelProperties(IronLabel, StatTable.IronSkin, "Iron", "Iron Skin", "cast 'iron skin'")
      setLabelProperties(ConcentrateLabel, StatTable.Concentrate, "Concen", "Concentrade", "cast concentrate")
      setLabelProperties(WerreLabel, StatTable.Werrebocler, "Bocler", "Werrebocler", "cast werrebocler")
      
      -- Custom labels for classes / races (rows 6+)
      
      for _, label in ipairs(Layout.Labels) do
        label:hide()
      end
      
      if MyClass == "Mage" then
        setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
        setNextAvailableLabel(StatTable.Mystical, "Mystical", "Mystical", "cast mystical")
      elseif MyClass == "Wizard" then
        if MyLevel > 51 or MySubLevel > 101 then  
          setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
          setNextAvailableLabel(StatTable.Mystical, "Mystical", "Mystical", "cast mystical")
          setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
        end
        if MyLevel == 125 then 
          setNextAvailableLabelExhaust(StatTable.EtherLink, StatTable.EtherLinkExhaust, "Ether Link", "Ether Link", "cast 'ether link'")
          setNextAvailableLabelExhaust(StatTable.EtherWarp, StatTable.EtherWarpExhaust, "Ether Warp", "Ether Warp", "cast 'ether warp'")
          setNextAvailableLabelExhaust(StatTable.EtherCrashDuration, StatTable.EtherCrashExhaust, "Ether Crash", "Ether Crash", "cast 'ether crash'")
        end
      elseif MyClass == "Stormlord" then  
        setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
        setNextAvailableLabel(StatTable.SpringRain, "Spring Rain", "Spring Rain", "cast 'spring rain'")
        setNextAvailableLabel(StatTable.GaleStratum, "Gale", "Gale Stratum", "cast stratum gale")
      elseif MyClass =="Sorcerer" then
        setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
        setNextAvailableLabel(StatTable.Mystical, "Mystical", "Mystical", "cast mystical")
        setNextAvailableLabel(StatTable.DeathShroud, "Death Shd", "Death Shd", "cast 'death shroud'")
        setNextAvailableLabelExhaust(StatTable.Tainted, StatTable.TaintedExhaust, "Tainted", "Tainted", "cast tainted") 
        setNextAvailableLabel(StatTable.DefiledFlesh, "Defiled", "Defiled", "cast defiled")
        if (MyLevel == 125) then setNextAvailableLabelExhaust(nil, StatTable.UnholyBargainExhaust, "Unholy Barg", "Unholy Barg", "cast 'unholy bargain'") end
        if MyLevel == 125 and MySubLevel >= 200 then setNextAvailableLabel(StatTable.VilePhilosophy, "Vile Phil.", "Vile Phil.", "cast 'vile philosophy") end       
        setNextAvailableLabel(StatTable.SummonNecrit, "Necrit", "Necrit", "cast 'summon necrit'")
        if StatTable.Immolation then setNextAvailableLabel(StatTable.Immolation, "Immo", "Immo", "") end
        if StatTable.AstralPrison then setNextAvailableLabel(StatTable.AstralPrison, "Astral", "Astral", "") end
        
        if StatTable.EmotiveDrainExhaust then setNextAvailableLabelExhaust(StatTable.EmotiveDrain, StatTable.EmotiveDrainExhaust, "Emotive", "Emotive", "cast 'emotive drain'") end
        if StatTable.BrimstoneExhaust then setNextAvailableLabelExhaust(nil, StatTable.BrimstoneExhaust, "Brimstone", "Brimstone", "") end
      elseif MyClass == "Rogue" then
        setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
      elseif MyClass == "Assassin" then
        setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
      
      elseif MyClass == "Bladedancer" then
        setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
        if (MyLevel == 125 or MySubLevel > 100) then
          setNextAvailableLabelExhaust(StatTable.BladedanceTimer, StatTable.BladedanceExhaust, "Blade", "Bladedance", "stance bladedance")
          setNextAvailableLabelExhaust(StatTable.DervishTimer, StatTable.DervishExhaust, "Dervish", "Dervish Dance", "stance dervish dance")
          setNextAvailableLabelExhaust(StatTable.InspireTimer, StatTable.InspireExhaust, "Inspire", "Inspiring Dance", "stance inspiring dance")
        
        end
        if (MyLevel == 125) then  
          setNextAvailableLabelExhaust(StatTable.VeilTimer, StatTable.VeilExhaust, "Veil", "Veil of Blades", "stance veil of blades") 
          setNextAvailableLabelExhaust(StatTable.UnendTimer, StatTable.UnendExhaust, "Unending", "Unending Dance", "stance unending dance") 
        end
        if StatTable.IronVeil then setNextAvailableLabel(StatTable.IronVeil, "Iron Veil", "Iron Veil", "") end
        
      elseif(MyClass == "Cleric") then
        setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
        setNextAvailableLabel(StatTable.SavingGrace, "Saving", "Saving Grace", "cast 'saving grace'")
       
       
        setNextAvailableLabel(StatTable.ArtificerBlessing, "Art Bless", "Art Bless", "cast 'artificer blessing'")
        setNextAvailableLabel(StatTable.Discordia, "Discordia", "Discordia", "cast 'discordia'")
        setNextAvailableLabel(StatTable.DivineAdjutant, "Divine Adj.", "Divine Adj.", "cast 'divine adjutant'")
        setNextAvailableLabel(StatTable.DivineGrace, "Divine Grace", "Divine Grace", "cast 'divine grace'")
        setNextAvailableLabel(StatTable.GloriousConquest, "Glorious", "Glorious Conquest", "cast 'glorious conquest'")
        setNextAvailableLabel(StatTable.GrimHarvest, "Grim Harvest", "Grim Harvest", "cast 'grim harvest'")
        setNextAvailableLabel(StatTable.HallowedNimbus, "Hall. Nimbus", "Hall. Nimbus", "cast 'hallowed nimbus'")
        setNextAvailableLabel(StatTable.ProtectiveVigil, "Prot Vigil", "Prot. Vigil", "cast 'protective vigil'")
        setNextAvailableLabel(StatTable.SylvanBenediction, "Sylvan Benedict.", "Sylvan Benedict.", "cast 'sylvan benediction'")
        setNextAvailableLabel(StatTable.UnholyRampage, "Unholy Rampage", "Unholy Rampage", "cast 'unholy rampage'")
     
        
      elseif MyClass == "Druid" then
        setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
        setNextAvailableLabel(StatTable.SavingGrace, "Saving", "Saving Grace", "cast 'saving grace'")
        
      elseif MyClass == "Vizier" then
        setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
        setNextAvailableLabel(StatTable.SavingGrace, "Saving", "Saving Grace", "cast 'saving grace'")
        
        
        setNextAvailableLabel(GlobalVar.VizFinalRites and "On" or nil, "Final Rites", "Final Rites", "cast 'final rites'")
        if MyLevel == 125 and MySubLevel >= 100 then
          setNextAvailableLabel(GlobalVar.VizSoulShackle and "On" or nil, "Soul Shackle", "Soul Shackle", "stance soul'" .. getCommandSeparator() .. "cast 'soul shackle'") 
        end
        
      elseif(MyClass == "Priest") then
        setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
        setNextAvailableLabel(StatTable.SavingGrace, "Saving", "Saving Grace", "cast 'saving grace'")
        setNextAvailableLabelExhaust(StatTable.Intervention, StatTable.InterventionExhaust, "Interv.", "Intervention", "cast intervention") 
        setNextAvailableLabelExhaust(StatTable.Solitude, StatTable.SolitudeTimer, "Solitude", "Solitude", "cast solitude")  
        
      elseif(MyClass == "Monk") then
        setNextAvailableLabelExhaust(StatTable.BearStance, StatTable.BearStanceExhaust, "Bear Stance", "Bear", "stance bear")
        setNextAvailableLabelExhaust(StatTable.EmuStance, StatTable.EmuStanceExhaust, "Emu Stance", "Emu", "stance emu")
        setNextAvailableLabelExhaust(StatTable.TigerStance, StatTable.TigerStanceExhaust, "Tiger Stance", "Tiger", "stance tiger")
        setNextAvailableLabel(StatTable.DaggerHand, "Dagger", "Dagger Hand", "cast 'dagger hand'")
        setNextAvailableLabel(StatTable.StoneFist, "Stone Fist", "Stone Fist", "cast 'stone fist'")
        if MyLevel == 125 then
          setNextAvailableLabel(StatTable.BlindDevotion, "Blind Dev.", "Blind Devotation", "cast 'blind devotion'")
          setNextAvailableLabel(StatTable.Consummation, "Consummation", "Consummation", "cast consummation")
          setNextAvailableLabelExhaust(StatTable.FlowLikeWater, StatTable.FlowLikeWaterExhaust, "Flow", "Flow", "cast 'flow like water'")
        end
        
      elseif(MyClass == "Shadowfist") then        
        setNextAvailableLabelExhaust(StatTable.EmuStance, StatTable.EmuStanceExhaust, "Emu", "Emu Stance", "stance emu")
        setNextAvailableLabelExhaust(StatTable.TigerStance, StatTable.TigerStanceExhaust, "Tiger", "Tiger Stance", "stance tiger")
        setNextAvailableLabelExhaust(StatTable.VampireFang, StatTable.VampireFangExhaust, "Vampire", "Vampire Fang", "stance vampire")
        setNextAvailableLabelExhaust(StatTable.SpectralFang, StatTable.SpectralFangExhaust, "Spectral", "Spectral Fang", "stance spectral")
        setNextAvailableLabel(StatTable.DaggerHand, "Dagger", "Dagger Hand", "cast 'dagger hand'")
        setNextAvailableLabel(StatTable.StoneFist, "Stone Fist", "Stone Fist", "cast 'stone fist'")
        if MyLevel == 125 then setNextAvailableLabel(StatTable.Consummation, "Consummation", "Consummation", "cast consummation") end
      
      
      elseif(MyClass == "Warrior") then
        setNextAvailableLabelExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "Protective", "Protective", "stance protective")
        setNextAvailableLabelExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "Surefoot", "Surefoot", "stance surefoot")
        setNextAvailableLabelExhaust(StatTable.StanceRelentless, StatTable.StanceRelentlessExhaust, "Relentless", "Relentless", "stance relentless")
      
      elseif(MyClass == "Ripper") then
        KillLabel5:echo("<left>Pounce</left>")
        KillLabel5:setClickCallback("AutoKillFunc", "pounce")
        setNextAvailableLabelExhaust(StatTable.Tear, StatTable.TearExhaust, "Tear", "Tear", "tear corpse") 
        setNextAvailableLabelExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "Protective", "Protective", "stance protective")
        setNextAvailableLabelExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "Surefoot", "Surefoot", "stance surefoot")
        setNextAvailableLabelExhaust(StatTable.StanceRelentless, StatTable.StanceRelentlessExhaust, "Relentless", "Relentless", "stance relentless")
        
      elseif(MyClass == "Bodyguard") then
        setNextAvailableLabelExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "Protective", "Protective", "stance protective")
        setNextAvailableLabelExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "Surefoot", "Surefoot", "stance surefoot")
        setNextAvailableLabelExhaust(StatTable.StanceRelentless, StatTable.StanceRelentlessExhaust, "Relentless", "Relentless", "stance relentless")
        setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
      
      
      elseif(MyClass == "Paladin") then
        setNextAvailableLabelExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "Protective", "Protective", "stance protective")
        setNextAvailableLabelExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "Surefoot", "Surefoot", "stance surefoot")
        setNextAvailableLabelExhaust(StatTable.StanceRelentless, StatTable.StanceRelentlessExhaust, "Relentless", "Relentless", "stance relentless")
        setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
        setNextAvailableLabel(StatTable.SavingGrace, "Saving", "Saving Grace", "cast 'saving grace'")
        setNextAvailableLabel(StatTable.Oath, "Oath", "No Oath", "")
        setNextAvailableLabel(StatTable.Prayer, "Prayer", "No Prayer", GlobalVar.PrayerName and "cast prayer" .. GlobalVar.PrayerName or "")
        -- TODO BOON CODE
        if StatTable.JoinedBoon then
          setNextAvailableLabel(StatTable.JoinedBoon, "Joined", "Joined", "")
        elseif StatTable.SharedBoon then
          setNextAvailableLabel(StatTable.SharedBoon, "Shared", "Shared", "")
        elseif StatTable.HeroicBoon then
          setNextAvailableLabel(StatTable.HeroicBoon, "Heroic", "Heroic", "")
        elseif StatTable.ValorousBoon then
          setNextAvailableLabel(StatTable.ValorousBoon, "Valorous", "Valorous", "")
        elseif StatTable.FinalBoon then
          setNextAvailableLabel(StatTable.JoinedBoon, "Final", "Final", "")
        else
          setNextAvailableLabel(nil, "", "No Boon", "")
        end
        setNextAvailableLabel(StatTable.HolyZeal, "Holy Zeal", "Holy Zeal", "cast 'holy zeal'")
      
      
      elseif(MyClass == "Berserker") then
        setNextAvailableLabel(StatTable.Rally, "Rally", "Rally", "rally")
        
        
      elseif (StatTable.Class == "Psionicist") then
        setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
        setNextAvailableLabelExhaust(StatTable.KineticChain, StatTable.KineticChainExhaust, "Kin Chain", "Kinetic Chain", "cast 'kinetic chain'") 
        setNextAvailableLabel(StatTable.FuryOfTheMind, "Fury", "Fury Of The Mind", "cast 'fury of the mind'")
        setNextAvailableLabel(StatTable.MindsEye, "Minds Eye", "Minds Eye", "cast 'minds eye'")
        setNextAvailableLabel(StatTable.Orbit, "Orbit", "Orbit", "")
        
        if MyLevel == 125 and MySubLevel >= 200 then
          setNextAvailableLabel(StatTable.Gravitas, "Gravitas", "Gravitas", "cast 'gravitas'")
        end
        setNextAvailableLabelIfActive(StatTable.StunningWeapon, "Stun Wpn", "Stun Wpn", "cast 'stunning weapon'")
        setNextAvailableLabelIfActive(StatTable.DistractingWeapon, "Distract Wpn", "Distract Wpn", "cast 'distracting weapon'")
        setNextAvailableLabelIfActive(StatTable.DisablingWeapon, "Disable Wpn", "Disable Wpn", "cast 'disabling weapon'")
        setNextAvailableLabelIfActive(StatTable.RestrictingWeapon, "Rest Wpn", "Restrict Wpn", "cast 'restricting weapon'")
        setNextAvailableLabelIfActive(StatTable.FellingWeapon, "Fell Wpn", "Fell Wpn", "cast 'felling weapon'")
        setNextAvailableLabelIfActive(StatTable.ConsciousWeapon, "Consc Wpn", "Conscious Wpn", "cast 'conscious weapon'")
        setNextAvailableLabelIfActive(StatTable.IntelligentWeapon, "Intell Wpn", "Intell Wpn", "cast 'intelligent weapon'")
        setNextAvailableLabelIfActive(StatTable.EmpathicResonance, "Emp. Res.", "Emp. Res.", "")
      elseif (StatTable.Class == "Mindbender") then
        setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
        setNextAvailableLabel(StatTable.MindsEye, "Minds Eye", "Minds Eye", "cast 'minds eye'")
        setNextAvailableLabel(StatTable.HiveMind, "Hive Mind", "Hive Mind", "cast 'hive mind'")
        setNextAvailableLabel(StatTable.EmpathicResonance, "Emp. Res.", "Emp. Res.", "cast 'empathic resonance'")
        if StatTable.PsyphonExhaust then setNextAvailableLabelDebuff(StatTable.PsyphonExhaust, "Psyphon") end

      end -- end of MyClass
      
      -- Start of MyRace code
      
      if ArrayHasValue(StaticVars.DarkRaces, MyRace) then
        setNextAvailableLabel(StatTable.DarkEmbrace, "Dark Embrace", "Dark Embrace", "cast 'dark embrace'")
      end
      
      
      if MyRace == "Troll" then
        setNextAvailableLabelExhaust(StatTable.RacialRevival, StatTable.RacialRevivalFatigue, "Revival", "Revival", "racial revival")
      elseif (MyRace == "Ignatur") then
        setNextAvailableLabelExhaust(StatTable.RacialFireaura, StatTable.RacialFireauraFatigue, "Fire Aura", "Fire Aura", "racial fireaura")
        setNextAvailableLabelExhaust(StatTable.RacialInnervate, StatTable.RacialInnervateFatigue, "Innervate (" .. (StatTable.RacialInnervateRegen or 0) .. "%)", "Innervate", "racial innervate")
        
        
      elseif (MyRace == "Golem") then
        setNextAvailableLabelExhaust(StatTable.RacialGalvanize, StatTable.RacialGalvanizeFatigue, "Galvanize", "Galvanize", "racial galvanize")
      elseif (MyRace == "Dragon") then
        setNextAvailableLabelExhaust(nil, StatTable.RacialRoarFatigue, "Roar", "Roar", "racial roar")
      end -- end of MyRace
      
      -- Labels to only show when they affect you
      
      if StatTable.Intervention and MyClass ~= "Priest" then
        setNextAvailableLabel(StatTable.Intervention, "Interv.", "Intervention", "")
      end
      
      if StatTable.Solitude  and MyClass ~= "Priest" then
        setNextAvailableLabel(StatTable.Solitude, "Solitude", "Solituden", "")
      end  
      
      if StatTable.Regeneration then
        setNextAvailableLabel(StatTable.Regeneration, "Regen", "Regen", "cast regeneration")
      end
      
      
      if MyClass ~= "Cleric" and StatTable.ArtificerBlessingAura then setNextAvailableLabel(StatTable.ArtificerBlessingAura, "Art Bless Aura", "Art Bless Aura", "") end
      

      -- Misc buffs
      if StatTable.HandOfGod then setNextAvailableLabel(StatTable.HandOfGod, "HOG!!!", "HOG!!!", "") end
      if StatTable.Endurance then setNextAvailableLabel(StatTable.Endurance, "Endur.", "Endurance", "cast endurance") end
      
      -- Racial fatigues

      if StatTable.RacialBreathFatigue then setNextAvailableLabelDebuff(StatTable.RacialBreathFatigue, "Breath") end

      -- Debuffs
      local function debuff_label(debuff)
        if StatTable[debuff] then setNextAvailableLabelDebuff(StatTable[debuff], debuff) end
      end
      
      local Debuffs = {"Calm", "Blindness", "Heartbane", "Fear", "Poison", "Curse", "Demonfire", "Virus", 
      "Biotoxin", "Venom", "Toxin", "DoomToxin", "Flash", "Weaken", "Overconfidence", "Scramble", "Panic", "FaerieFire", "Plague",
      "Unrest", "WaterBreathingExhaust", "GiantStrengthExhaust", "FlyExhaust", "CureLightExhaust"}
      
      for _, debuff in ipairs(Debuffs) do
        debuff_label(debuff)
      end
      
      if StatTable.DoomToxin then
        if IsMDAY() then TryAction("gtell |BR|doom toxin!|N|", 60); TryAction("gtell panacea", 60)
        else TryAction("emote is afflicted with |BR|DOOM TOXIN|N|!", 60) end
      end      
      

end