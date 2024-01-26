-- Script: PreachUp Script
-- Attribute: isActive

-- Script Code:
CustomPreachup = {
["Jayla"] = "stance unending",
["Zhonya"] = "stance unending",
["Hezzur"] = "cast 'glorious conquest'",
["Atrax"] = "cast frenzy",
["Xanur"] = "cast 'minds eye'",
["Forgeflare"] = "tell neodox frenzy",
["Zephyra"] = "cast solitude",
["Zeno"] = "cast 'ether link'",
}

function CustomMDAYPreachup()
  CustomPreachup["Halgod"] = "cast 'discordia'"
  --CustomPreachup["Atrax"] = "tell ayas solitude"
  CustomPreachup["Olodagh"] = "tell xanur steel"
  CustomPreachup["Glugruk"] = "tell xanur steel"
  CustomPreachup["Azalad"] = "tell xanur steel"
  CustomPreachup["Zallah"] = "tell xanur steel"
  CustomPreachup["Zhonya"] = CustomPreachup["Zhonya"] .. getCommandSeparator() .. "tell xanur steel"
  CustomPreachup["Jayla"] = CustomPreachup["Jayla"] .. getCommandSeparator() .. "tell xanur steel"
  CustomPreachup["Olodagh"] = "tell kindroth bark"
  CustomPreachup["Glugruk"] = "tell kindroth bark"
  CustomPreachup["Azalad"] = "tell kindroth bark"
  CustomPreachup["Zallah"] = "tell kindroth bark"
  CustomPreachup["Zhonya"] = CustomPreachup["Zhonya"] .. getCommandSeparator() .. "tell kindroth bark"
  CustomPreachup["Jayla"] = CustomPreachup["Jayla"] .. getCommandSeparator() .. "tell kindroth bark"
end



function PreachUp(AskForFrenzy)
  AskForFrenzy = AskForFrenzy or false
  cecho("<white>AutoPreachUp Script<ansi_white>: attempting to get spells from bots, checking if bots are on this plane")
  if StatTable.Position ~= "Stand" then send("stand") end
  TryLook()
  getOnlinePlayers()
  if IsMDAY() then CustomMDAYPreachup() end
  
  PreachUpAutoMonitor()
  
  tempTimer(2, function() LookForPreachupBots() end)
  raiseEvent("OnPreachUp")
end

function PreachUpAutoMonitor()
  local monitor_name = nil
  local is_bodyguard = StatTable.Class == "Bodyguard"
  local lowest_maxhp = is_bodyguard and math.huge or nil

  for _, v in ipairs(gmcp.Char.Group.List) do
    if v.name ~= StatTable.CharName then
      if is_bodyguard then
        local maxhp = tonumber(v.maxhp)
        if maxhp and maxhp < lowest_maxhp then
          lowest_maxhp = maxhp
          monitor_name = v.name
        end
      elseif v.class == "Bld" then
        monitor_name = v.name
        break
      end
    end
  end

  if not monitor_name then return end
  if monitor_name == "Someone" then printGameMessage("PreachUp", "Couldn't monitor, groupie is invis"); return; end

  send("monitor " .. monitor_name)
  local monitor_type = is_bodyguard and "splat" or "bladedancer"
  printGameMessage("PreachUp", "Monitoring the " .. monitor_type .. ": " .. monitor_name)

end


function LookForPreachupBots(AskForFrenzy)
  AskForFrenzy = AskForFrenzy or false
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

