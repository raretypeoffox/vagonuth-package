-- Trigger: Generic PSI weapon 


-- Trigger Patterns:
-- 0 (regex): ^(.*) clatters to the ground!$
-- 1 (regex): ^You get (.*) from corpse of
-- 2 (regex): ^(.*) falls to the ground, lifeless.

-- Script Code:
local PSIWeapon = {
["CLICK CLICK"] = {keyword = "calpchak", charname = "claap"},
["a holy noodle of R'amen"] = {keyword = "noodle", charname = "rawil"},
["a spear shaped bucatini"] = {keyword = "bucatini", charname = "rawil"},
["TICKLE FIGHT"] = {keyword = "hitt", charname = "ramahdon"},
["Sith Inquisitor"] = {keyword = "sith", charname = "flood"},
["Green Destiny"] = {keyword = "destiny", charname = "fango"},
["Trained Attack Sprite"] = {keyword = "sprite", charname = "chronos"},
["Sludge's fiery wield"] = {keyword = "sludge", charname = "sludge"},
["a saber of pure light"] = {keyword = "ky", charname = "kylise"},
["A winged angel"] = {keyword = "wing", charname = "photon"},
["Xanur's Murasame"] = {keyword = "xanur", charname = "xanur"},
["Glitch"] = {keyword = "glitch", charname = "glitch"},
["Kiss of the Dragkhar"] = {keyword = "meista", charname = "aginor"},
["Excelsior V"] = {keyword = "ex", charname = "volarys"},
[" Pain"] = {keyword = "pain", charname = "Asha"},
[" Fear"] = {keyword = "fear", charname = "Asha"},
}

local wpn = matches[2]

if PSIWeapon[wpn] then
  send("get all." .. PSIWeapon[wpn].keyword)
  if PSIWeapon[wpn].charname ~= string.lower(StatTable.CharName) then
    send("give all." .. PSIWeapon[wpn].keyword .. " " .. PSIWeapon[wpn].charname)
  else
    send("wield all." .. PSIWeapon[wpn].keyword)
  end
end

--Volarys's weapon: 'Excelsior V' keyword(s): excelsior, exantus