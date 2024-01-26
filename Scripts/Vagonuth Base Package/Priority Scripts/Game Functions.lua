-- Script: Game Functions
-- Attribute: isActive

-- Script Code:
function beep()
  if GlobalVar.Silent then return end
  playSoundFile({name = getMudletHomeDir().. "/Vagonuth-Package/beep.wav"})
end

function QuickBeep()
  if GlobalVar.Silent then return end
  playSoundFile({name = getMudletHomeDir().. "/Vagonuth-Package/quickbeep.wav"})
end

function VictoryBeep()
  if GlobalVar.Silent then return end
  playSoundFile({name = getMudletHomeDir().. "/Vagonuth-Package/victorybeep.mp3", volume = 75})
end


function IsGroupMate(groupie_name) 
  groupie_name = GMCP_name(groupie_name)

  for k,v in ipairs(gmcp.Char.Group.List) do
      v.name = RemoveColourCodes(v.name)
      v.name = GMCP_name(v.name)
      if (v.name == groupie_name) then
        return true -- return TRUE if group_name is a player in our group
      end
  end

  return false -- return FALSE is groupie_name is not a player in our group OR he's invis and we can't detect them
end

-- Grouped() - returns true if grouped, otherwise false 
function Grouped()
  return (TableSize(GlobalVar.GroupMates) > 1)
end

-- GroupLeader() - returns true if you are the group leader, otherwise false
function GroupLeader()
  return (GlobalVar.GroupLeader == StatTable.CharName)
end

-- IsGroupLeader(groupie_name) - returns true if "groupie_name" is the the group leader, otherwise false
function IsGroupLeader(groupie_name)
  groupie_name = GMCP_name(groupie_name)
  if groupie_name == "Someone" then return false end
  if groupie_name == GlobalVar.GroupLeader then return true else return false end
end

-- Returns how many in group
function GroupSize()
  return TableSize(GlobalVar.GroupMates)
end

-- SafeArea() -- returns true if Sanctum or Thorngate
function SafeArea()
  if (gmcp.Room.Info.zone == "{ ALL  } AVATAR  Sanctum" or 
      gmcp.Room.Info.zone == "{ LORD } Dev     Rietta's Wonders" or 
      gmcp.Room.Info.zone == "{ LORD } Crom    Thorngate" or
      gmcp.Room.Info.zone == "{ LORD } Vorak   Lord Mud School" or
      gmcp.Room.Info.zone == "{ LORD } Crom    The House of Bandu") then
    return true
  else
    return false
  end
end

-- While at sanc,d,w or thorn 2e, asks the known bots there for heals based on missing hp
function AskBotsForHeals()
  local healspell
  local healaugment = 4
  local missinghp = (StatTable.max_health - StatTable.current_health)
  local healmultiple = 1
  
  assert(missinghp >= 0, "AskBotsforHeals() Error: missinghp not a positive integer")

  if (gmcp.Room.Info.zone == "{ ALL  } AVATAR  Sanctum") then
    healspell = "div"
  elseif (gmcp.Room.Info.zone == "{ LORD } Dev     Rietta's Wonders") then
    healspell = "comf"
    healmultiple = 2 -- comf provides twice the hp as div (i.e. 500hp, instead of 250hp)
  else
    print("AskBotsForHeals() Error: not in sanc or thorn 2e")
    return false
  end
  
  -- Only ask for div4 (comf4) if missing 1000hp (2000hp), otherwise save the bots some mana and ask for a smaller heal
  if missinghp < (1000 * healmultiple) then
    if missinghp == 0 then
      return true
    elseif missinghp < (250 * healmultiple) then
      healaugment = ""
    elseif missinghp < (500 * healmultiple) then
      healaugment = 2
    else
      healaugment = 3
    end
  end
  
  if gmcp.Room.Players["Yorrick"] then send("tell yorrick " .. healspell .. healaugment) end
  if gmcp.Room.Players["Martyr"] then send("tell martyr " .. healspell .. healaugment) end
  if gmcp.Room.Players["Idle"] then send("tell idle " .. healspell .. healaugment) end
  if gmcp.Room.Players["Eiri"] then send("tell eiri " .. healspell .. healaugment) end
  if gmcp.Room.Players["Arby"] then send("tell arby ".. healspell) end
  if gmcp.Room.Players["Viridi"] then send("tell viridi " .. healspell .. healaugment) end  
  --if gmcp.Room.Players["Juevo"] then send("tell juevo " .. healspell .. healaugment) end
  if gmcp.Room.Players["FlutterFly"] then send("tell flutterfly " .. healspell .. healaugment) end
  if gmcp.Room.Players["Gobo"] then send("tell gobo " .. healspell .. healaugment) end
  return true

