-- Trigger: Round over 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): is in excellent condition.
-- 1 (substring): has a few scratches.
-- 2 (substring): has some small wounds and bruises.
-- 3 (substring): has quite a few wounds.
-- 4 (substring): has some big nasty wounds and scratches.
-- 5 (substring): looks pretty hurt.
-- 6 (substring): is in awful condition.
-- 7 (substring): is DEAD!!

-- Script Code:
local initmsg = "\nGroupies being aggied:\n"
local msg = initmsg
local mobcount = 0
local rescuetarget = ""

for k,v in pairs(GroupiesUnderAttack) do 
  msg = msg .. k .. " : " .. v .. " mob(s) attacking them\n" 
  mobcount = mobcount + v
  rescuetarget = k
end

if msg ~= initmsg then 
  echo(msg) 
  if (mobcount == 1 and matches[1] == "is in awful condition." and StatTable.Oath == "evolution") then send("rescue " .. rescuetarget) end
end


GroupiesUnderAttack = {}
