-- Script: Layout Update
-- Attribute: isActive

-- Script Code:
-------------------------------------------------
-- Character Panel /Affects Update Script   
-- Updates all the gauges / labels in the bottom panel as well as the affects panel
-------------------------------------------------

VagoGUI = VagoGUI or {}
VagoGUI.LastUpdated = VagoGUI.LastUpdated or {}
VagoGUI.PendingTimer = VagoGUI.PendingTimer or {}
VagoGUI.PendingDue = VagoGUI.PendingDue or {}
VagoGUI.PendingFunc = VagoGUI.PendingFunc or {}
VagoGUI.NextDynamicLabelIndex = VagoGUI.NextDynamicLabelIndex or nil

function VagoGUI.HasFocus()
  if type(hasFocus) ~= "function" then return true end

  return hasFocus()
end

function VagoGUI.GetUpdateDelay(kind)
  local hasProfileFocus = VagoGUI.HasFocus()

  if type(IsMDAY) == "function" and IsMDAY() and not hasProfileFocus then
    if kind == "group" then
      return GlobalVar.MDAYUnfocusedGroupGUIUpdateInterval or 10
    end

    return GlobalVar.MDAYUnfocusedGUIUpdateInterval or 5
  end

  if not hasProfileFocus then
    return GlobalVar.UnfocusedGUIUpdateInterval or 1
  end

  return GlobalVar.FocusedGUIUpdateInterval or 0.2
end

function VagoGUI.Schedule(kind, func)
  if type(func) ~= "function" then return false end

  local now = os.clock()
  local delay = VagoGUI.GetUpdateDelay(kind)
  local lastUpdated = VagoGUI.LastUpdated[kind]
  local elapsed = lastUpdated and (now - lastUpdated) or delay

  VagoGUI.PendingFunc[kind] = func

  if delay <= 0 or elapsed >= delay then
    if VagoGUI.PendingTimer[kind] then
      killTimer(VagoGUI.PendingTimer[kind])
      VagoGUI.PendingTimer[kind] = nil
      VagoGUI.PendingDue[kind] = nil
    end

    VagoGUI.PendingFunc[kind] = nil
    VagoGUI.LastUpdated[kind] = now
    func()
    return true
  end

  local wait = delay - elapsed
  local due = now + wait

  if VagoGUI.PendingTimer[kind] and VagoGUI.PendingDue[kind] and VagoGUI.PendingDue[kind] <= due + 0.01 then
    return false
  end

  if VagoGUI.PendingTimer[kind] then
    killTimer(VagoGUI.PendingTimer[kind])
  end

  VagoGUI.PendingDue[kind] = due
  VagoGUI.PendingTimer[kind] = tempTimer(wait, function()
    local pendingFunc = VagoGUI.PendingFunc[kind]

    VagoGUI.PendingTimer[kind] = nil
    VagoGUI.PendingDue[kind] = nil
    VagoGUI.PendingFunc[kind] = nil
    VagoGUI.LastUpdated[kind] = os.clock()

    if pendingFunc then pendingFunc() end
  end)

  return false
end

function ScheduleUpdateGUI()
  if not GlobalVar.GUI then return false end

  return VagoGUI.Schedule("main", UpdateGUI)
end

function VagoGUI.Echo(label, text)
  if not label then return end

  text = text or ""
  if label._vagoText == text then return end

  label._vagoText = text
  label:echo(text)
end

function VagoGUI.SetStyle(label, style)
  if not label or not style then return end
  if label._vagoStyle == style then return end

  label._vagoStyle = style
  label:setStyleSheet(style)
end

function VagoGUI.SetClick(label, key, callback, ...)
  if not label then return end

  key = key or ""
  if label._vagoClick == key then return end

  label._vagoClick = key
  if callback == nil then
    label:setClickCallback("")
  else
    label:setClickCallback(callback, ...)
  end
end

function VagoGUI.SetGauge(gauge, current, maximum, text)
  if not gauge then return end

  local key = tostring(current) .. "|" .. tostring(maximum) .. "|" .. tostring(text or "")
  if gauge._vagoValue == key then return end

  gauge._vagoValue = key
  gauge:setValue(current, maximum, text)
end

function VagoGUI.Show(widget)
  if not widget then return end
  if widget._vagoVisible == true then return end

  widget._vagoVisible = true
  widget:show()
end

function VagoGUI.Hide(widget)
  if not widget then return end
  if widget._vagoVisible == false then return end

  widget._vagoVisible = false
  widget:hide()
end

function VagoGUI.BeginDynamicLabels()
  VagoGUI.NextDynamicLabelIndex = 1
end

