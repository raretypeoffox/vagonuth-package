-- Script: AutoRescue
-- Attribute: isActive

-- Script Code:
AR = AR or {}
AR.RescueList = AR.RescueList or {}
AR.Status = AR.Status or false
AR.MinHP = AR.MinHP or 0.20
AR.Echo = AR.Echo or GlobalVar.Silent or false
AR.RescueStack = AR.RescueStack or {}
AR.RescueLock = AR.RescueLock or false
AR.ProcessRescueStackLock = AR.ProcessRescueStackLock or false
AR.RescueStackDelaySeconds = (math.floor((0.5 + math.random() * 0.5) * 100 + 0.5) / 100) or 1 -- previously used 1 and it worked well, trying a random number between 0.5 and 1
AR.MonitorRescue = AR.MonitorRescue or false
AR.MontorRescueHPpct = AR.MontorRescueHPpct or 0.25

AR.RescueBzk = AR.RescueBzk or {}

function AR.Debug(message)
  if GlobalVar.Debug then
    cecho(message)
  end 
end

function AR.Rescue(name)
  if not AR.Status then return false end -- AutoRescue off, return
  
  name = string.lower(name)
  if not AR.RescueList[name] then return false end -- name is not on rescue list, return
  if not GlobalVar.GroupMates[firstToUpper(name)] then AR.Debug(name .. " not a groupmate or you don't have detects up"); return end


  local currentHPpct = (StatTable.current_health / StatTable.max_health)
  if currentHPpct < AR.MinHP then -- if hp too low, return
    cecho("\n<white>AutoRescue:<ansi_white> Didn't rescue " .. name .. ". HP% less than " .. (AR.MinHP * 100) .. "%\n")
    return false
  end
  
  -- If rescue target is a Bzk
  if GlobalVar.GroupMates[firstToUpper(name)].class == "Bzk" then
  
    -- Add them to the array
    if not AR.RescueBzk[name] then
      AR.RescueBzk[name] = {}
      AR.RescueBzk[name].rounds = 0
      AR.RescueBzk[name].lock = false
    end
    
    -- We only want to add +1 to the rounds variable is the Bzk took damage in a different round
    -- Thus we will only add +1 every 2seconds at most (eg in the case where the Bzk is tanking 3 different mobs)
    if AR.RescueBzk[name].lock then
      return
    end
    
    AR.RescueBzk[name].rounds = AR.RescueBzk[name].rounds + 1
    AR.RescueBzk[name].lock = true
    tempTimer(2, function() if AR.RescueBzk[name] then AR.RescueBzk[name].lock = false end; end)
    
    
    if AR.RescueBzk[name].rounds < 3 then return end  
  
  end
  

  -- ok ready to rescue, lets make a priority list

 -- check if name already on stack, if so update HP
  local AlreadyOnStack = false

  if #AR.RescueStack > 0 then 
    for _, player in ipairs(AR.RescueStack) do
      if player.name == name then 
        player.hp = GlobalVar.GroupMates[GMCP_name(name)].hp or 0
        AR.Debug("\n<white>AutoRescue:<ansi_white> " .. name .. " already on stack, HP updated to: " .. GlobalVar.GroupMates[GMCP_name(name)].hp) 
        AlreadyOnStack = true
        break
      end
    end
  end

  if not AlreadyOnStack then
    AR.Debug("\n<white>AutoRescue:<ansi_white> " .. name .. " added to the rescue stack with HP: " .. GlobalVar.GroupMates[GMCP_name(name)].hp) 
    table.insert(AR.RescueStack, {name = name, hp = GlobalVar.GroupMates[GMCP_name(name)].hp or 0})
  end

  
  if not AR.RescueLock then
    AR.RescueLock = true
    tempTimer(AR.RescueStackDelaySeconds, function() AR.RescueLock = false; AR.ProcessRescueStack() end)
  end

end



