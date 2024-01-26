-- Alias: MobList
-- Attribute: isActive

-- Pattern: ^(?i)mob(zone|set|list|spec)\b\s*(.*)$

-- Script Code:
local cmd = string.lower(matches[2])
local args = matches[3]

if cmd == "zone" then
  if args == "" then
    print("MobZone: no argument provided, setting to current zone")
    SetMobListZone(gmcp.Room.Info.zone)
  else
    SetMobListZone(args)
  end
elseif cmd == "set" then
  if args == "" then
    if (MobListCoroutine == nil) then
      cecho("<white>MobSet:<ansi_white> Ready! Please type 'mobset <mob_keyword>' for each mob name given\n")
      cecho("<white>MobSet:<ansi_white> If you don't know the keyword, just type 'mobset' with no argument and it'll skip\n")
      MobListCoroutine = coroutine.create(SetMobList)
      coroutine.resume(MobListCoroutine)
      tempTimer(60, function() MobListCoroutine = nil end)
    else
      cecho("<white>MobSet:<ansi_white> Mob skipped\n")
      MobListSetKeyword = "keyword"
      if not coroutine.resume(MobListCoroutine) then MobListCoroutine = nil end
    end
  else
    if (MobListCoroutine == nil) then
      cecho("<white>MobSet:<ansi_white> Error: mobset not ready, please start with 'mobset'\n")
    else
      MobListSetKeyword = args
      cecho("<white>MobSet:<ansi_white> Mob keyword set to " .. MobListSetKeyword .. "\n")
      if not coroutine.resume(MobListCoroutine) then MobListCoroutine = nil end
    end   
  end
  
elseif cmd == "list" then
  MobListDisplay(gmcp.Room.Info.zone)
elseif cmd == "spec" then
  MobListDisplaySpec(gmcp.Room.Info.zone)
else
  error("MobList Alias: shouldn't be reached")
end