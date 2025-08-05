-- Script: Battle Tracker
-- Attribute: isActive

-- Script Code:
BattleTracker = BattleTracker or {}
BattleTracker.MobHealth = BattleTracker.MobHealth or ""

function BattleTracker.UpdateMobAttackTable()
  local initmsg = "\nGroupies being aggied:\n"
  local msg = initmsg
  local mobcount = 0
  local rescuetarget = ""
  local rescuehp_pct = 0
  
  
  local tblmsg = {}

  for k,v in pairs(GroupiesUnderAttack) do
    table.insert(tblmsg,{v, k}) 
    msg = msg .. k .. " : " .. v .. " mob(s) attacking them\n" 
    mobcount = mobcount + v
    rescuetarget = k
  end

  if (GlobalVar.GUI) then
    BattleTracker.UpdateGUI(tblmsg)
  else
    if msg ~= initmsg then echo(msg) end
  end
  
  BattleTracker.TryRescue(mobcount, rescuetarget)
    
end


function BattleTracker.RoundOver()
  BattleTracker.UpdateMobAttackTable()
  GroupiesUnderAttack = {}
end

function BattleTracker.TryRescue(mobcount, rescuetarget)
  local my_char_name = firstToUpper(string.lower(StatTable.CharName))
    -- rescue paladin script
    
  if not GlobalVar.PaladinRescue then return end
  
  if (mobcount>0) and StatTable.Class == "Paladin" and (StatTable.JoinedBoon or StatTable.SharedBoon) and tonumber(gmcp.Char.Vitals.lag) <= 2 and (StatTable.current_health / StatTable.max_health) > 0.50 and StatTable.Sanctuary then  

    rescuehp_pct = GlobalVar.GroupMates[rescuetarget].hp / GlobalVar.GroupMates[rescuetarget].maxhp
    
    if (mobcount == 1 and BattleTracker.MobHealth == "is in awful condition." and rescuetarget ~= my_char_name and rescuehp_pct < 1 and GlobalVar.GroupMates[rescuetarget].class ~= "Pal") then TryAction("r " .. rescuetarget,2) end
    -- for easier runs, uncomment below
    if (StatTable.Level <= 51 and mobcount == 1 and BattleTracker.MobHealth == "looks pretty hurt." and rescuetarget ~= my_char_name and rescuehp_pct < 1 and GlobalVar.GroupMates[rescuetarget].class ~= "Pal") then TryAction("r " .. rescuetarget,2) end
    -- Trial run on self healing paladins
    if StatTable.Level == 125 and ((StatTable.current_health / StatTable.max_health) < 0.6 and (StatTable.current_mana / StatTable.max_mana) > 0.5) then TryCast("cast div",10) end
  end 
end

-- think we can remove this and the commented lines below but test first
--function CallbackSend(arg)
--  send(arg)
--end

function BattleTracker.UpdateGUI(tblmsg)
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
      --if (tblmsg[3][2]~=my_char_name) then Victim3Label:setClickCallback("CallbackSend","rescue " .. tblmsg[3][2]) end
      if (tblmsg[3][2]~=my_char_name) then Victim3Label:setClickCallback(function() send("r " .. tblmsg[3][2]) end) end
    end
    
    if (#tblmsg > 1) then
      Victim2Label:echo("<left>" .. firstToUpper(tblmsg[2][2]) .. ": " .. tblmsg[2][1] .. " mob(s) attacking</left>")
      Victim2Label:show()
      --if (tblmsg[2][2]~=my_char_name) then Victim2Label:setClickCallback("CallbackSend","r " .. tblmsg[2][2]) end
      if (tblmsg[2][2]~=my_char_name) then Victim2Label:setClickCallback(function() send("r " .. tblmsg[2][2]) end) end
    end
    
    Victim1Label:echo("<left>" .. firstToUpper(tblmsg[1][2]) .. ": " .. tblmsg[1][1] .. " mob(s) attacking</left>")
    Victim1Label:show()
    --if (tblmsg[1][2]~=my_char_name) then Victim1Label:setClickCallback("CallbackSend","r " .. tblmsg[1][2]) end
    if (tblmsg[1][2]~=my_char_name) then Victim1Label:setClickCallback(function() send("r " .. tblmsg[1][2]) end) end
  end

end