function AR.ProcessRescueStack(InternalFunctionLock)
  if InternalFunctionLock == nil then InternalFunctionLock = AR.ProcessRescueStackLock end
  AR.Debug("\n<white>AutoRescue:<ansi_white> AR.ProcessRescueStack() called")
  if #AR.RescueStack == 0 then
    AR.Debug("\n<white>AutoRescue:<ansi_white> Rescue stack empty, ending recursive calls")
    AR.ProcessRescueStackLock = false; return 
  end --function recursively calls itself till stack is empty
  if InternalFunctionLock then AR.Debug("\n<white>AutoRescue:<ansi_white> AR.ProcessRescueStack() failed lock") return end -- return if function is already in recursive loop
  
  AR.Debug("\n<white>AutoRescue:<ansi_white> AR.ProcessRescueStack() through the locks")
  
  AR.ProcessRescueStackLock = true

  local lag = tonumber(gmcp.Char.Vitals.lag) or 0

  table.sort(AR.RescueStack, function (k1, k2) return k1.hp < k2.hp end ) -- smallest HP groupmates to the top of the stack
  
  AR.Debug("\n<white>AutoRescue:<ansi_white> Rescue stack called, groupies sorted by HP")
  
  
  if lag > 0 then
    AR.Debug("\n<white>AutoRescue:<ansi_white> We are in lag, will try processing the stack in " .. lag .. "  seconds")
    tempTimer(lag, function() AR.ProcessRescueStack(false) end)
    return
  end
  
  cecho("\n<white>AutoRescue:<ansi_white> Rescueing " .. AR.RescueStack[1].name .. "! Will check stack again in "..AR.RescueStackDelaySeconds.." second(s)")
  send("rescue " .. AR.RescueStack[1].name)
  table.remove(AR.RescueStack, 1)
  tempTimer(AR.RescueStackDelaySeconds, function() if Battle.Combat then AR.ProcessRescueStack(false); else AR.RescueStack = {}; AR.ProcessRescueStackLock = false end; end) -- if we check for Battle.Combat, AR.RescueStack isn't cleared when fight ends early
  --tempTimer(AR.RescueStackDelaySeconds, function() AR.ProcessRescueStack(false); end)
end

function AR.RemovePlayerFromStack(name)
  name = string.lower(name)

  -- if that player was on the stack, remove them
  if #AR.RescueStack > 0 then 
    for stack_index, player in ipairs(AR.RescueStack) do
      if player.name == name then 
        table.remove(AR.RescueStack, stack_index)
        AR.Debug("\n<white>AutoRescue:<ansi_white> Another tank rescued " .. name .. ", removed them from the rescue stack")
        break
      end
    end
  end
end

function AR.GroupieRescuesMe(name)
  if AR.Status == true then 
    if GlobalVar.GroupMates and GlobalVar.GroupMates[GMCP_name(name)] and  GlobalVar.GroupMates[GMCP_name(name)].class == "Bzk" then return end
    if AR.RescueList[string.lower(name)] == true then
      AR.Remove(name)
      if AR.Echo then
        cecho("<white>AutoRescue:<ansi_white> I was rescued by <yellow>" .. firstToUpper(name) .. "<ansi_white> - removed from AutoRescue\n")
      else
        send("gtell |BW|AutoRescue:|N| I was rescued by |BC|" .. firstToUpper(name) .. "|N| - removed from AutoRescue (add yourself again with |BW|gt add me|N|)")
      end
    end
  end
end


function AR.On()
  AR.Status = true
  print("AutoRescue enabled")
end

function AR.Off()
  AR.Status = false
  print("AutoRescue disabled")
end

function AR.Remove(name)
  if name == "Someone" then
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> someone not removed, go vis first\n") else send("gtell |BW|AutoRescue:|N| Not removed, go vis first") end
    return false
  else
    if AR.RescueList[string.lower(name)] then
      AR.RescueList[string.lower(name)] = false
      if AR.Echo then cecho("<white>AutoRescue:<ansi_white> " .. firstToUpper(name) .. " removed\n") else send("gtell |BW|AutoRescue:|N| " .. firstToUpper(name) .. " removed") end
      return true
    else
      if AR.Echo then cecho("<white>AutoRescue:<ansi_white> " .. firstToUpper(name) .. " not on autorescue list\n") else  send("gtell |BW|AutoRescue:|N| " .. firstToUpper(name) .. " not on autorescue list") end
      return false
    end
  end
end

function AR.Add(name)
  --name = string.gsub(name,"|%w+|","") -- AR.add only called by trigger or alias (not GMCP), not needed
  if name == "Someone" then
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> someone not added, go vis first\n") else send("gtell |BW|AutoRescue:|N| Not added, go vis first") end
  elseif AR.RescueList[string.lower(name)] == true then
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> " .. firstToUpper(name) .. " already on list\n") else send("gtell |BW|AutoRescue:|N| " .. firstToUpper(name) .. " already on list") end
  else
    AR.RescueList[string.lower(name)] = true
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> " .. firstToUpper(name) .. " added\n") else send("gtell |BW|AutoRescue:|N| " .. firstToUpper(name) .. " added") end
  end
end

function AR.All()
  AR.RescueList = {}
  local AR_paladins = ""
  for k,v in ipairs(gmcp.Char.Group.List) do
    v.name = RemoveColourCodes(v.name)
    if v.name == "Someone" then 
      print("")
      print("AutoRescue ERROR: invis groupie not added")   
    elseif v.name == StatTable.CharName then
      -- not adding ourself
    else
      if v.class == "Pal" then
        AR_paladins = AR_paladins .. v.name .. " |BW|||BY| "
      else
        AR.RescueList[string.lower(v.name)] = true
      end
    end   
  end
  if AR_paladins == "" then
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> all groupies added\n") else send("gtell |BW|AutoRescue:|N| all groupies added") end
  else
    AR_paladins = AR_paladins:sub(1,-12)
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> all groupies excluding paladins (<yellow>" .. AR_paladins .."<ansi_white>)\n") else send("gtell |BW|AutoRescue:|N| added all groupies excluding paladins (|BY|" .. AR_paladins .."|N|)") end
  end
  if not AR.Echo then AR.Show() end