function VagoGUI.NextDynamicLabel()
  if not Layout or not Layout.Labels or not VagoGUI.NextDynamicLabelIndex then return nil end

  local label = Layout.Labels[VagoGUI.NextDynamicLabelIndex]
  VagoGUI.NextDynamicLabelIndex = VagoGUI.NextDynamicLabelIndex + 1
  return label
end

function VagoGUI.EndDynamicLabels()
  if not Layout or not Layout.Labels or not VagoGUI.NextDynamicLabelIndex then return end

  for i = VagoGUI.NextDynamicLabelIndex, #Layout.Labels do
    VagoGUI.Hide(Layout.Labels[i])
  end

  VagoGUI.NextDynamicLabelIndex = nil
end

function applyLabelStyle(label, borderColor, bgColor)
  VagoGUI.SetStyle(label, [[
      border-width: 1px;
      border-style: solid;
      border-color: ]] .. borderColor .. [[;
      background-color: ]] .. bgColor .. [[;
      border-radius: 3px;
  ]])
end

function setLabelProperties(label, affect, activeText, missingText, skillCommand)
  if not affect then
      VagoGUI.Echo(label, "<center>" .. missingText .. "</center>")
      applyLabelStyle(label, "yellow", "rgba(255, 0, 0, 0.5)")
      VagoGUI.SetClick(label, "send:" .. tostring(skillCommand), function() send(skillCommand) end)
  else
      VagoGUI.Echo(label, "<center>" .. activeText .. " - " .. affect .. "</center>")
      applyLabelStyle(label, "green", "green")
      VagoGUI.SetClick(label, "")
  end
end

function setLabelPropertiesExhaust(label, affect, affectExhaust, activeText, missingText, skillCommand)
  if not affect and not affectExhaust then
      VagoGUI.Echo(label, "<center>" .. missingText .. "</center>")
      applyLabelStyle(label, "yellow", "rgba(255, 0, 0, 0.5)")
      VagoGUI.SetClick(label, "send:" .. tostring(skillCommand), function() send(skillCommand) end)
  elseif not affect and affectExhaust then
      VagoGUI.Echo(label, "<center>" .. activeText .. " - " .. affectExhaust .. "</center>")
      applyLabelStyle(label, "yellow", "rgba(255, 255, 0, 0.5)")
      VagoGUI.SetClick(label, "send:" .. tostring(skillCommand), function() send(skillCommand) end)
  else
      VagoGUI.Echo(label, "<center>" .. activeText .. " - " .. affect .. "</center>")
      applyLabelStyle(label, "green", "green")
      VagoGUI.SetClick(label, "")
  end
end

function setLabelPropertiesDebuff(label, affect, activeText)
  if affect then
      VagoGUI.Echo(label, "<center>" .. activeText .. " - " .. affect .. "</center>")
      applyLabelStyle(label, "gray", "gray")
      VagoGUI.SetClick(label, "")
  end
end

function setNextAvailableLabel(...)
local label = VagoGUI.NextDynamicLabel()
if label then
    setLabelProperties(label, ...)
    VagoGUI.Show(label)
end
end

function setNextAvailableLabelIfActive(Stat, labelShort, labelLong, command)
  if Stat then
      setNextAvailableLabel(Stat, labelShort, labelLong, command)
  end
end

function setNextAvailableLabelExhaust(...)
local label = VagoGUI.NextDynamicLabel()
if label then
    setLabelPropertiesExhaust(label, ...)
    VagoGUI.Show(label)
end
end

function setNextAvailableLabelDebuff(...)
local label = VagoGUI.NextDynamicLabel()
if label then
    setLabelPropertiesDebuff(label, ...)
    VagoGUI.Show(label)
end
end

function setNextAvailableAura(baseSpell, auraSpell, shortLabel, longLabel, command)
  --if baseSpell or auraSpell then
    setNextAvailableLabel(baseSpell or auraSpell, shortLabel, longLabel, command)
  --end
end

