-- Script: AutoLotto Script
-- Attribute: isActive

-- Script Code:
-- Requires PInfo Script

AutoLotto = AutoLotto or {}
AutoLotto.Status = AutoLotto.Status or false
AutoLotto.LottoItems = AutoLotto.LottoItems or {}
AutoLotto.TotalItems = AutoLotto.TotalItems or 0
AutoLotto.LottoList = AutoLotto.LottoList or {}
AutoLotto.PlayerPick = AutoLotto.PlayerPick or 1
AutoLotto.Increment = AutoLotto.Increment or 1

AutoLotto.BagKeyword = AutoLotto.BagKeyword or nil
AutoLotto.BagID = AutoLotto.BagID or nil
AutoLotto.LastPlayer = AutoLotto.LastPlayer or ""
AutoLotto.Round = AutoLotto.Round or 1

safeEventHandler("AutoLottoResetBagIDonQuit", "OnQuit", function() AutoLotto.BagID = nil end)

function AutoLotto.SetBag(keyword, bag_name)
  AutoLotto.BagKeyword = keyword
  
  coroutine.wrap(function()
    local timeout = 1
    local MAX_TIMEOUT = 10 
    local request = "Char.Items.Inv"
    
    repeat
      sendGMCP(request)
      timeout = timeout + 1
      wait(1)
    until (gmcp.Char.Items.List.location == "inv" or timeout >= MAX_TIMEOUT)
    
    
    if (timeout >= MAX_TIMEOUT) then
      error("AutoLotto: couldn't find bag")
      return false
    end
    
    for _, item in ipairs(gmcp.Char.Items.List.items) do
      if item.type == "container" then
        item.name = string.lower(RemoveColourCodes(item.name))
        if string.find(item.name, string.lower(bag_name)) then 
          printMessage("AutoLotto", "Bag found: " .. item.name)
          AutoLotto.BagID = item.id
          return true
        end
      end
    end
  
  printMessage("AutoLotto", "Couldn't find a bag with that name ")
  return false
    
  end)()
end


function AutoLotto.CleanUp()
  send("gtell Lotto finished - thanks for playing!")

  AutoLotto.Status = false  
  OnPInfo.Clear()
  OnPInfo.Write()
  disableTrigger("On PInfo")
  
  AutoLotto.LastPlayer = ""
  AutoLotto.Round = 1
  AutoLotto.PlayerPick = nil
  safeKillTrigger("AutoLottoInvisNote")
  safeKillEventHandler("ProcessLotto")
  --safeKillTrigger("NextWinnerPick")

end

function AutoLotto.Init()
  if not OnPInfo.Lock then
    printMessage("AutoLotto", "Need to run \"autolotto pinfo\" first to save your pinfo")
    return false
  end
  
  if AutoLotto.Status then
    printMessage("AutoLotto", "Error, autolotto already running")
    return false
  end
  
  if not AutoLotto.BagKeyword or not AutoLotto.BagID then
    printMessage("AutoLotto", "Error, please run autolotto bag <keyword> <bag name> first")
    return false
  end
  
  AutoLotto.PopulateBag(AutoLotto.BagID)
  
  if GroupLeader() then
    printMessage("AutoLotto", "Review pinfo show and when ready type \"autolotto start\"")
  else
    send("tell " .. GlobalVar.GroupLeader .. " Autolotto updated, please approve pinfo " .. StatTable.CharName .. " and don't lotto until I gtell asking you to do so.")
  end
end

function AutoLotto.PopulateBag(bag_id)
  coroutine.wrap(function()
    local timeout = 1
    local MAX_TIMEOUT = 10 
    local request = "Char.Items.Contents " .. bag_id
    
    repeat
      sendGMCP(request)
      timeout = timeout + 1
      wait(1)
    until (gmcp.Char.Items.List.location == bag_id or timeout >= MAX_TIMEOUT)
    
    
    if (timeout >= MAX_TIMEOUT) then
      printMessage("AutoLotto", "Error - couldn't find bag. Try doing autolotto bag again")
      return false
    end
       
    AutoLotto.LottoItems = {}
    AutoLotto.TotalItems = 0
    
    local function ItemAlreadyInLottoItems(item_name)
      if #AutoLotto.LottoItems == 0 then return false; end
    
      for i, LottoItem in ipairs(AutoLotto.LottoItems) do
        if LottoItem.name == item_name then
          return i
        end
      end
      return false 
    end

    for _, item in pairs(gmcp.Char.Items.List.items) do
      local index = ItemAlreadyInLottoItems(item.name)
      
      AutoLotto.TotalItems = AutoLotto.TotalItems + 1
      
      if index then
        table.insert(AutoLotto.LottoItems[index].id, item.id)
        AutoLotto.LottoItems[index].quantity = AutoLotto.LottoItems[index].quantity + 1
      else
        table.insert(AutoLotto.LottoItems, {name = item.name, id = {item.id}, quantity = 1})
      end
      
    end
    
    -- don't show the displayitems message when adding items late to lotto bag
    if not AutoLotto.Status then AutoLotto.DisplayItems() end
    AutoLotto.WritePInfo()
    
  end)()
