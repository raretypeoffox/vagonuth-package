-- Script: Init GlobalVars
-- Attribute: isActive

-- Script Code:
-- Initialization Script
-- Sets up all the Global Vars we'll be using throughout the various modules
-- Upon loading up Mudlet / this Profile, scripts are first run from top to bottom.
-- As such, this script should always be the first (ie top) script in Mudlet


StatTable = StatTable or {}
AltList = AltList or {}
AltList.Chars = AltList.Chars or {}
GroupiesUnderAttack = GroupiesUnderAttack or {}
Init = Init or {}

--Testing
LottoCapture = LottoCapture or {}

-- Init.GlobalVars() is ran both on startup and reconnect
-- Use these to setup / reset variables
function Init.GlobalVars()
  GlobalVar = GlobalVar or {}
  GlobalVar.Saved = GlobalVar.Saved or {}

  GlobalVar.GUI = GlobalVar.GUI or true  
  
  GlobalVar.MDAY = GlobalVar.MDAY or false
  
  GlobalVar.Silent = GlobalVar.Silent or false
  GlobalVar.PerformanceMode = GlobalVar.PerformanceMode or (GlobalVar.MDAY and true or false)
  GlobalVar.Debug = GlobalVar.Debug or false
  GlobalVar.Verbose = GlobalVar.Verbose or true
  
  GlobalVar.Boons = {}
  GlobalVar.LastBoon = GlobalVar.LastBoon or nil

  GlobalVar.GroupMates = {}
  GlobalVar.MobCount = 0

  GlobalVar.AutoKill = true
  GlobalVar.KillStyle = "kill"
  GlobalVar.AutoBash = false
  GlobalVar.AutoTarget = false

  GlobalVar.LevelGear = false
  GlobalVar.LevelReady = false
  GlobalVar.AutoGurney = ""
  GlobalVar.GroupLeader = ""

  -- Archer Variables
  GlobalVar.AutoFletch = false
  GlobalVar.LastFletch = "" -- For AutoFletch fails
  GlobalVar.LastFletchTries = 0
  GlobalVar.ReloadType = nil
  GlobalVar.AutoTrack = "off"
  GlobalVar.AutoTrackTarget = ""

  -- Caster Variables
  GlobalVar.AutoCast = false
  GlobalVar.SurgeLevel = 2
  GlobalVar.AutoCaster = ""
  GlobalVar.AutoCasterAOE = ""
  GlobalVar.QuickenStatus = false
  
  -- Skill Variables
  GlobalVar.AutoSkill = false
  GlobalVar.SkillStyle = ""
  

  -- Cleric / Druid Variables
  GlobalVar.AutoHeal = false
  GlobalVar.AutoHealTarget = nil
  GlobalVar.AutoHealLowest =  true
  GlobalVar.InterventionTarget = nil
  GlobalVar.Pantheon = nil

    -- Vizier Variables
  GlobalVar.VizMonitor = ""
  GlobalVar.VizFinalRites = false
  GlobalVar.VizSoulShackle = false
  GlobalVar.NoPhleb = false
  
    -- Paladin Variables
  GlobalVar.PrayerName = ""

  -- Troll Variables
  GlobalVar.AutoRevive = false -- will switch to true on Init call so that it waits 5 seconds
  GlobalVar.AutoReviveHPpct = 0.25

  --Brandish Triggers
  GlobalVar.BrandishStaff = ""
  GlobalVar.BrandishArmor = ""
  GlobalVar.BrandishCharges = 0

  -- Variables to reset on reconnect (won't run on initial Init)
  if AR then AR.Status = false end
  if Battle then Battle.Combat = false end
  
  if Layout then
      AutoKillSetGUI()
      AutoSkillSetGUI()
      AutoBashSetGUI()
      AutoCastSetGUI()
  end
  
  GlobalVar.WelcomeTimer = GlobalVar.WelcomeTimer or nil
  --GlobalVar.LoginName = GlobalVar.LoginName or nil
end

if not GlobalVar then Init.GlobalVars() end


-- Init profile based on class
-- Since gmcp may be laggy, May need to do something like
-- Set Variable "Ready for Init"
-- When StatTable.Class populates
-- Run Class Specific Init then turn off "Ready for Init"
function Init.Profile(timeout)
    --printGameMessage("DEBUG", "Init.Profile called")
    local MAX_TIMEOUT = 5
    timeout = timeout or 0
    if type(timeout) ~= "number" then error("Init.Profile() error: shouldn't be reached"); return end
    if timeout >= MAX_TIMEOUT then pdebug("Init.Profile() timed out: likely no gmcp data"); return end
    if not Connected() then pdebug("Init.Profile() error: not connected, likely logged out quick"); return end
    

    sendGMCP("Char.Status")
    sendGMCP("Char.Vitals")
    
    if not gmcp or not gmcp.Char or not gmcp.Char.Status then
      pdebug("Init.Profile() failed: no gmcp info, trying again in 5 seconds")
      timeout = timeout + 1
      tempTimer(5, function() Init.Profile(timeout) end)
    end
    
    local MyClass = gmcp.Char.Status.class
    local MyRace = gmcp.Char.Status.race
    local MyLevel = tonumber(gmcp.Char.Status.level)
    local MySubLevel = tonumber(gmcp.Char.Status.sublevel)
    
    if not MyClass or not MyRace or not MyLevel or not MySubLevel then
      pdebug("Init.Profile() failed: no gmcp info, trying again in 5 seconds")
      timeout = timeout + 1
      tempTimer(5, function() Init.Profile(timeout) end)
    end
    
    -- Caster Variables
    GlobalVar.AutoCast = false
    GlobalVar.SurgeLevel = (MyLevel == 125 and 2 or 1)
    GlobalVar.AutoCaster = ""
    GlobalVar.AutoCasterSingle = ""
    GlobalVar.AutoCasterAOE = ""
    GlobalVar.QuickenStatus = false
    
    -- Skill Variables
    GlobalVar.AutoSkill = false
    GlobalVar.SkillStyle = ""

    -- AutoCast
    if MyClass == "Mage" then
      if MyLevel == 125 then
        GlobalVar.AutoCast = true
        if MySubLevel > 500 then
          GlobalVar.AutoCaster = "void seeker"
          GlobalVar.AutoCasterSingle = "void seeker"
          GlobalVar.AutoCasterAOE = "banshee wail" 
        else
          GlobalVar.AutoCaster = "maelstrom"
          GlobalVar.AutoCasterSingle = "maelstrom"
          GlobalVar.AutoCasterAOE = "meteor swarm"
        end
      elseif MyLevel == 51 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "disintegrate"
        GlobalVar.AutoCasterSingle = "disintegrate"
        GlobalVar.AutoCasterAOE = "acid rain"
      end
      
    elseif MyClass == "Wizard" then
      if MyLevel == 125 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "maelstrom"
        GlobalVar.AutoCasterSingle = "maelstrom"
        GlobalVar.AutoCasterAOE = "meteor swarm"
      elseif MyLevel == 51 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "disintegrate"
        GlobalVar.AutoCasterSingle = "disintegrate"
        GlobalVar.AutoCasterAOE = "acid rain"
      end
    
    elseif MyClass == "Sorcerer" then
      if MyLevel == 125 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "brimstone"
      elseif MyLevel == 51 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = MySubLevel > 100 and "torment" or "vamp"
      end

    elseif MyClass == "Stormlord" then
      if MyLevel == 125 then
        GlobalVar.AutoKill = false
        GlobalVar.AutoCast = false
        GlobalVar.AutoCaster = ""
        GlobalVar.AutoCasterAOE = ""
      elseif MyLevel == 51 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "disintegrate"
        GlobalVar.AutoCasterSingle = "disintegrate"
        GlobalVar.AutoCasterAOE = "acid rain"
      end
    elseif (MyClass == "Psionicist") then
      if MyLevel == 125 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "fandango"
        GlobalVar.SurgeLevel = 1      
      elseif MyLevel == 51 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "dancing weapon"
        GlobalVar.SurgeLevel = 1
      end
    elseif MyClass == "Mindbender" then
      if MyLevel == 125 then
        GlobalVar.AutoCast = true
        GlobalVar.AutoCaster = "mindwipe"
        GlobalVar.SurgeLevel = 2      
      elseif MyLevel == 51 then      
        GlobalVar.AutoCast = true
        GlobalVar.SurgeLevel = 1
        GlobalVar.AutoCaster = "ultrablast"    
      end
        
      
    end

    -- AutoHeal
    if (MyClass == "Cleric" or MyClass == "Druid" or MyClass == "Priest") then
      if MyLevel >= 51 then
        GlobalVar.AutoHeal = true
        GlobalVar.AutoHealLowest = true
        GlobalVar.InterventionTarget = nil
      end
    elseif MyClass == "Paladin" then
      if MyLevel == 125 then
        GlobalVar.AutoHeal = true
        GlobalVar.AutoHealTarget = StatTable.CharName
        GlobalVar.AutoHealLowest = false
      end
    
    
    end

    -- Killstyle
    if MyClass == "Rogue" or MyClass == "Black Circle Initiate"  then
      if MyLevel == 125 then GlobalVar.KillStyle = "ass"
      elseif MySubLevel > 101 then GlobalVar.KillStyle = "bs"
      elseif MyLevel >= 50 then GlobalVar.KillStyle = "murder"
      end
    elseif MyClass == "Assassin" then
      if MyLevel == 125 then GlobalVar.KillStyle = "ass"
      elseif MyLevel == 51 then GlobalVar.KillStyle = "surp"
      end
    elseif MyClass == "Bladedancer" then
      if MyLevel == 51 then GlobalVar.KillStyle = "surp"
        if StatTable.SubLevel > 101 then
          GlobalVar.SkillStyle = "vs"
          GlobalVar.AutoSkill = true
        end
      end
    elseif MyClass == "Shadowfist" then
      if MyLevel == 51 then GlobalVar.KillStyle = "surp"
        if StatTable.SubLevel > 101 then
          GlobalVar.SkillStyle = "vs"
          GlobalVar.AutoSkill = true
        end
      end
    elseif MyClass == "Black Circle Initiate" then
      if MyLevel == 125 then GlobalVar.KillStyle = "ass"
      elseif MySubLevel > 101 then GlobalVar.KillStyle = "bs"
      end
    elseif MyClass == "Priest" and MyLevel > 51 then
      GlobalVar.KillStyle = false
    end
    
    -- SkillStyle
    if MyClass == "Soldier" then
      if MyLevel == 125 then
        GlobalVar.AutoSkill = true
        GlobalVar.SkillStyle = "focus"
      end
    end

    -- Race
    if (MyRace == "Troll") then
      GlobalVar.AutoRevive = true
    end


    -- GUI Setup
    
    if (GlobalVar.GUI) then
      AutoKillSetGUI()
      AutoSkillSetGUI()
      AutoBashSetGUI()
      AutoCastSetGUI()
    end
     
    -- Raise Custom Event for others to code with
    raiseEvent("CustomProfileInit")
    

end

function Init.FirstTime()
  cecho("\n\n")
  cecho("<yellow>=======================================================\n")
  cecho("<yellow>***\t<white>Welcome to Vagonuth Package " .. VagoPackage.Version .. "\t<yellow>***\n")
  cecho("<yellow>=======================================================\n\n")
  cecho("<white>Learn the basic commands available to you by typing <yellow>cmds\n")
  cecho("<white>It's recommend you run <yellow>setup <white>with each character\n")
  cecho("<white>Adjust your GUI's font size with <yellow>fontsize <#>\n")
  cecho("<white>To auto login with a password, type <yellow>pwd <password\n")
  cecho("<white>To set your buddy chat name, type <yellow>bud-set <name> <colour>\n")
  cecho("<white>If you wish to minimize gtells, type <yellow>silent on\n")
  cecho("<white>You'll find many useful inventory management commands by typing <yellow>ihelp\n")
  cecho("<white>Learn more about autorescue by typing <yellow>ar<white>, quickstart: <yellow>ar on; ar auto\n")
  cecho("\n\n")
  cecho("<red>Note:\t<white>This package auto-updates. If you edit the code directly,\n")
  cecho("<white>\tthis will overwrite your code\n")
  cecho("<white>\tSee the README under Scripts for coding best practices\n")
end

function Init.ProfileOnLogin()
  safeTempTrigger("Init.LoginTrigger", "^(Welcome( back)? to the AVATAR System(, Hero|, Lord|, Lady)? (?<charname>\\w+).|Reconnecting.)$", 
    function() 
      tempTimer(5, function() Init.Profile() end)
    end, "regex")

end


sendGMCP("Char.Status")
sendGMCP("Char.Vitals")
tempTimer(0, function() Init.ProfileOnLogin() end)



-- Saved Variables
function SaveProfileVars()
  GlobalVar.Saved.BuddyChatName = GlobalVar.BuddyChatName or nil
  GlobalVar.Saved.BuddyChatColour = GlobalVar.BuddyChatColour or nil
  GlobalVar.Saved.Silent = GlobalVar.Silent or false
  GlobalVar.Saved.Password = GlobalVar.Password or nil
  GlobalVar.Saved.AutoStance = GlobalVar.AutoStance or false
  GlobalVar.Saved.AutoPlane = GlobalVar.AutoPlane or false
  GlobalVar.Saved.Silent = GlobalVar.Silent or false
  GlobalVar.Saved.MDAY = GlobalVar.MDAY or false
  GlobalVar.Saved.FontSize = GlobalVar.FontSize or nil
  GlobalVar.Saved.Debug = GlobalVar.Debug or false
  local location = getMudletHomeDir() .. "/ProfileVariables.lua"
  table.save(location, GlobalVar.Saved)
end

function LoadProfileVars()
  local location = getMudletHomeDir() .. "/ProfileVariables.lua"
  if io.exists(location) then
    table.load(location, GlobalVar.Saved)
  else
    tempTimer(10, function() Init.FirstTime() end)
    SaveProfileVars()
  end
  GlobalVar.BuddyChatName = GlobalVar.Saved.BuddyChatName or nil
  GlobalVar.BuddyChatColour = GlobalVar.Saved.BuddyChatColour or nil
  GlobalVar.Silent = GlobalVar.Saved.Silent or false
  GlobalVar.Password = GlobalVar.Saved.Password or nil
  GlobalVar.AutoStance = GlobalVar.Saved.AutoStance or false
  GlobalVar.AutoPlane = GlobalVar.Saved.AutoPlane or false
  GlobalVar.Silent = GlobalVar.Saved.Silent or false
  GlobalVar.MDAY = GlobalVar.Saved.MDAY or false
  GlobalVar.FontSize = GlobalVar.Saved.FontSize or nil
  GlobalVar.Debug = GlobalVar.Saved.Debug or false
end

LoadProfileVars()


-- Exit script
function OnMudletExit()
  SaveProfileVars()
end

function OnMudletDisconnect()
  RunStats.EchoSessionAll()
  OnMobDeathQueueClear(false)
  Init.GlobalVars()
  
  GMCP_Vitals()
  DamageCounter.Reset()
  AutoCastCleanUp()
  
  if (GlobalVar.GUI) then
    AutoKillSetGUI()
    AutoSkillSetGUI()
    AutoBashSetGUI()
    AutoCastSetGUI()
  end
end

OnSysExitEventHandler = OnSysExitEventHandler or nil

if OnSysExitEventHandler then
  killAnonymousEventHandler(OnSysExitEventHandler)
end

OnSysExitEventHandler = registerAnonymousEventHandler("sysExitEvent","OnMudletExit",false)


OnSysConnectEventHandler = OnSysConnectEventHandler or nil

if OnSysConnectEventHandler  then
  killAnonymousEventHandler(OnSysConnectEventHandler )
end

OnSysConnectEventHandler = registerAnonymousEventHandler("sysDisconnectionEvent", "OnMudletDisconnect")








