-- Trigger: Natural Fletch Kit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) tells you 'fletch kit'
-- 1 (regex): ^You dream of (\w+) telling you 'fletch kit'
-- 2 (regex): ^(\w+) tells you 'fletch kit (\d+)'
-- 3 (regex): ^You dream of (\w+) telling you 'fletch kit (\d+)'

-- Script Code:
if(matches[2] == "someone") then
  send("wake")
  send("c 'holy sight")
  send("sle")
  send("reply My holy sight was down, please request again.")
end
StatTable.forage_kits = 0
cecho("Step 1 fired.")
enableTrigger("Found Kit")
enableTrigger("Forage")
if tonumber(matches[3]) > 3 then
  cecho("Step 2a fired")
  StatTable.number_kits = 3
  send("tell " .. matches[2] .. " I can do up to three kits at a time so that is what I will do.")
else
  cecho("Step 2b fired.")
  StatTable.number_kits = matches[3]
end
if matches[3] == nil or matches[3] == "1" then
  StatTable.number_kits = 1
end
StatTable.kit_requestor = matches[2]
if (gmcp.Char.Status.room_name == "AVATAR's Sanctum Infirmary") then
  cecho("Step 3a Fired.")
  send("wake")
  send("c teleport nom")
  send("forage")  
elseif (gmcp.Char.Status.room_name == "An arch of water") then
  cecho("Step 3b Fired.")
  send("wake")
  send("w")
  send("w")
  send("s")
  send("s")
  send("s")
  send("s")
  send("s")
  send("s")
  send("s")
  send("s")
  send("s")
  send("e")
  send("forage")
elseif not (gmcp.Char.Status.room_name == "AVATAR's Sanctum Infirmary") or not (gmcp.Char.Status.room_name == "An arch of water") then
  cecho("Step 4 Fired.")
  send("t " .. matches[2] .. " I'm sorry, I need to be in the Sanctum Infirmary or An Arch of Water for you to request fletching kits.")
end