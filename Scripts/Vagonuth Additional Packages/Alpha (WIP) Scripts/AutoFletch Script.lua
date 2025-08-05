-- Script: AutoFletch Script
-- Attribute: isActive

-- Script Code:
AutoFletch = AutoFletch or {}

AutoFletch.Status = AutoFletch.Status or false
AutoFletch.ExhaustTable = AutoFletch.ExhaustTable or {}
AutoFletch.NextSpecialFletch = AutoFletch.NextSpecialFletch or nil
AutoFletch.AntiSpam = AutoFletch.AntiSpam or 0

ArrowTable = ArrowTable or {}

-- In the game, special arrows are crafted on a hidden exhaust timer
-- That is, as soon as you begin crafting you of the special arrows, a
-- 50 minute hidden timer starts. During that time, you will only be able
-- to successfully craft those arrows 6 times in total.

-- We are writing a script to cycle through the different arrow types 

-- TODO: add poison for terror arrows



function AutoFletch.SetUpExhaustTable(char_name)
    if not char_name then
        error("AutoFletch.SetUpExhaustTable: char_name is nil")
        return false
    end

    if AutoFletch.ExhaustTable[char_name] then return true end

    AutoFletch.ExhaustTable[char_name] = {}

    for _, arrow in ipairs(ArrowTable) do
        AutoFletch.ExhaustTable[char_name][arrow] = {qty = 0, time = 0, amount = 0}
    end

    return true
end

function AutoFletch.ResetExhaustTable(char_name)
    if not char_name then
        error("AutoFletch.SetUpExhaustTable: char_name is nil")
        return false
    end

    AutoFletch.ExhaustTable[char_name] = {}

    for _, arrow in ipairs(ArrowTable) do
        AutoFletch.ExhaustTable[char_name][arrow] = {qty = 0, time = 0, amount = 0}
    end

    return true
end

    -- Lordly arrow success messages:
    -- Your efforts produced 1 lordly Sableroix arrow
    -- Your efforts produced 2 lordly Sableroix arrows
    -- Hero arrow success messages:
    -- Your efforts produced 1 Sableroix arrow
    -- Your efforts produced 2 Sableroix arrows

    -- Failed message: You fail to produce anything worth shooting.


