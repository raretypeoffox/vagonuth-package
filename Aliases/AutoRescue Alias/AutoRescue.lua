-- Alias: AutoRescue
-- Attribute: isActive

-- Pattern: ^(?i)ar(?: (on|off|add|all|auto|echo|mon|small|remove|show|clear)? ?(.*?))?$

-- Script Code:
cmd = (matches[2] and string.lower(matches[2]) or "")
args = matches[3] or ""

if cmd == "on" then
  AR.On()
elseif cmd == "off" then
  AR.Off()
elseif cmd == "add" then
  if args == nil or args == "" then
    printMessage("AutoRescue", "error, need to specify who to add\n")
  else
    AR.Add(args)
  end
elseif cmd == "all" then
  AR.All()
elseif cmd == "auto" then  
  AR.Auto()
elseif cmd == "echo" then
  AR.Echo = not AR.Echo
  printMessage("AutoRescue", "Echo is turned " .. (AR.Echo and "ON - there will be no gtells" or "OFF - info will be sent via gtell"))
elseif cmd == "mon" then
  if StatTable.Monitor == "" then
    printMessage("AutoRescue Error", "Monitor not set, please monitor someone first")
    return
  end
  if matches[3] == "" then
    if not AR.MonitorRescue then
      printMessage("AutoRescue", "Monitor Rescue On! Will rescue " .. StatTable.Monitor .. " at " .. (AR.MontorRescueHPpct * 100) .. "%")
      AR.MonitorRescue = true
    else
      printMessage("AutoRescue", "Monitor Rescue Off!")
      AR.MonitorRescue = false
    end
  elseif tonumber(args) and tonumber(args) > 0 and tonumber(args) < 100 then
    AR.MontorRescueHPpct = (tonumber(args) / 100)
    printMessage("AutoRescue", "Monitor Rescue HP % target set to " .. (AR.MontorRescueHPpct * 100) .. "%")
  end
    
elseif cmd == "small" then
  if matches[3] == "" then
    AR.Small(2000)
  else
    AR.Small(tonumber(args))
  end
elseif cmd == "remove" then
  if args == nil or args == "" then
    printMessage("AutoRescue", "error, need to specify who to remove\n")
  elseif AR.RescueList[string.lower(args)] then
    AR.Remove(args)
  else
    printMessage("AutoRescue", args .. " not on rescue list\n")
  end
elseif cmd == "show" then
	AR.Show()
elseif cmd == "clear" then
	AR.Clear()
else
  showCmdSyntax("AutoRescue\n\tSyntax: ar <cmd> <optional arg>", {
    {"ar (on|off)", "turns on or off autorescue"},
    {"ar add <name>", "adds player <name> to the rescue list"},
    {"ar remove <name>", "removes player <name> from the rescue list"},
    {"ar all", "adds all players to the autorescue list"},
    {"ar small <hp>", "adds all players with max hit points less than <hp> to rescue list"},
    {"ar auto", "adds all except tanks/blds/pals - useful for lord runs"},
    {"ar mon", "turns on/off one time rescue of your monitor (for gear rooms)"},
    {"ar mon <hp_pct>", "sets the HP pct to rescue the monitor target (currently " .. (AR.MontorRescueHPpct * 100) .. "%)"},
    {"ar echo", "turns on/off echo mode (echo mode will not gtell)"},
    {"ar show", "gtells / echos the autorescue list"},
    {"ar clear", "clears the autorescue list"}
    })
end
AR.print_status()