function setNextAvailableLabelIfActiveFury(Stat, labelShort, labelLong, command)
  if Stat then
    local label = VagoGUI.NextDynamicLabel()
    if label then
        -- Custom Fury look
        VagoGUI.Echo(label, "<center>" .. labelLong .. " - " .. Stat .. "</center>")
        applyLabelStyle(label, "orange", "rgba(255, 165, 0, 0.85)")
        VagoGUI.SetClick(label, "")
        VagoGUI.Show(label)
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
    VagoGUI.Echo(CharNameLabel, "<center>" .. string.upper(StatTable.CharName) .. "</center>")
    VagoGUI.Echo(CharInfoLabel, "<center>" .. string.upper(MyRace) .." " .. string.upper(MyClass) .. "</center>")
    if (MyLevel < 51) then
      VagoGUI.Echo(CharLevelLabel, "<center>Level: " .. MyLevel .. "</center>")
    elseif (MyLevel == 51) then
      VagoGUI.Echo(CharLevelLabel, "<center>Hero: " .. MySubLevel .. "</center>")
    elseif (MyLevel == 125) then
      VagoGUI.Echo(CharLevelLabel, "<center>Lord: " .. MySubLevel .. "</center>")
    else
      VagoGUI.Echo(CharLevelLabel, "<center>Level:(" .. MyLevel ..") " .. MySubLevel .. "</center>")
    end
    VagoGUI.Echo(CharHitDamLabel, "<center>HR: " .. StatTable.HitRoll .."      DR: " .. StatTable.DamRoll .. "</center>")
    VagoGUI.Echo(CharACLabel, "<center>AC: " .. StatTable.ArmorClass .."</center>")
    
    VagoGUI.Echo(RunXPLabel, "<center>" .. RunStats.RunXp .. " XP</center>")
    VagoGUI.Echo(RunKillsLabel, "<center>" .. RunStats.RunKills .. " Kills</center>")
    VagoGUI.Echo(RunLevelsLabel, "<center>" .. RunStats.RunLevels .. " Levels</center>")
    VagoGUI.Echo(RunStatsLabel, "<center>" .. RunStats.RunHP .. "HP / " .. RunStats.RunMP .. "MA</center>" )
    
    VagoGUI.SetGauge(MainHPBar, StatTable.current_health,StatTable.max_health,"<h3><b><center>".. StatTable.current_health .. "/" .. StatTable.max_health .. "  HP</b></center></h3>")
    VagoGUI.SetGauge(MainMPBar, StatTable.current_mana,StatTable.max_mana,"<h3><b><center>".. StatTable.current_mana .. "/" .. StatTable.max_mana .. "  Mana</b></center></h3>")
    VagoGUI.SetGauge(MoveBar, StatTable.current_moves,StatTable.max_moves,"<h3><b><center>".. StatTable.current_moves .. "/" .. StatTable.max_moves .. "  Moves</b></center></h3>")
    VagoGUI.SetGauge(TNLBar, math.min(StatTable.current_tnl, StatTable.max_tnl), StatTable.max_tnl, "<h3><b><span style='color: black'><center>" .. StatTable.current_tnl .. "/" .. StatTable.max_tnl .. "  TNL</b></center></h3>")
    
    
    
    if (StatTable.current_mon == nil or StatTable.current_mon == "" or StatTable.current_mon == null or StatTable.Monitor == nil) then
        VagoGUI.SetGauge(MonitorBar, 1,1,"<h3><b><center> NO MONITOR</b></center></h2>")
    else
        VagoGUI.SetGauge(MonitorBar, StatTable.current_mon,StatTable.max_mon,"<h3><b><center>".. RemoveColourCodes(StatTable.Monitor) .. ":" .. StatTable.current_mon .. "/" .. StatTable.max_mon .. "  HP</b></center></h3>")
    end
    
    if not(StatTable.Enemy == nil or StatTable.Enemy == "") then 
        VagoGUI.SetGauge(EnemyBar, StatTable.EnemyHP,StatTable.EnemyMaxHP,"<b><center>Fighting: " .. RemoveColourCodes(StatTable.Enemy) ..  " LV:" .. gmcp.Char.Status.opponent_level .. "</b></center>")
    else
        VagoGUI.SetGauge(EnemyBar, 0,100,"<h3><b><center> NO TARGET</b></center></h3>")
    end
    
    -- Item and Weight and Aligment
    VagoGUI.SetGauge(WeightBar, math.min(StatTable.Weight, StatTable.MaxWeight), StatTable.MaxWeight, "<h3><b><center>" .. StatTable.Weight .. "/" .. StatTable.MaxWeight .. "  lbs</b></center></h3>")
    VagoGUI.SetGauge(ItemsBar, StatTable.Items,StatTable.MaxItems,"<h3><b><center>".. StatTable.Items .. "/" .. StatTable.MaxItems .. "  items</b></center></h3>")
    VagoGUI.SetGauge(AlignmentBar, (StatTable.Alignment + 1000),2000,"<h3><b><center> Align: " .. StatTable.Alignment .. "</b></center></h3>")
    
    -- Lag / Qi / Savespell
    VagoGUI.Echo(LagLabel, "<center>lag: " .. tonumber(gmcp.Char.Vitals.lag) .. "</center>")
    
    if IsClass({"Monk", "Shadowfist"}) then
      VagoGUI.Show(QiLabel)
      applyLabelStyle(QiLabel, "green", "green")
      VagoGUI.Echo(QiLabel, "<center>" .. StatTable.InnerQi .. " / " .. StatTable.OuterQi .. "</center>")
    elseif StatTable.Class == "Bladedancer" then
      VagoGUI.Show(QiLabel)
      if StatTable.BladetranceLevel > 0 then
        applyLabelStyle(QiLabel, "green", "green")
        VagoGUI.Echo(QiLabel, "<center>BT " .. StatTable.BladetranceLevel .. "</center>")
      else
        applyLabelStyle(QiLabel, "yellow", "rgba(255, 0, 0, 0.5)")   
        VagoGUI.Echo(QiLabel, "<center>BT off</center>")
      end
    elseif IsClass({"Priest", "Cleric", "Druid", "Paladin"}) then
      VagoGUI.Show(QiLabel)
      if GlobalVar.AutoHeal then
        applyLabelStyle(QiLabel, "green", "green")
        VagoGUI.Echo(QiLabel, "<center>AH ON</center>")
      else
        applyLabelStyle(QiLabel, "yellow", "rgba(255, 0, 0, 0.5)")   
        VagoGUI.Echo(QiLabel, "<center>AH off</center>")
      end
    else
      VagoGUI.Hide(QiLabel)
    end


    if StatTable.Savespell then
      if StatTable.current_health == StatTable.max_health
      and StatTable.max_mana == StatTable.current_mana
      and StatTable.current_moves >= StatTable.max_moves * 0.8
      and StatTable.current_moves <= StatTable.max_moves then
        VagoGUI.Echo(SavespellLabel, "<center>S/S Active</center>")
        applyLabelStyle(SavespellLabel, "green", "green")
      else
        VagoGUI.Echo(SavespellLabel, "<center>S/S ON</center>")
        applyLabelStyle(SavespellLabel, "yellow", "rgba(255, 0, 0, 0.5)")
      end
      VagoGUI.SetClick(SavespellLabel, "config -savespell", [[UseSkill("config -savespell")]])
    else
        VagoGUI.Echo(SavespellLabel, "<center>S/S OFF</center>")
        applyLabelStyle(SavespellLabel, "yellow", "rgba(255, 0, 0, 0.5)")
        VagoGUI.SetClick(SavespellLabel, "config +savespell", [[UseSkill("config +savespell")]])
    end
    
    -- Skills/spells that apply to all (Rows 1 - 5)
    setLabelProperties(MoveSneakLabel.left, StatTable.MoveHidden, "Move", "Move", "move hidden")
    setLabelProperties(MoveSneakLabel.right, StatTable.Sneak, "Sneak", "Sneak", "sneak")
    setLabelProperties(DetectsLabel, StatTable.HolySight, "Detects", "Detects", "cast 'holy sight'")
    setLabelProperties(InvisLabel, StatTable.Invis, "Invis", "Visible", "cast invis")
    setLabelProperties(SancLabel, StatTable.Sanctuary, "Sanc", "Sanctuary", "cast sanctuary")
    setLabelProperties(WaterFlyLabel.left, StatTable.WaterBreathing, "W", "Water", "cast 'water breathing'")
    setLabelProperties(WaterFlyLabel.right, StatTable.Fly, "Fly", "Fly", "cast fly")
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
    setLabelProperties(ConcentrateLabel, StatTable.Concentrate, "Concen", "Concentrate", "cast concentrate")
    setLabelProperties(WerreLabel, StatTable.Werrebocler, "Bocler", "Werrebocler", "cast werrebocler")
    
    -- Custom labels for classes / races (rows 6+)
    
    VagoGUI.BeginDynamicLabels()
    
    if MyClass == "Mage" then
      setNextAvailableLabel(StatTable.Savvy, "Savvy", "Savvy", "cast savvy")
      setNextAvailableLabel(StatTable.Mystical, "Mystical", "Mystical", "cast mystical")
      
      -- High Magik
      if MyLevel == 125 then
        setNextAvailableAura(StatTable.Attenuation, StatTable.AttenuationAura, "Atten", "Attenuation", "cast attenuation")
        setNextAvailableAura(StatTable.PlanarModulation, StatTable.PlanarModulationAura, "PlanarMod", "Planar Modulation", "cast 'planar modulation'")
        setNextAvailableAura(StatTable.ArcanaHarvesting, StatTable.ArcanaHarvestingAura, "Arcana Harv", "Arcana Harvesting", "cast 'arcana harvesting'")
        setNextAvailableAura(StatTable.AntimagicFeedback, StatTable.AntimagicFeedbackAura, "Antimagic", "Antimagic Feedback", "cast 'antimagic feedback'")
        setNextAvailableAura(StatTable.Brittle, StatTable.BrittleAura, "Brittle", "Brittle", "cast brittle")
        setNextAvailableAura(StatTable.SympatheticResonance, StatTable.SympatheticResonanceAura, "Sympath", "Sympathetic Resonance", "cast 'sympathetic resonance'")
      end
      
      
      
      
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
      setNextAvailableLabelIfActive(StatTable.Thunderhead, "Thunderhead", "Thunderhead", nil)
      setNextAvailableLabelIfActive(StatTable.Blizzard, "Blizzard", "Blizzard", nil)
      if MyLevel == 125 or (MyLevel == 51 and (MySubLevel or 0) >= 675) then
        setNextAvailableLabelIfActive(StatTable.StratumGale, "Gale", "Gale Stratum", "cast stratum gale")
        setNextAvailableLabelIfActive(StatTable.StratumSleet, "Sleet", "Sleet Stratum", "cast stratum sleet")
        setNextAvailableLabelIfActive(StatTable.StratumSpringRain, "SpringRain", "Spring Rain Stratum", "cast stratum spring rain")
        setNextAvailableLabelIfActive(StatTable.StratumCloudburst, "Cloudburst", "Cloudburst Stratum", "cast stratum cloudburst")
        setNextAvailableLabelIfActive(StatTable.StratumHailStorm, "HailStorm", "Hail Storm Stratum", "cast stratum hail storm")
      end
      if MyLevel == 125 then
        setNextAvailableLabelIfActive(StatTable.StratumThunderhead, "Thunderhead", "Thunderhead Stratum", "cast stratum thunderhead")
        setNextAvailableLabelIfActive(StatTable.StratumBlizzard, "Blizzard", "Blizzard Stratum", "cast stratum blizzard")
      end
      
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
      
    elseif MyClass == "Black Circle Initiate" then
      setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
      setNextAvailableLabel(StatTable.Nightcloak, "Nightcloak", "Nightcloak", "cast 'nightcloak'")
      setNextAvailableLabelExhaust(StatTable.SenseWeakness, StatTable.SenseWeaknessExhaust, "Sense", "Sense Weakness", "cast 'sense weakness'")
      setNextAvailableLabelExhaust(nil, StatTable.QuickcastExhaust, "Quickcast", "Quickcast", nil) 
      if MyLevel == 125 then
        setNextAvailableLabelExhaust(StatTable.KahbyssInsight, StatTable.KahbyssInsightExhaust, "Kahbyss", "Kahbyss Insight", "cast 'kahbyss insight'")
      end
    
    elseif MyClass == "Assassin" then
      setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
      
    elseif MyClass == "Soldier" then
      if (MyLevel == 125 or MySubLevel > 100) then
        setNextAvailableLabelExhaust(StatTable.StanceEchelon, StatTable.EchelonExhaust, "Echelon", "Echelon", "stance echelon")
        setNextAvailableLabelExhaust(StatTable.StanceSquare, StatTable.SquareExhaust, "Square", "Square", "stance square") 
        setNextAvailableLabelExhaust(StatTable.StancePhalanx, StatTable.PhalanxExhaust, "Phalanx", "Phalanx", "stance phalanx") 
        setNextAvailableLabelExhaust(StatTable.StanceColumn, StatTable.ColumnExhaust, "Column", "Column", "stance column") 
      end
    
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
      
      -- Pantheon spells with auras
      setNextAvailableAura(StatTable.ArtificerBlessing, StatTable.ArtificerBlessingAura, "Art Bless", "Art Bless", "cast 'artificer blessing'")
      setNextAvailableAura(StatTable.Discordia, StatTable.DiscordiaAura, "Discordia", "Discordia", "cast 'discordia'")
      setNextAvailableAura(StatTable.GrimHarvest, StatTable.GrimHarvestAura, "Grim Harvest", "Grim Harvest", "cast 'grim harvest'")
      setNextAvailableAura(StatTable.UnholyRampage, StatTable.UnholyRampageAura, "Unholy Rampage", "Unholy Rampage", "cast 'unholy rampage'")
      setNextAvailableAura(StatTable.DivineAdjutant, StatTable.DivineAdjutantAura, "Divine Adj.", "Divine Adj.", "cast 'divine adjutant'")
      setNextAvailableAura(StatTable.HallowedNimbus, StatTable.HallowedNimbusAura, "Hall. Nimbus", "Hall. Nimbus", "cast 'hallowed nimbus'")
      setNextAvailableAura(StatTable.ProtectiveVigil, StatTable.ProtectiveVigilAura, "Prot Vigil", "Prot. Vigil", "cast 'protective vigil'")
      setNextAvailableAura(StatTable.SylvanBenediction, StatTable.SylvanBenedictionAura, "Sylvan Benedict.", "Sylvan Benedict.", "cast 'sylvan benediction'")
      
      -- Regular pantheon spells without auras
      setNextAvailableLabel(StatTable.DivineGrace, "Divine Grace", "Divine Grace", "cast 'divine grace'")
      setNextAvailableLabel(StatTable.GloriousConquest, "Glorious", "Glorious Conquest", "cast 'glorious conquest'")
  
      
   
      
    elseif MyClass == "Druid" then
      setNextAvailableLabel(StatTable.Acumen, "Acumen", "Acumen", "cast acumen")
      setNextAvailableLabel(StatTable.SavingGrace, "Saving", "Saving Grace", "cast 'saving grace'")
      setNextAvailableLabel(StatTable.SiderealReflections, "Sidereal", "Sidereal", "cast 'sidereal reflections'")
      
      
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
      VagoGUI.Echo(KillLabel5, "<left>Pounce</left>")
      VagoGUI.SetClick(KillLabel5, "AutoKillFunc:pounce", "AutoKillFunc", "pounce")
      setNextAvailableLabelExhaust(StatTable.Tear, StatTable.TearExhaust, "Tear", "Tear", "tear corpse") 
      setNextAvailableLabelExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "Protective", "Protective", "stance protective")
      setNextAvailableLabelExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "Surefoot", "Surefoot", "stance surefoot")
      setNextAvailableLabelExhaust(StatTable.StanceRelentless, StatTable.StanceRelentlessExhaust, "Relentless", "Relentless", "stance relentless")
      
    elseif(MyClass == "Bodyguard") then
      setNextAvailableLabelExhaust(StatTable.StanceProtective, StatTable.StanceProtectiveExhaust, "Protective", "Protective", "stance protective")
      setNextAvailableLabelExhaust(StatTable.StanceSurefoot, StatTable.StanceSurefootExhaust, "Surefoot", "Surefoot", "stance surefoot")
      setNextAvailableLabelExhaust(StatTable.StanceRelentless, StatTable.StanceRelentlessExhaust, "Relentless", "Relentless", "stance relentless")
      setNextAvailableLabel(StatTable.Alertness, "Alert", "Alertness", "alertness")
      setNextAvailableLabelIfActive(StatTable.Renown, "Renown", "Renown", "brag")
      setNextAvailableLabelIfActive(StatTable.Payback, "Payback", "Payback", nil)
    
    
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
      if MyLevel == 125 or (MyLevel == 51 and MySubLevel >= 500) then
        setNextAvailableLabel(StatTable.IllusoryShield, "Illusory", "Illusory Shield", "cast 'illusory shield'")
      end
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
      if MyLevel == 125 or (MyLevel == 51 and MySubLevel >= 500) then
        setNextAvailableLabel(StatTable.IllusoryShield, "Illusory", "Illusory Shield", "cast 'illusory shield'")
      end
      setNextAvailableLabel(StatTable.HiveMind, "Hive Mind", "Hive Mind", "cast 'hive mind'")
      setNextAvailableLabel(StatTable.EmpathicResonance, "Emp. Res.", "Emp. Res.", "cast 'empathic resonance'")
      setNextAvailableLabelExhaust(nil, StatTable.PsyphonExhaust, "Psyphon", "Psyphon", "cast psyphon")
    elseif StatTable.Class == "Fury" then
      setNextAvailableLabel(StatTable.Wildmind, "Wildmind", "Wildmind", "cast wildmind")
      setNextAvailableLabelIfActiveFury(StatTable.DaringFury,      "Daring Fury",      "Daring Fury",      nil)
      setNextAvailableLabelIfActiveFury(StatTable.DestructiveFury, "Destructive Fury", "Destructive Fury", nil)
      setNextAvailableLabelIfActiveFury(StatTable.ExplosiveFury,   "Explosive Fury",   "Explosive Fury",   nil)
      setNextAvailableLabelIfActiveFury(StatTable.FocusedFury,     "Focused Fury",     "Focused Fury",     nil)
      setNextAvailableLabelIfActiveFury(StatTable.ManiacalFury,    "Maniacal Fury",    "Maniacal Fury",    nil)
      setNextAvailableLabelIfActiveFury(StatTable.PsychoticFury,   "Psychotic Fury",   "Psychotic Fury",   nil)
      setNextAvailableLabelIfActiveFury(StatTable.ScathingFury,    "Scathing Fury",    "Scathing Fury",    nil)
      setNextAvailableLabelIfActiveFury(StatTable.VengefulFury,    "Vengeful Fury",    "Vengeful Fury",    nil)

    
    
    end -- end of MyClass
    
    -- Start of MyRace code
    
    if ArrayHasValue(StaticVars.DarkRaces, MyRace) then
      setNextAvailableLabel(StatTable.DarkEmbrace, "Dark Embrace", "Dark Embrace", "cast 'dark embrace'")
    end
    
    
    if MyRace == "Troll" then
      setNextAvailableLabelExhaust(StatTable.RacialRevival, StatTable.RacialRevivalFatigue, "Revival", "Revival", "racial revival")
    elseif MyRace == "Kzinti" then
      setNextAvailableLabelExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "Frenzy", "Racial Frenzy", "racial frenzy")     
    elseif MyRace == "Orc" then
      setNextAvailableLabelExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "Frenzy", "Racial Frenzy", "racial frenzy")
    elseif MyRace == "Half-Orc" then
      setNextAvailableLabelExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "Frenzy", "Racial Frenzy", "racial frenzy")
    elseif MyRace == "Griffon" then
      setNextAvailableLabelExhaust(StatTable.RacialHeraldry, StatTable.RacialHeraldryFatigue, "Heraldry", "Racial Heraldry", "racial heraldry")
    elseif MyRace == "Centaur" then
      setNextAvailableLabelExhaust(StatTable.RacialGallop, StatTable.RacialGallopFatigue, "Gallop", "Racial Gallop", "racial gallop")
    
    elseif MyRace == "Hobgoblin" then
      setNextAvailableLabelExhaust(StatTable.RacialFrenzy, StatTable.RacialFrenzyFatigue, "Frenzy", "Racial Frenzy", "racial frenzy")
      
    elseif (MyRace == "Ignatur") then
      setNextAvailableLabelExhaust(StatTable.RacialFireaura, StatTable.RacialFireauraFatigue, "Fire Aura", "Fire Aura", "racial fireaura")
      setNextAvailableLabelExhaust(StatTable.RacialPyroclasticFlow, StatTable.RacialPyroclasticFlowFatigue, "PyroFlow", "PyroFlow", "racial pyroclastic flow")
      setNextAvailableLabelExhaust(StatTable.RacialInnervate, StatTable.RacialInnervateFatigue, "Innervate (" .. (StatTable.RacialInnervateRegen or 0) .. "%)", "Innervate", "racial innervate")
      
      
      
    elseif (MyRace == "Golem") then
      setNextAvailableLabelExhaust(StatTable.RacialGalvanize, StatTable.RacialGalvanizeFatigue, "Galvanize", "Galvanize", "racial galvanize")
      
    elseif MyRace == "Firedrake" then
      setNextAvailableLabelExhaust(StatTable.RacialBreath, StatTable.RacialBreathFatigue, "Breath", "Breath", "racial breath")
    
    elseif MyRace == "Gith" then
      setNextAvailableLabelExhaust(nil, StatTable.RacialConvokeFatigue, "Convoke", "Convoke", "racial convoke")
      setNextAvailableLabelExhaust(nil, StatTable.RacialPlaneshiftFatigue, "Planeshift", "Planeshift", nil)
      
    elseif MyRace == "Illithid" then
      setNextAvailableLabelExhaust(nil, StatTable.RacialScrambleFatigue, "Scramble", "Scramble", "racial scramble")
      setNextAvailableLabel(StatTable.RacialMindFlay, "MindFlay", "MindFlay", "racial mindflay")
      setNextAvailableLabelIfActive(StatTable.RacialMentalAptitude, "Mental Apt.", nil, nil)
      
    elseif MyRace == "Tokoloshe" then
      setNextAvailableLabelExhaust(StatTable.RacialDiscorporate, StatTable.RacialDiscorporateFatigue, "Disc.", "Discorporate", "racial discorporate")
    
    elseif (MyRace == "Dragon") then
      setNextAvailableLabelExhaust(StatTable.RacialBreath, StatTable.RacialBreathFatigue, "Breath", "Breath", "racial breath full")
      setNextAvailableLabelExhaust(nil, StatTable.RacialRoarFatigue, "Roar", "Roar", "racial roar")
      setNextAvailableLabelExhaust(StatTable.RacialDevour, StatTable.RacialDevourFatigue, "Devour", "Devour", "racial devour")
     elseif (MyRace == "Black Dragon") then
      setNextAvailableLabelExhaust(StatTable.RacialBreath, StatTable.RacialBreathFatigue, "Breath", "Breath", "racial breath full")
      setNextAvailableLabelExhaust(StatTable.RacialProwl, StatTable.RacialProwlFatigue, "Prowl", "Prowl", "racial prowl")
      setNextAvailableLabelExhaust(StatTable.RacialTerror, StatTable.RacialTerrorFatigue, "Terror", "Terror", "racial terror")
     elseif (MyRace == "Blue Dragon") then
      setNextAvailableLabelExhaust(StatTable.RacialBreath, StatTable.RacialBreathFatigue, "Breath", "Breath", "racial breath full")
      setNextAvailableLabelExhaust(StatTable.RacialWaterblast, StatTable.RacialWaterblastFatigue, "Waterblast", "Waterblast", nil)
      setNextAvailableLabelExhaust(StatTable.RacialEngulf, StatTable.RacialEngulfFatigue, "Engulf", "Engulf", "racial engulf")
     elseif (MyRace == "Green Dragon") then
      setNextAvailableLabelExhaust(StatTable.RacialBreath, StatTable.RacialBreathFatigue, "Breath", "Breath", "racial breath full")
      setNextAvailableLabelExhaust(StatTable.RacialSecrete, StatTable.RacialSecreteFatigue, "Secrete", "Secrete", "racial secrete")
      setNextAvailableLabelExhaust(StatTable.RacialConstrict, StatTable.RacialConstrictFatigue, "Constrict", "Constrict", "racial constrict")
      setNextAvailableLabelExhaust(StatTable.RacialMiasma, StatTable.RacialMiasmaFatigue, "Miasma", "Miasma", "racial miasma")
     elseif (MyRace == "White Dragon") then
      setNextAvailableLabelExhaust(StatTable.RacialBreath, StatTable.RacialBreathFatigue, "Breath", "Breath", "racial breath full")  
      setNextAvailableLabelExhaust(StatTable.RacialIcemirror, StatTable.RacialIcemirrorFatigue, "Icemirror", "Icemirror", "racial icemirror")
      setNextAvailableLabelExhaust(StatTable.RacialFrigid, StatTable.RacialFrigidFatigue, "Frigid", "Frigid", "racial frigid") 
      
    end -- end of MyRace
    
    -- Labels to only show when they affect you
    
    
    -- Misc buffs      
    setNextAvailableLabelIfActive(StatTable.Regeneration, "Regen", nil, nil)
    setNextAvailableLabelIfActive(StatTable.Endurance, "Endur.", nil, nil)
    setNextAvailableLabelIfActive(StatTable.BlackGlow, "Black Glow", nil, nil)
    
    if MyRace ~= "Griffon" then
      setNextAvailableLabelIfActive(StatTable.RacialHeraldry, "Heraldry", nil, nil)
    end
    
    -- Show Cleric Auras
    if MyClass ~= "Cleric" then 
      setNextAvailableLabelIfActive(StatTable.ArtificerBlessingAura, "Art Bless Aura", nil, nil)
      setNextAvailableLabelIfActive(StatTable.DiscordiaAura, "Discordia", nil, nil)
      setNextAvailableLabelIfActive(StatTable.DivineAdjutantAura, "Divine Adj.", nil, nil)    
      setNextAvailableLabelIfActive(StatTable.GrimHarvestAura, "Grim. Harv.", nil, nil) 
      setNextAvailableLabelIfActive(StatTable.HallowedNimbusAura, "Hall. Nimb.", nil, nil)
      setNextAvailableLabelIfActive(StatTable.ProtectiveVigilAura, "Prot. Vigil", nil, nil)
      setNextAvailableLabelIfActive(StatTable.SylvanBenedictionAura, "Syl. Ben.", nil, nil)
      setNextAvailableLabelIfActive(StatTable.UnholyRampageAura, "U. Rampage", nil, nil)       
    end
    
    if MyClass ~= "Paladin" then
      setNextAvailableLabelIfActive(StatTable.MaliceAura, "Malice Aura", nil, nil)
    
    end
    
    -- Priest Spells
    if MyClass ~= "Priest" then
      setNextAvailableLabelIfActive(StatTable.Intervention, "Interv.", nil, nil) 
      setNextAvailableLabelIfActive(StatTable.Solitude, "Solitude", nil, nil)
    end
    
    -- Bld Buffs
    setNextAvailableLabelIfActive(StatTable.ThousandCuts, "Thousand Cuts", nil, nil)
    
    
    
    -- Commune / Hog!!
    if StatTable.Level >= 125 then
      setNextAvailableLabel(StatTable.Commune, "Commune", "Commune", nil)
    end
    setNextAvailableLabelIfActive(StatTable.HandOfGod, "HOG!!!", nil, "hog")
    



    
    -- Debuffs
    local function debuff_label(debuff)
      if StatTable[debuff] then setNextAvailableLabelDebuff(StatTable[debuff], debuff) end
    end
    
    local Debuffs = {"Calm", "Shun", "Blindness", "Heartbane", "Fear", "Poison", "Curse", "Demonfire", "Virus", 
    "Biotoxin", "Venom", "Toxin", "DoomToxin", "Flash", "Weaken", "Overconfidence", "Scramble", "Panic", "FaerieFire", "Plague",
    "Unrest", "WaterBreathingExhaust", "GiantStrengthExhaust", "FlyExhaust", "CureLightExhaust"}
    
    for _, debuff in ipairs(Debuffs) do
      debuff_label(debuff)
    end

    VagoGUI.EndDynamicLabels()
    

end
