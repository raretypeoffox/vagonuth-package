if matches.dmgdesc == "terminal" or matches.dmgdesc == "your" then return end
if matches[0] == "You wield sharp folder with a bunch of arcane scrolls." then return end


if not DamageVerbTable[matches.dmgdesc] then 
  if Battle.Combat and GlobalVar.Debug then 
    printMessage("DamageLabel Error", "Unknown verb: " .. matches.dmgdesc) 
  end
  return
end

local low_num = DamageVerbTable[matches.dmgdesc][1]
local high_num = DamageVerbTable[matches.dmgdesc][2]
local num_colour = DamageVerbTable[matches.dmgdesc][3]


cecho (string.rep (" ",85-tonumber(string.len(line))) .."<"..num_colour.."> ["..low_num.." - "..high_num.."]")