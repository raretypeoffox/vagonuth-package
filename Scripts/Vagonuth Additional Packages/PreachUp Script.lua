-- Script: PreachUp Script
-- Attribute: isActive

-- Script Code:
CustomPreachup = {
["Xanur"] = "cast 'minds eye'",
--["Zephyra"] = "cast solitude",
["Qhax"] = "cast prayer soothe",
}

CustomFrenzyList = {
  --"Azarael",
  "Thistleshade",
  "Bruzzorli",
}

function CustomMDAYPreachup()
  CustomPreachup["Xanur"] = "cast 'minds eye'" .. cs .."cast steel olodagh" .. cs .. "cast steel glugruk" .. cs .. "cast steel azalad" .. cs .. "cast steel zallah"
  CustomPreachup["Neuralisk"] = "cast steel zhonya" .. cs .. "cast steel xykoi" .. cs .. "cast steel jayla" .. cs .. "cast steel forgeflare" .. cs .. "cast steel markath" .. cs .. "cast steel zeno"
  CustomPreachup["Kindroth"] = "cast barkskin olodagh" .. cs .. "cast barkskin glugruk" .. cs .. "cast barkskin azalad" .. cs .. "cast barkskin zallah"
  CustomPreachup["Ilthuryn"] =  "cast barkskin zhonya" .. cs .. "cast barkskin xykoi" .. cs .. "cast barkskin jayla" .. cs .. "cast barkskin forgeflare"
  CustomPreachup["Vagouth"] =  "cast barkskin zapwick" .. cs .. "cast barkskin zapwizz" .. cs .. "cast barkskin zapwow" .. cs .. "cast barkskin aeryn"
  CustomPreachup["Aphroros"] = "cast barkskin zeno" .. cs .. "cast barkskin markath" .. cs .. "cast barkskin zephyra" .. cs .. "cast barkskin ayas"
  CustomPreachup["Forgeflare"] = "stance veil" .. cs .. "bt enter" .. cs .. "bt deepen" .. cs .. "bt deepen"
  CustomPreachup["Xamur"] = "cast frenzy"
end



function PreachUp()
  if StatTable.Position ~= "Stand" then send("stand") end
  
  if SafeArea() then
    cecho("<white>AutoPreachUp Script<ansi_white>: attempting to get spells from bots, checking if bots are on this plane")
    TryLook()
    getOnlinePlayers()
    tempTimer(2, function() LookForPreachupBots() end)
  end
  
  if IsMDAY() then CustomMDAYPreachup() end
  
  raiseEvent("OnPreachUp")
end

function PreachUpAutoMonitor()
  local monitor_name = nil
  local is_bodyguard = StatTable.Class == "Bodyguard"
  local is_berserker = StatTable.Class == "Berserker"

  local lowest_maxhp = is_bodyguard and math.huge or nil
  
  if StatTable.Monitor and IsGroupMate(StatTable.Monitor) then return end --we're already monitoring someone in the group

  for _, v in ipairs(gmcp.Char.Group.List) do
    if v.name ~= StatTable.CharName then
      if is_bodyguard then
        -- Bodyguard logic: find the group member with the lowest max HP
        local maxhp = tonumber(v.maxhp)
        if maxhp and maxhp < lowest_maxhp and not ArrayHasValue(StaticVars.PrsBots, GMCP_name(v.name)) then
          lowest_maxhp = maxhp
          monitor_name = v.name
        end
      elseif is_berserker and v.class == "Cle" then
        -- Berserker logic: prioritize cleric ("Cle")
        monitor_name = v.name
        break
      elseif v.class == "Bld" then
        -- Default logic: prioritize bladedancer ("Bld")
        monitor_name = v.name
        break
      end
    end
  end


  if not monitor_name then return nil end
  if monitor_name == "Someone" then printGameMessage("PreachUp", "Couldn't monitor, groupie is invis"); return nil; end

  
  local monitor_type = is_bodyguard and "splat" or (is_berserker and "cleric" or "bladedancer")
  printGameMessage("PreachUp", "Monitoring the " .. monitor_type .. ": " .. monitor_name)
  return monitor_name
end


