-- Trigger: DamageLabel 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.*'s .* strikes .* with (?<dmgdesc>.*) \w+[!.]
-- 1 (regex): ^.*'s attacks? strikes? .* \d+ times?, with (?<dmgdesc>.*) \w+[!.]
-- 2 (regex): ^Your attacks? strikes? .* \d+ times?, with (?<dmgdesc>.*) \w+[!.]
-- 3 (regex): ^Your shot hits .* with (?<dmgdesc>.*) \w+[!.]
-- 4 (regex): ^You \w+ .* with (?<dmgdesc>.*) \w+[!.]
-- 5 (regex): ^.*'s .* hits .* with (?<dmgdesc>.*) \w+[!.]

-- Script Code:
if matches.dmgdesc == "terminal" or matches.dmgdesc == "your" then return end

if not DamageVerbTable[matches.dmgdesc] then 
  if Battle.Combat then 
    printMessage("DamageLabel Error", "Unknown verb: " .. matches.dmgdesc) 
  end
  return
end

local low_num = DamageVerbTable[matches.dmgdesc][1]
local high_num = DamageVerbTable[matches.dmgdesc][2]
local num_colour = DamageVerbTable[matches.dmgdesc][3]


cecho (string.rep (" ",85-tonumber(string.len(line))) .."<"..num_colour.."> ["..low_num.." - "..high_num.."]")