end

-- Cleans up the mobname you receive from gmcp.Room.Players[].fullname to remove auras/white spaces
function Clean_MobName(mobname)
    -- Strip brackets, first for single words, second for double words (eg White Aura), likely a better way to do this
    mobname = string.gsub(mobname,"%((%a+)%)","")
    mobname = string.gsub(mobname,"%((%a+ %a+)%)","")
    -- Strip leading and trailing white space
    mobname = string.gsub(mobname, '^%s*(.-)%s*$', '%1')
    return mobname
end


function sendbot(bot, command)
  if (gmcp.Room.Players[bot]) then 
    send("tell " .. bot .. " " .. command)
    return true
  else
    return false
  end
end

function BladetranceMax()
  local MyLevel = StatTable.Level
  local MySubLevel = StatTable.SubLevel

  if MyLevel < 51 then return 0 
  elseif MyLevel == 51  then
    if MySubLevel < 675 then return 0
    elseif MySubLevel < 800 then return 2
    else return 3 end
  elseif MyLevel == 125 then
    if MySubLevel < 100 then return 3
    elseif MySubLevel < 300 then return 4
    elseif MySubLevel < 800 then return 5
    else return 8 end
  else return 8 end

  error("BladetranceMax(): shouldn't be reached")
end

function BldDancing()
  if StatTable.BladedanceTimer or StatTable.DervishTimer or StatTable.InspireTimer or StatTable.UnendTimer or StatTable.VeilTimer then
    return true
  else
    return false
  end
end


-- Beginning Speedwalk

walklist = {}
walkdelay = 0

function speedwalktimer()
  send(walklist[1])
  table.remove(walklist, 1)
  if #walklist>0 then
    tempTimer(walkdelay, [[speedwalktimer()]])
  end
end


function speedwalk(dirString, backwards, delay)
  local dirString = dirString:lower()
  walklist      = {}
  walkdelay     = delay
  local reversedir  = {
              n = "s",
              e = "w",
              s = "n",
              w = "e",
              u = "d",
              d = "u",
              }

  if not backwards then
    for count, direction in string.gmatch(dirString, "([0-9]*)([neswud]?t?)") do      -- Edited since AVATAR doesn't have SE, NW, etc., originally was: "([0-9]*)([neswudio][ewnu]?t?)"
        count = (count == "" and 1 or count)
      for i=1, count do
        if delay then walklist[#walklist+1] = direction 
        else if direction ~= "" then send(direction) end
        end
      end
    end
  else
    for direction, count in string.gmatch(dirString:reverse(), "(t?[neswud])([0-9]*)") do     -- See above "(t?[ewnu]?[neswudio])([0-9]*)" 
        count = (count == "" and 1 or count)
      for i=1, count do
        if delay then walklist[#walklist+1] = reversedir[direction]
        else if reversedir[direction] ~= "" then send(reversedir[direction]) end
        end
      end
    end
  end

if walkdelay then speedwalktimer() end

end
-- End speedwalk

function HighlightSelfOnLotto()
  tmpTriggerIDLotto = tmpTriggerIDLotto or nil
  tmpTriggerNameLotto = "LottoSelfHighlight"
  
  if tmpTriggerIDLotto then
    killTrigger(tmpTriggerNameLotto)
    tmpTriggerIDLotto = nil
  end
  
  tmpTriggerIDLotto = tempComplexRegexTrigger(tmpTriggerNameLotto, "^  " .. StatTable.CharName .. "!$", [[]], 0, 0, 0, 0, 0, "yellow", "black", 0, 0, 0, nil)
end

safeEventHandler("HighlightSelfOnLottoID", "CustomProfileInit", "HighlightSelfOnLotto", false)

-- Function to check if StatTable.Class is in the provided list of classes
function IsClass(classList)
    for _, class in ipairs(classList) do
        if StatTable.Class == class then
            return true
        end
    end
    return false
end

-- Function to check if StatTable.Class is not in the provided list of classes
function IsNotClass(classList)
    return not IsClass(classList)
end