function LookForPreachupBots() 
  local Players = gmcp.Room.Players
  local DruidInRoom = false
  local PsiInRoom = false
  
  -- Only check for / invite the bots to plane if we're in Sanctum / Thorngate
  if not SafeArea() then GetSpellsAtPreachup() end

  for _, player in ipairs(StaticVars.DruidBots) do
    if Players[player] then
      DruidInRoom = true
      break
    end
  end
  
  for _, player in ipairs(StaticVars.PsiBots) do
    if Players[player] then
      PsiInRoom = true
      break
    end
  end
  
  
  if DruidInRoom and PsiInRoom then
    cecho("<white>AutoPreachUp Script<ansi_white>: bots on this plane, getting spells")
    GetSpellsAtPreachup()
  else
    if IsMDAY() then cecho("<white>AutoPreachUp Script<ansi_white>: on MDAY, ask bots to plane manually"); GetSpellsAtPreachup(); return end
    cecho("<white>AutoPreachUp Script<ansi_white>: bots NOT on this plane, asking them to plane")
    if not DruidInRoom then
      for _, player in ipairs(StaticVars.DruidBots) do
        if GlobalVar.OnlinePlayers[player] then
          send("tell " .. player .. " " .. (StatTable.Level == 125 and "thorn" or "mid"), false)
          break
        end
      end
    end
  
    if not PsiInRoom then
      for _, player in ipairs(StaticVars.PsiBots) do
        if GlobalVar.OnlinePlayers[player] then
          send("tell " .. player .. " " .. (StatTable.Level == 125 and "thorn" or "mid"), false)
          break
        end
      end
    end
    -- give the bots time to plane
    tempTimer(8, function() if StatTable.Position ~= "Stand" then send("stand") end; TryLook() end)
    tempTimer(10, function() printGameMessageVerbose("PreachUp", "Asking bots to plane"); GetSpellsAtPreachup() end)
  end
end 

-- Helper function to iterate over a bot list and ask for a spell
local function AskBotForSpell(commandList, Players, botList, spell)
  for _, player in ipairs(botList) do
    if Players[player] then
      table.insert(commandList, "tell " .. player .. " " .. spell)
      break
    end
  end
end