function AutoFletch.SetNextSpecialAmmo(char_name)
    if not char_name or not AutoFletch.ExhaustTable[char_name] then
        error("AutoFletch.SetNextSpecialAmmo: char_name is nil or ExhaustTable[char_name] is nil")
        return false
    end

    -- As each arrow type starts its own hidden timer, the first thing we want to do is ensure we've
    -- crafted at least one of every arrow type. From there we want to swap through the arrow types
    -- crafiting until we've made 6 of each type.

    -- First, check if we've crafted at least one of each arrow type
    for _, arrow in ipairs(ArrowTable) do
        print(arrow, AutoFletch.ExhaustTable[char_name][arrow].qty)
        if AutoFletch.ExhaustTable[char_name][arrow].qty == 0 then
            AutoFletch.NextSpecialFletch = arrow
            return true
        end
    end

    -- If we've crafted at least one of each arrow type, then we want to swap through the arrow types
    -- crafting until we've made 6 of each type. The next arrow we want to fletch is the one we've fletched
    -- the least of.
    local min = 6
    for _, arrow in ipairs(ArrowTable) do
        if AutoFletch.ExhaustTable[char_name][arrow].qty < min then
            min = AutoFletch.ExhaustTable[char_name][arrow].qty
            AutoFletch.NextSpecialFletch = arrow
        end
    end
    
    if min < 6 then return true end

    printMessage("AutoFletch", "Finished crafting all special arrows on this character.")
    
    -- We finished all our special arrows:
    -- stop fletching
    AutoFletch.SpecialAmmoCleanUp()
    send("sleep")
    -- in 50 mins, clear exhaust table and attempt to restart (these are broken into two because AutoFletch.Restart can be killed by OnQuit
    safeTempTimer("AutoFletch.ClearExhaustTable", 50*60, function() AutoFletch.ResetExhaustTable(char_name); end)
    safeTempTimer("AutoFletch.Restart", 50*60, function() send("stand"); AutoFletch.SpecialAmmoInit() end)
    safeEventHandler("AutoFletch.KillRestartOnQuit", "OnQuit", function() safeKillTimer("AutoFletch.Restart") end, true)


end

function AutoFletch.FletchAmmo(ammo, ammo_type)
    if AutoFletch.Status then
        send("fletch '" .. ammo .. "' '" .. ammo_type .. "'", true)
    end
end
   

function AutoFletch.SpecialAmmo(char_name, ammo, tier)
    if not char_name or not AutoFletch.ExhaustTable[char_name] then
        error("AutoFletch.SpecialAmmo: char_name is nil or ExhaustTable[char_name] is nil")
        return false
    end

    AutoFletch.SetNextSpecialAmmo(char_name)

    if (AutoFletch.Status == false) then
        return false
    end

    -- Add mana check

    local ammo = ammo or "arrow"
    local ammo_type = AutoFletch.NextSpecialFletch

    if (not tier and StatTable.Level == 125) or tier == "lord" then
        if ammo_type == "Sableroix" or ammo_type == "explosive" then
            ammo_type = "lordly " .. ammo_type
        end
    end

    local success_pattern = "Your efforts produced (\\d+) " .. ammo_type .. " " .. ammo
    
    
    safeTempTrigger("AutoFletch.SpecialSuccess", success_pattern, function()
        print("Success Pattern called on " .. ammo_type .. " " .. ammo)
        if AutoFletch.ExhaustTable[char_name][AutoFletch.NextSpecialFletch].qty == 0 then 
            AutoFletch.ExhaustTable[char_name][AutoFletch.NextSpecialFletch].time = os.time()
            local next_fletch = AutoFletch.NextSpecialFletch
            safeTempTimer("AutoFletch.Reset" .. char_name .. next_fletch, 60 * 50, function() 
                AutoFletch.ExhaustTable[char_name][next_fletch].qty = 0
                AutoFletch.ExhaustTable[char_name][next_fletch].time = 0
            end)
        end
        AutoFletch.ExhaustTable[char_name][AutoFletch.NextSpecialFletch].qty = AutoFletch.ExhaustTable[char_name][AutoFletch.NextSpecialFletch].qty + 1
        AutoFletch.ExhaustTable[char_name][AutoFletch.NextSpecialFletch].amount = AutoFletch.ExhaustTable[char_name][AutoFletch.NextSpecialFletch].amount + 1
        tempTimer(0, function() AutoFletch.SpecialAmmo(char_name, ammo, tier) end)
    end, "regex", 1)
    
    safeTempTrigger("AutoFletch.SpecialFail", "You fail to produce anything worth shooting.", function() tempTimer(0, function() AutoFletch.SpecialAmmo(char_name, ammo, tier) end) end, "begin", 1)

    --local lag = tonumber(gmcp.Char.Vitals.lag) or 0
    print("got to AutoFletch.FletchAmmo", ammo, ammo_type)
    
    if AutoFletch.AntiSpam < 10 then
      send("fletch '" .. ammo .. "' '" .. ammo_type .. "'", true)
      AutoFletch.AntiSpam = AutoFletch.AntiSpam + 1
    else
      send("fletch '" .. ammo .. "' '" .. ammo_type .. "'" ..  getCommandSeparator() .. "inv", true)
      AutoFletch.AntiSpam = 0
    end
    --safeTempTimer("AutoFletch.SendFletchCmd", lag, function() AutoFletch.FletchAmmo(ammo, ammo_type) end)

end

function AutoFletch.SpecialAmmoInit(ammo, tier)
    if (AutoFletch.Status == true) then
        printMessage("AutoFletch", "Error, already running.")
        return
    end
    
    if StatTable.Position == "Sleep" then send("stand") end

    if IsNotClass({"Archer", "Assassin", "Fusilier"}) then
        printMessage("AutoFletch", "You are not an Archer, Assassin, or Fusilier -- cannot fletch special ammo.")
        return
    end

    local char_name = StatTable.CharName -- will do something more clever later
    local tier = tier or "lord" -- will do something more clever later
    local ammo = ammo or "arrow"
    AutoFletch.AntiSpam = 0

    safeTempTrigger("AutoFletch.SpecialNoFletch", "You are not carrying a fletch.", function() AutoFletch.SpecialAmmoCleanUp() end, "begin", 1)
    safeTempTrigger("AutoFletch.SpecialFletchNotEquipped", "You lack the proper tools.", function() send("wear fletch", true); AutoFletch.SpecialAmmo(char_name, ammo, tier)  end, "begin")
    safeTempTrigger("AutoFletch.SpecialOutOfFletch", "You discard your empty toolkit.", function() send("wear fletch", true); AutoFletch.SpecialAmmo(char_name, ammo, tier)  end, "begin")
    safeTempTrigger("AutoFletch.OutOfMana", "You don't have enough mana to make .* arrows.", function() AutoFletch.OutOfMana(char_name, ammo, tier) end, "regex")
    safeTempTrigger("AutoFletch.HigherLevelToolkit", "You will need a higher level toolkit", function() printMessage("AutoFletch", "Error, please use an appropriate level toolkit"); AutoFletch.SpecialAmmoCleanUp() end, "begin", 1)
    safeTempTrigger("AutoFletch.NoSkill", "^You do not know how to make (.*) (arrows|bolts|sling stones|darts).$", function() 
      for index, arrow in ipairs(ArrowTable) do
        if arrow == matches[2] then table.remove(ArrowTable, index); 
        AutoFletch.SpecialAmmo(char_name, ammo, tier)
        return; end
      end
      printMessage("AutoFletch", "Error, not expected to get here. Couldn't find arrow type to remove from ArrowTable")
      AutoFletch.SpecialAmmoCleanUp()
    end, "regex")
    
    send("config -savespell", false)
    AutoFletch.Status = true
    AutoFletch.NextSpecialFletch = "Sableroix"
    AutoFletch.SetArrowTypesTable()
    AutoFletch.SetUpExhaustTable(char_name)
    AutoFletch.SpecialAmmo(char_name, ammo, tier)

end

function AutoFletch.SpecialAmmoReset()
    AutoFletch.Status = false
    AutoFletch.NextSpecialFletch = nil
    AutoFletch.AntiSpam = 0

    -- Kill all Triggers
    safeKillTrigger("AutoFletch.SpecialFail")
    safeKillTrigger("AutoFletch.SpecialSuccess")
    safeKillTrigger("AutoFletch.SpecialNoFletch")
    safeKillTrigger("AutoFletch.SpecialFletchNotEquipped")
    safeKillTrigger("AutoFletch.SpecialOutOfFletch")
    safeKillTrigger("AutoFletch.OutOfMana")
    safeKillTrigger("AutoFletch.HigherLevelToolkit")
    safeKillTrigger("AutoFletch.NoSkill")

    -- Kill all Timers (except cooldown timers)
    safeKillTimer("AutoFletch.SendFletchCmd")
    safeKillTimer("AutoFletch.Restart")
    
    -- Kill all Event handlers
    safeKillEventHandler("AutoFletch.KillRestartOnQuit")
    
    
    send("remove fletch")
end

function AutoFletch.SpecialAmmoCleanUp() -- depreciated
  AutoFletch.SpecialAmmoReset()
end

function AutoFletch.OutOfMana(char_name, ammo, tier)
  if StatTable.Position ~= "Sleep" then
    send("sleep")
  end
  
  coroutine.wrap(function()
  
    repeat
      wait(10)
    until StatTable.current_mana == StatTable.max_mana
  
    send("stand")
    
    if AutoFletch.Status then 
      AutoFletch.SpecialAmmo(char_name, ammo, tier)
    end
  end)()
end


function AutoFletch.SetArrowTypesTable()

    local class = StatTable.Class
    local level = StatTable.Level
    local sublevel = StatTable.SubLevel


    -- Initialize ArrowTable as an empty table
    ArrowTable = {}
    
    if class == "Archer" then
        if level == 125 or (level == 51 and sublevel >= 200) then
            table.insert(ArrowTable, "Sableroix")
        end
        if level == 125 or (level == 51 and sublevel >= 250) then
            table.insert(ArrowTable, "explosive")
        end
        if level == 125 and sublevel >= 100 then
            table.insert(ArrowTable, "glass")
        end
        if level == 125 and sublevel >= 150 then
            table.insert(ArrowTable, "ebony")
        end
    elseif class == "Assassin" then
        if level == 125 or (level == 51 and sublevel >= 200) then
            table.insert(ArrowTable, "Sableroix")
        end
        if level == 125 and sublevel >= 150 then
            table.insert(ArrowTable, "glass")
        end
        --if level == 125 and sublevel >= 200 then
        --    table.insert(ArrowTable, "terror")
        --end
    elseif class == "Fusilier" then
        if level == 125 or (level == 51 and sublevel >= 250) then
            table.insert(ArrowTable, "explosive")
        end
        if level == 125 and sublevel >= 150 then
            table.insert(ArrowTable, "ebony")
        end
    end
end

function AutoFletch.ReportSpecialAmmo()
    for char_name, ammo_table in pairs(AutoFletch.ExhaustTable) do
        for ammo_type, ammo_data in pairs(ammo_table) do
            if ammo_data.qty > 0 then
                printMessage("AutoFletch", char_name .. " has crafted " .. ammo_data.qty .. " " .. ammo_type .. " arrows.")
                if ammo_data.time > 0 and (60 * 50 - (os.time() - ammo_data.time)) > 0 then
                    printMessage("AutoFletch", "The next " .. ammo_type .. " ammo for " .. char_name .. " will be available in " .. (60 * 50 - (os.time() - ammo_data.time)) .. " seconds.")
                end
            end
        end
    end
end