end

function AR.Auto()
  AR.RescueList = {}
  local AR_excluded = ""
  for k,v in ipairs(gmcp.Char.Group.List) do
    v.name = RemoveColourCodes(v.name)
    if v.name == "Someone" then 
      print("")
      print("AutoRescue ERROR: invis groupie not added")   
    elseif v.name == StatTable.CharName then
      -- not adding ourself
    else
      if v.class == "Pal" or v.class == "Bld" or v.class == "War" or v.class == "Rip" or v.class == "Bod" or v.class == "Mon" or v.class == "Shf" then
        AR_excluded = AR_excluded .. v.name .. " |BW|||BY| "
      else
        -- exclude mutants as well
        if tonumber(v.maxhp) > 50000 then AR_excluded = AR_excluded .. v.name .. " |BW|||BY| " else
        AR.RescueList[string.lower(v.name)] = true; end
      end
    end   
  end
  if AR_excluded == "" then
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> all groupies added\n") else send("gtell |BW|AutoRescue:|N| all groupies added") end
  else
    AR_excluded = AR_excluded:sub(1,-12)
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> all groupies excluding tanks/pals/blds/mutants (<yellow>" .. AR_excluded .."<ansi_white>)\n") else send("gtell |BW|AutoRescue:|N| added all groupies excluding tanks/pals/blds/mutants (|BY|" .. AR_excluded .."|N|)") end
  end
  if not AR.Echo then AR.Show() end
end

function AR.Small(smallhp)
  AR.RescueList = {}
  local AR_paladins = ""
  for k,v in ipairs(gmcp.Char.Group.List) do
    v.name = (v.name)
    if v.name == "Someone" then 
      print("")
      print("AutoRescue ERROR: invis groupie not added")   
    elseif v.name == StatTable.CharName then
      -- not adding ourself
    else
      if (tonumber(v.maxhp) < smallhp) then
        if v.class == "Pal" then
          AR_paladins = AR_paladins .. v.name .. " |BW|||BY| "
        else
          AR.RescueList[string.lower(v.name)] = true
        end
      end
    end 
  end
  if AR_paladins == "" then
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> all groupies with maxhp less than " .. format_int(smallhp) .. " added\n") else send("gtell |BW|AutoRescue:|N| all groupies with maxhp less than " .. format_int(smallhp) .. " added") end
  else
    AR_paladins = AR_paladins:sub(1,-12)
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> all groupies with maxhp less than " .. format_int(smallhp) .. " added excluding paladins (<yellow>" .. AR_paladins .."<ansi_white>)\n") else send("gtell |BW|AutoRescue:|N| all groupies with maxhp less than " .. format_int(smallhp) .. " added excluding paladins (|BY|" .. AR_paladins .."|N|)") end
  end
  if not AR.Echo then AR.Show() end
end

local MAX_NAMES = 10

function AR.Show()
  local list = "|BW|AutoRescue List: |BR|"
  local count = 0
  for name,listed in pairs(AR.RescueList) do
    if listed == true then
      list = list .. firstToUpper(name)
      count = count + 1
      if count % MAX_NAMES == 0 then -- gtell has a line maximum, after 10 names, start a new line
        list = list .. "|N|" .. getCommandSeparator() .. "gtell |BR|"
      else
        list = list .. " |BW|||BR| "
      end
    end
  end
  
  if count == 0 then
    printMessage("AutoRescue", "No one on AutoRescue list to show...")
    return
  end
  
  -- if we happened to have exactly 12 on AR, we would have created the extra gtell unecessarily, in this case remove it
  if count % MAX_NAMES == 0 then
    list = list:sub(1,-8) -- remove the gtell that wasn't needed
  else -- otherwise remove the last name seperator: |
    list = list:sub(1,-12) -- remove the last | from the list
  end
  
  list = list .. " |N|(|BW|gt add me|N| to be added)"
  send("gtell " ..  list)
end

function AR.print_status()
  cecho("<white>AutoRescue<ansi_white> is " .. (AR.Status and "ON" or "OFF") .. "\n")
end
    

function AR.Clear()
  AR.RescueList = {}
  if (AR.Status) then 
    if AR.Echo then cecho("<white>AutoRescue:<ansi_white> List cleared\n") else send("gtell |BW|AutoRescue:|N| List cleared") end
  end
end

function AR.OnMobDeath()
  AR.RescueBzk = {}
end

AR.EventMobDeath = AR.EventMobDeath or nil

if AR.EventMobDeath then
  killAnonymousEventHandler(AR.EventMobDeath)
end

AR.EventMobDeath = registerAnonymousEventHandler("OnMobDeath", AR.OnMobDeath)