function GetSpellsAtPreachup()
  local Players = gmcp.Room.Players
  local commands = {}
  local MyClass = StatTable.Class
  local MyLevel = StatTable.Level
  local MySubLevel = StatTable.SubLevel
  local isMDAY = IsMDAY()
  
  printGameMessageVerbose("PreachUp", "Getting spells from bots")

  if MyLevel == 125 then
    commands = {"stand", "config -savespell", "config +autoloot", "sneak"}
  else
    commands = {"stand", "config +savespell", "sneak", "move hidden"}
  end
  
  if (not StatTable.Concentrate and not ((MyClass == "Paladin" and MyLevel < 125) or MyClass == "Berserker")) then
    table.insert(commands, "cast concentrate")
  end
  
  if not StatTable.Barkskin then
    if IsMDAY and ((IsClass({"Archer", "Druid", "Fusilier"}) and (MyLevel == 125 or MySubLevel > 69)) or (IsClass({"Wizard"}) and MyLevel == 125)) then
      table.insert(commands, "cast barkskin")
    else
      AskBotForSpell(commands, Players, StaticVars.DruidBots, "bark")
    end
  end
  
  if not StatTable.SteelSkeleton then
    if IsMDAY and ((IsClass({"Psionicist", "Mindbender"}) and MyLevel >= 50) or (IsClass({"Black Circle Initiate"}) and MyLevel == 125)) then
      table.insert(commands, "cast 'steel skeleton'")
    else
      AskBotForSpell(commands, Players, StaticVars.PsiBots, "steel")
    end
  end 
  
  if not StatTable.DarkEmbrace and IsRace(StaticVars.DarkRaces) then
    if IsMDAY and IsNotClass({"Paladin", "Priest", "Berserker", "Druid"}) and (MyLevel == 125 or MySubLevel > 29) then
      table.insert(commands, "cast 'dark embrace'")
    else
      AskBotForSpell(commands, Players, StaticVars.PsiBots, "de")
    end
  end
  
  if StatTable.Race ~= "High Elf" and GlobalVar.AutoFrenzy and StatTable.Level >= 51 and (IsClass(StaticVars.FrenzyClasses) or ArrayHasValue(CustomFrenzyList, StatTable.CharName)) then
    if IsMDAY and IsNotClass({"Berserker","Priest"}) and (MyLevel == 125 or MySubLevel > 41) then
      table.insert(commands, "cast frenzy")
    else
      AskBotForSpell(commands, Players, StaticVars.DruidBots, "frenzy")
    end
  end
  
  -- Paladins and Psionicists have their own cases
  if MyClass == "Paladin" then
    if not StatTable.Fervor then table.insert(commands, "cast fervor") end
    if not StatTable.Prayer and GlobalVar.PrayerName ~= "" then table.insert(commands, "cast prayer '" .. GlobalVar.PrayerName .. "'") end
    if (MyLevel == 125 or MySubLevel > 101) and StatTable.Oath == "war" then table.insert(commands, "cast 'holy zeal'") end
    if (MyLevel == 125 or MySubLevel > 250) and StatTable.Oath == "evolution" and not StatTable.JoinedBoon and not StatTable.SharedBoon then
      local evolBoon = "cast " .. (MyLevel == 125 and "shared" or "joined")
      table.insert(commands, evolBoon) 
    end
    
  elseif MyClass == "Priest" and (MyLevel == 125 or MySubLevel > 250) and not StatTable.Intervention and not StatTable.InterventionExhaust then
    table.insert(commands, "cast intervention " .. (GlobalVar.InterventionTarget and GlobalVar.InterventionTarget or ""))
  elseif MyClass == "Cleric" then
    castPantheonSpell()    
  elseif MyClass == "Psionicist" and MyLevel >= 51 and StatTable.max_mana > 3000 then
    if not StatTable.KineticChain then  table.insert(commands, "cast 'kinetic chain'") end
    
    if (MyLevel == 125 or MySubLevel >= 500) and matchKineticEnhancer(GlobalVar.KineticEnhancerOne) and checkKineticEnhancers() < 1 then
      table.insert(commands, "cast '" .. GlobalVar.KineticEnhancerOne .. "'")
    end
    if MyLevel == 125 and matchKineticEnhancer(GlobalVar.KineticEnhancerTwo) and checkKineticEnhancers() < 2 then
        table.insert(commands, "cast '" .. GlobalVar.KineticEnhancerTwo .. "'")
    end
    

    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if MyLevel == 125 then
      --table.insert(commands, "quicken 5")
      --table.insert(commands, "cast 'magic light'")
      --table.insert(commands, "cast 'magic light'")
      --table.insert(commands, "cast 'magic light'")
      --table.insert(commands, "quicken off")
      if MySubLevel > 200 and not StatTable.Gravitas then table.insert(commands, "cast 'gravitas'") end
    end
  elseif MyClass == "Mindbender" and MyLevel == 125 then
    if not StatTable.MindHive then table.insert(commands, "cast 'hive mind'") end
  
  elseif MyClass == "Mage" and MyLevel >= 51 then
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (StatTable.max_mana > 5000) and not StatTable.Mystical then table.insert(commands, "cast mystical") end 
    
  elseif MyClass == "Wizard" and MyLevel >= 51 then
    if (StatTable.max_mana > 5000) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (StatTable.max_mana > 5000) and not StatTable.Mystical then table.insert(commands, "cast mystical") end
    if MyLevel == 125 then table.insert(commands, "cast 'ether link'") end
    
  elseif MyClass == "Stormlord" and MyLevel >= 51 then
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (MyLevel == 125 and not StatTable.GaleStratum) then table.insert(commands, "cast stratum gale") end
    
  elseif MyClass == "Sorcerer" and MyLevel >= 51 then
    if (StatTable.max_mana > 5000) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (StatTable.max_mana > 5000) and not StatTable.Mystical then table.insert(commands, "cast mystical") end
    if (MyLevel == 125 and MySubLevel >= 200) and not StatTable.VilePhilosophy then table.insert(commands, "cast 'vile philosophy'") end
    if not StatTable.DeathShroud then table.insert(commands, "cast 'death shroud'") end
    if MyLevel >= 51 and not StatTable.SummonNecrit then table.insert(commands, "cast 'summon necrit'") end
  elseif MyClass == "Black Circle Initiate" and MyLevel >= 51 then
    if not StatTable.Nightcloak then table.insert(commands, "cast 'nightcloak'") end
    
    if MyLevel == 125 and not StatTable.KahbyssInsight then 
      table.insert(commands, "cast 'kahbyss insight'") 
    elseif not StatTable.SenseWeakness and (MyLevel == 125 or MySubLevel >= 250) then 
      table.insert(commands, "cast 'sense weakness'") 
    end
    
  elseif MyClass == "Bladedancer" and MyLevel == 125 then
    if not BldDancing() then
      table.insert(commands, "stance unending")
    end
  elseif MyClass == "Monk" then
    if MyLevel == 125 then
      if not StatTable.BlindDevotion then table.insert(commands, "cast 'blind devotion'") end
      if not StatTable.Consummation then table.insert(commands, "cast consummation") end
      if not StatTable.StoneFist then table.insert(commands, "cast 'stone fist'") end
    elseif MyLevel == 51 then
      if MySubLevel > 150 and StatTable.ArmorClass < -500 then -- only cast if in hit mode
        table.insert(commands, "cast 'dagger hand'")
      end
    end
  elseif MyClass == "Shadowfist" then
    if MyLevel == 125 then
      if not StatTable.Consummation then table.insert(commands, "cast consummation") end
      if not StatTable.StoneFist then table.insert(commands, "cast 'stone fist'") end
    elseif MyLevel == 51 then
      if MySubLevel > 150 and StatTable.ArmorClass < -500 then -- only cast if in hit mode
        table.insert(commands, "cast 'dagger hand'")
      elseif MySubLevel > 200 then
        table.insert(commands, "cast 'stone fist'")
      end
    end 
  end
  
  if MyLevel == 125 and (MyClass == "Assassin" or MyClass == "Rogue" or MyClass == "Black Circle Initiate") then 
    table.insert(commands, "sn") 
    table.insert(commands, "alertness")  
  end
    
  if StatTable.Race == "Drider" then table.insert(commands, "racial imbue") end
  
  
  if MyLevel == 125 and MyClass == "Berserker" then table.insert(commands, "rest"); table.insert(commands, "gtell remember to send the bzk :)")  end
  
  if MyLevel == 125 and IsNotClass({"Soldier", "Berserker", "Shadowfist", "Black Circle Initiate"}) and StatTable.current_mana > 2000 and Grouped() then table.insert(commands, "cast 'detect haven'") end

  
  if StatTable.max_moves < 1000 and StatTable.SubLevel > 7 and not StatTable.Endurance and IsNotClass({"Berserker"}) then table.insert(commands, "cast endurance") end
  
  if CustomPreachup[StatTable.CharName] then table.insert(commands, CustomPreachup[StatTable.CharName]) end
  
  if not StatTable.ProtectionGood and StatTable.Alignment < -300 then
    table.insert(commands, "cast 'protection good'")
  end
  
  safeCall(ClearGurneyTriggers)
  if GroupLeader() and SafeArea() then sendGMCP("Char.Group.List"); tempTimer(4, [[GroupOrder()]]) end
  
  -- sneak
  if MyLevel >= 51 and IsNotClass({"Paladin", "Priest", "Berserker", "Wizard", "Bodyguard", "Stormlord"}) then
    if IsClass({"Sorcerer", "Black Circle Initiate"}) and (MyLevel == 125 or MySubLevel >= 5) then
      table.insert(commands, "shadow form")
    else
      table.insert(commands, "sneak")
    end
  end
  
  -- For solo preachups
  if not Grouped() then
  
    
    
    if MyLevel == 125 then
      -- Grab intervention before we go at lord
      if not StatTable.Intervention then
        for _, player in ipairs(StaticVars.PrsBots) do
          if Players[player] then
            table.insert(commands, "tell " .. player .. " intervention")
          break
          end  
        end
      end
      
      
      if not StatTable.Invis then table.insert(commands, "cast 'improved invis'") end
      
    
    end
    
    
    if MyClass == "Sorcerer" and not StatTable.DefiledFlesh and (MySubLevel >= 250 or MyLevel >= 51) then
      table.insert(commands, "cast defiled")
      for _, player in ipairs(StaticVars.PrsBots) do
        if Players[player] then
          table.insert(commands, "tell " .. player .. " comf3")
        break
        end  
      end
    end
    
    
  else -- end of solo preachup spells
    if StatTable.Surge > 0 then table.insert(commands, "surge off") end
    if StatTable.Augment > 0 then table.insert(commands, "augment off") end
    if StatTable.Quicken > 0 then table.insert(commands, "quicken off") end
    GlobalVar.SurgeLevel = 2
  end 
  
  -- choose a monitor target
  local monitor_name = PreachUpAutoMonitor()
  if monitor_name then table.insert(commands, "monitor " .. monitor_name) end 

  
  
  if MyLevel < 125 and not GroupLeader() then table.insert(commands, "sleep") end
  
  for _, cmd in ipairs(commands) do
    send(cmd)
  end
end