-- Trigger: Round over 


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
local rescuehp_pct = 0
local my_char_name = firstToUpper(string.lower(StatTable.CharName))

local tblmsg = {}

function CallbackSend(arg)
  send(arg)
end

for k,v in pairs(GroupiesUnderAttack) do
  table.insert(tblmsg,{v, k}) 
  msg = msg .. k .. " : " .. v .. " mob(s) attacking them\n" 
  mobcount = mobcount + v
  rescuetarget = k
end

if (GlobalVar.GUI) then
  
  
  if (#tblmsg>0) then
    Victim1Label:hide()
    Victim2Label:hide()
    Victim3Label:hide()
    Victim1Label:setClickCallback("")
    Victim2Label:setClickCallback("")
    Victim3Label:setClickCallback("")
    
    
    if (#tblmsg>1) then table.sort(tblmsg,rcompare) end
    
    if (#tblmsg > 2) then
      Victim3Label:echo("<left>" .. firstToUpper(tblmsg[3][2]) .. ": " .. tblmsg[3][1] .. " mob(s) attacking</left>")
      Victim3Label:show()
      if (tblmsg[3][2]~=my_char_name) then Victim3Label:setClickCallback("CallbackSend","r " .. tblmsg[3][2]) end
    end
    
    if (#tblmsg > 1) then
      Victim2Label:echo("<left>" .. firstToUpper(tblmsg[2][2]) .. ": " .. tblmsg[2][1] .. " mob(s) attacking</left>")
      Victim2Label:show()
      if (tblmsg[2][2]~=my_char_name) then Victim2Label:setClickCallback("CallbackSend","r " .. tblmsg[2][2]) end
    end
    
    Victim1Label:echo("<left>" .. firstToUpper(tblmsg[1][2]) .. ": " .. tblmsg[1][1] .. " mob(s) attacking</left>")
    Victim1Label:show()
    if (tblmsg[1][2]~=my_char_name) then Victim1Label:setClickCallback("CallbackSend","r " .. tblmsg[1][2]) end
  end
  
 
  
  if (#tblmsg>0) and StatTable.Class == "Paladin" and (StatTable.JoinedBoon or StatTable.SharedBoon) and tonumber(gmcp.Char.Vitals.lag) <= 2 and (StatTable.current_health / StatTable.max_health) > 0.50 then  
  --echo(msg)
    -- need to fix and StatTable.Oath == "evolution"
    rescuehp_pct = GlobalVar.GroupMates[rescuetarget].hp / GlobalVar.GroupMates[rescuetarget].maxhp
    
    if (mobcount == 1 and matches[1] == "is in awful condition." and rescuetarget ~= my_char_name and rescuehp_pct < 1) then TryAction("r " .. rescuetarget,2) end
    -- for easier runs, uncomment below
    if (mobcount == 1 and matches[1] == "looks pretty hurt." and rescuetarget ~= my_char_name and rescuehp_pct < 1) then TryAction("r " .. rescuetarget,2) end
    --
  end  
  
  
else
  if msg ~= initmsg then
    echo(msg) 
    -- need to fix for lord (only one of the two oaths show up in gmcp) StatTable.Oath == "evolution"
    if (StatTable.Class == "Paladin" and mobcount == 1 and matches[1] == "is in awful condition." and tonumber(gmcp.Char.Vitals.lag) <= 2 and rescuetarget ~= my_char_name and (StatTable.JoinedBoon > 0 or StatTable.Level == 125)) then send("r " .. rescuetarget) end
  end
end

GroupiesUnderAttack = {}