function GetSpellsAtPreachup(AskForFrenzy)
  AskForFrenzy = AskForFrenzy or false 
  local Players = gmcp.Room.Players
  local commands
  local MyClass = StatTable.Class
  local MyLevel = StatTable.Level
  local MySubLevel = StatTable.SubLevel
  
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
    for _, player in ipairs(StaticVars.DruidBots) do
      if Players[player] then
        table.insert(commands, "tell " .. player .. " bark")
        break
      end
    end
  end
  
  if not StatTable.SteelSkeleton then
    for _, player in ipairs(StaticVars.PsiBots) do
      if Players[player] then
        table.insert(commands, "tell " .. player .. " steel")
        break
      end
    end
  end 
  
  if not StatTable.DarkEmbrace and ArrayHasValue(StaticVars.DarkRaces, StatTable.Race) then
    for _, player in ipairs(StaticVars.PsiBots) do
      if Players[player] then
        table.insert(commands, "tell " .. player .. " de")
        break
      end
    end
  end
  
  if StatTable.Race ~= "High Elf" and (AskForFrenzy or ArrayHasValue(StaticVars.FrenzyClasses, MyClass)) then
    -- On MDAY we'll frenzy ourself to spare the bots. Otherwise, ask bots for frenzy
    if IsMDAY() and StatTable.Class ~= "Berserker" and (MyLevel > 51 or MySubLevel > 41) then
      table.insert(commands, "cast frenzy")
    else
      for _, player in ipairs(StaticVars.DruidBots) do
        if Players[player] then
          table.insert(commands, "tell " .. player .. " frenzy")
          break
        end
      end
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
    
  elseif MyClass == "Psionicist" and MyLevel >= 51 and StatTable.max_mana > 3000 then
    if not StatTable.KineticChain then  table.insert(commands, "cast 'kinetic chain'") end
    if not StatTable.StunningWeapon and (MyLevel == 125 or MySubLevel >= 500) then table.insert(commands, "cast 'stunning weapon'") end
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    
  elseif MyClass == "Mage" and MyLevel >= 51 then
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Mystical then table.insert(commands, "cast mystical") end
    
  elseif MyClass == "Wizard" and MyLevel >= 51 then
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Mystical then table.insert(commands, "cast mystical") end
    
  elseif MyClass == "Stormlord" and MyLevel >= 51 then
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (MyLevel == 125 and not StatTable.GaleStratum) then table.insert(commands, "cast stratum gale") end
  elseif MyClass == "Sorcerer" and MyLevel >= 51 then
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Savvy then table.insert(commands, "cast savvy") end
    if (MyLevel == 125 or MySubLevel > 101) and not StatTable.Mystical then table.insert(commands, "cast mystical") end
    if (MyLevel == 125 and MySubLevel >= 200) and not StatTable.VilePhilosophy then table.insert(commands, "cast 'vile philosophy'") end
    if not StatTable.DeathShroud then table.insert(commands, "cast 'death shroud'") end
    if MyLevel >= 51 and not StatTable.SummonNecrit then table.insert(commands, "cast 'summon necrit'") end

  end
  
  if MyLevel == 125 and (MyClass == "Assassin" or MyClass == "Rogue" or MyClass == "Black Circle Initiate") then table.insert(commands, "sn") end
  if MyLevel == 125 and MyClass == "Berserker" then table.insert(commands, "rest"); table.insert(commands, "gtell remember to send the bzk :)")  end
  
  if MyLevel == 125 and IsNotClass({"Soldier", "Berserker", "Shadowfist", "Black Circle Initiate"}) and StatTable.current_mana > 2000 then table.insert(commands, "cast 'detect haven'") end

  
  if StatTable.max_moves < 750 and StatTable.SubLevel > 7 and not StatTable.Endurance and IsNotClass({"Berserler"}) then table.insert(commands, "cast endurance") end
  
  if CustomPreachup[StatTable.CharName] then table.insert(commands, CustomPreachup[StatTable.CharName]) end
  
  safeCall(ClearGurneyTriggers)
  if GroupLeader() then sendGMCP("Char.Group.List"); tempTimer(4, [[GroupOrder()]]) end
  
  -- For solo preachups
  if not Grouped() then
    
    if MyLevel == 125 then
      -- Grab sanc before we go at lord
      for _, player in ipairs(StaticVars.PrsBots) do
        if Players[player] then
          table.insert(commands, "tell " .. player .. " intervention")
        break
        end  
      end
    
    end
    
    
    if MyClass == "Sorcerer" and (MySubLevel >= 250 or MyLevel >= 51) then
      table.insert(commands, "cast defiled")
    end
    
  end -- end of solo preachup spells
    
    
     

  
  
  if MyLevel < 125 and not GroupLeader() then table.insert(commands, "sleep") end
  
  for _, cmd in ipairs(commands) do
    send(cmd)
  end
end