end

function AutoLotto.DisplayItems()
  printMessage("AutoLotto", "Please review the following list\n")
  
  for i = 1, #AutoLotto.LottoItems do
    if AutoLotto.LottoItems[i].quantity > 0 then
      local str = string.format("%-2s.%3sx)  %s", ((i < 10) and " " .. i or i), "(" .. AutoLotto.LottoItems[i].quantity, RemoveColourCodes(AutoLotto.LottoItems[i].name))
    end
  end
  
  printMessage("AutoLotto", "You can ask groupmates to review your pinfo")
  printMessage("AutoLotto", "Run the command \"autolotto start\" when you're ready")
end

function AutoLotto.WritePInfo()
  if not OnPInfo.Lock then
    printMessage("AutoLotto", "Need to run pinfo show first to save your pinfo")
    return false
  end
  
  safeTempTrigger("GagPInfo", "^(Playerinfo cleared|Playerinfo line added).$", function() deleteLine() end, "regex", (#AutoLotto.LottoItems + 3))
  
  OnPInfo.Clear()
  
  send("pinfo + The GLORIOUS LOOT (" .. AutoLotto.TotalItems .. ")", false)
  send("pinfo +", false)
  
  for i = 1, #AutoLotto.LottoItems do
    if AutoLotto.LottoItems[i].quantity > 0 then
      local str = string.format("%-2s.%4s)  %s", ((i < 10) and " " .. i or i), "(x" .. AutoLotto.LottoItems[i].quantity, AutoLotto.LottoItems[i].name)
      send("pinfo + " .. str, false)
    end
  end
end

function AutoLotto.Start() 
  if AutoLotto.Status then
    printMessage("AutoLotto", "Already running")
    return false
  end
  
  if GroupSize() <= 1 then
    printMessage("AutoLotto", "Must have at least 2 in group to lotto")
    return false
  end
  
  if StatTable.Position == "Sleep" then send("rest") end
  
  AutoLotto.Status = true
  AutoLotto.LastPlayer = ""
  AutoLotto.Round = 1
  
  send("visible")
  send("sleep")

  safeEventHandler("ProcessLotto", "OnLotto", function() AutoLotto.ProcessLotto() end, true)
  
  safeTempTrigger("AutoLottoInvisNote", "^Someone tells the group '\\d+'$", function() send("gtell Please be visible.") end, "regex")
  
  if GroupLeader() then
    send("lotto " .. GroupSize(), false)
  else
    send("gtell AutoLotto ready - " .. GlobalVar.GroupLeader .. " please run \"lotto " .. GroupSize() .. "\"", false)
  end

end

function AutoLotto.ProcessLotto()
  AutoLotto.LottoList = deepcopy(LottoCapture)

  if not AutoLotto.LottoList then
    error("AutoLotto: LottoCapture is empty")
    return false
  end

  local msg = "Winners! "

  for i = 1, #AutoLotto.LottoList do
    msg = msg .. i .. ". " .. AutoLotto.LottoList[i] .. " "
  end

  send("gtell " .. msg)
  send("gtell |BW|\"pinfo " .. string.lower(StatTable.CharName) .. "\"|N| to see the loot! \"gtell #\" to pick or \"gtell pass\" to pass")
  send("gtell This is a Snake Lotto, the pick order is reversed each round")
  
  AutoLotto.PlayerPick = nil

  AutoLotto.NextWinner()

end

function AutoLotto.NextWinnerIncrement(playerpick, increment)
  if not playerpick then
    playerpick = 0
    increment = 1
  elseif playerpick == #AutoLotto.LottoList and increment == 1 then
    increment = 0
  elseif playerpick == #AutoLotto.LottoList and increment == 0 then
    increment = -1
  elseif playerpick == 1  and increment == -1 then
    increment = 0
  elseif playerpick == 1  and increment == 0 then
    increment = 1
  end

  return playerpick + increment, increment
end

function AutoLotto.NextWinner()

  AutoLotto.PlayerPick, AutoLotto.Increment = AutoLotto.NextWinnerIncrement(AutoLotto.PlayerPick, AutoLotto.Increment)

  if AutoLotto.PlayerPick > #AutoLotto.LottoList then
    error("AutoLotto: PlayerPick out of range")
    return false
  end

  local player_name = AutoLotto.LottoList[AutoLotto.PlayerPick]
  
  if AutoLotto.LastPlayer == player_name then
    AutoLotto.Round = AutoLotto.Round + 1
    send("gtell |BW|ROUND #" .. AutoLotto.Round .. "|N| - picking in reverse order")
  else
    AutoLotto.LastPlayer = player_name
  end

  local msg = "|BY|" .. player_name .. "|N|'s pick! Check |BW|pinfo " .. string.lower(StatTable.CharName) .. "|N| and |BC|gtell <#>|N| or |BC|gtell pass|N|."

  local next_player = {}
  local next_inc = {}
  local N = math.min(5, AutoLotto.TotalItems)
  
  local colour_table = {"|G|", "|C|", "|B|", "|P|", "|Y|"}

  for i = 1, N do
    if i == 1 then
      next_player[1], next_inc[1] = AutoLotto.NextWinnerIncrement(AutoLotto.PlayerPick, AutoLotto.Increment)
      msg = msg .. " Next up: " .. colour_table[i] .. AutoLotto.LottoList[next_player[1]] .. "|N|"
    else
      next_player[i], next_inc[i] = AutoLotto.NextWinnerIncrement(next_player[i-1], next_inc[i-1])
      msg = msg .. ", " .. colour_table[i] .. AutoLotto.LottoList[next_player[i]] .. "|N|"
    end
  end

  send("gtell " .. msg)

end

function AutoLotto.ProcessWinner(args)
  args = string.lower(args)
  
  if args == "pass" then
    AutoLotto.NextWinner()
    return true
  elseif tonumber(args) ~= nil then
    local item_index = tonumber(args)
    local item = AutoLotto.LottoItems[item_index]
    
    if not item then
      send("gtell Item out of range. Please pick an item from \"pinfo " .. string.lower(StatTable.CharName) .. "\"")
      return false
    elseif item.quantity <= 0 then
      send("gtell Out of item. Please pick an item from \"pinfo " .. string.lower(StatTable.CharName) .. "\"")
  
      return false
    end
    
    AutoLotto.GiveItemToPlayer(item_index, AutoLotto.LottoList[AutoLotto.PlayerPick])
    return true
    
  else
    send("gtell Invalid choice. Please choose a number from \"pinfo " .. string.lower(StatTable.CharName) .. "\" or pass with \"gtell pass\"")
    return false
  end
  

end

function AutoLotto.GiveItemToPlayer(item_index, player_name)
  local item = AutoLotto.LottoItems[item_index]

  if not item then
    error("AutoLotto: item_index out of range")
    return false
  end
  
  if item.quantity <= 0 then
    error("AutoLotto: no item to give")
    return false
  end
  
  local was_asleep = (StatTable.Position == "Sleep" and true or false)
  if was_asleep then send("rest") end
  
  send("get " .. item.id[1] .. " " .. AutoLotto.BagID) -- used to be AutoLotto.BagKeyword
  send("give " .. item.id[1] .. " " .. player_name)
  send("gtell |BY|" .. player_name .. "|N| has picked #" .. item_index .. " (|BY|" .. item.name .. "|N|)")
  
  if was_asleep then send("sleep") end
  
  AutoLotto.LottoItems[item_index].quantity = AutoLotto.LottoItems[item_index].quantity - 1
  table.remove(AutoLotto.LottoItems[item_index].id, 1)  
  AutoLotto.TotalItems = AutoLotto.TotalItems - 1
  
  if AutoLotto.OneItemLeftCheck() then AutoLotto.CleanUp(); return end
  
  AutoLotto.WritePInfo()
  if AutoLotto.TotalItems <= 0 then
    AutoLotto.CleanUp()
    return
  else
    AutoLotto.NextWinner()
  end
  
end

function AutoLotto.OneItemLeftCheck()
  local count = 0
  local index = 0
  
  for i = 1, #AutoLotto.LottoItems do
    if AutoLotto.LottoItems[i].quantity > 0 then
      count = count + 1
      index = i
    end

    if count == 2 then
      return false
    end
  end

  if count == 0 then
    error("AutoLotto: shouldn't be reached")
    return false
  end
  
  local was_asleep = (StatTable.Position == "Sleep" and true or false)
  if was_asleep then send("rest") end

  send("gtell Only one item left! Handing out...")
  local wait_delay = 0
  for i = 1, AutoLotto.TotalItems do
    AutoLotto.PlayerPick, AutoLotto.Increment = AutoLotto.NextWinnerIncrement(AutoLotto.PlayerPick, AutoLotto.Increment)
    local next_send = ""
    
    next_send = "get " .. AutoLotto.LottoItems[index].id[1] .. " " .. AutoLotto.BagID -- used to be AutoLotto.BagKeyword
    next_send = next_send .. cs .. "give " .. AutoLotto.LottoItems[index].id[1] .. " " .. AutoLotto.LottoList[AutoLotto.PlayerPick]
    table.remove(AutoLotto.LottoItems[index].id, 1) 
    next_send = next_send .. cs .. "gtell |BY|" .. AutoLotto.LottoList[AutoLotto.PlayerPick].. "|N| received |BY|" .. AutoLotto.LottoItems[index].name .. "|N|!"

    tempTimer(wait_delay, function() send(next_send) end)
    wait_delay = wait_delay + 0.1
  end
  
  if was_asleep then tempTimer(wait_delay + 1, function() send("sleep"); end) end

  return true
end





-- Cmds:

-- autolotto init
-- autolotto start

-- Player runs pinfo show
-- Player runs autolotto init

-- Calls AutoLotto.Init()
-- Calls AutoLotto.PopulateBag(bag_id)
-- Calls AutoLotto.DisplayItems()
-- Calls AutoLotto.WritePInfo()

-- -- Player reviews, runs autolotto ready
-- Player can ask groupmates to confirm
-- autolotto start
