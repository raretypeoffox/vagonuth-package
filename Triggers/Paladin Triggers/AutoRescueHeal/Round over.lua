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
