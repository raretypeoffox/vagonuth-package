-- Script: Group Update
-- Attribute: isActive

-- Script Code:
-------------------------------------------------
-- Group GUI Update Script   
-- Updates all the groupmate info in the group container
-------------------------------------------------

local SmallScreen = true

-- called on update to GMCP_Group()
function UpdateGroupGUI(GroupieTableIndex, Player)
  if AR.Status then
      GroupieTable[GroupieTableIndex].NameLabel:echo("<left>" .. (AR.RescueList[string.lower(Player.name)] and "<b><span style='color: rgb(10,126,242)'>*</span></b>" or "<span style='color: rgb(0,0,0)'>*</span>") .. (Player.leader and "<b><left><span style='color: rgb(255,0,0)'>"..Player.name.."</span></b>" or Player.name) .. "</left>")
  else
      GroupieTable[GroupieTableIndex].NameLabel:echo("<left>" .. (AR.RescueList[string.lower(Player.name)] and "<b><span style='color: rgb(125,125,125)'>*</span></b>" or "<span style='color: rgb(0,0,0)'>*</span>") .. (Player.leader and "<b><left><span style='color: rgb(255,0,0)'>"..Player.name.."</span></b>" or Player.name) .. "</left>")
  end
  GroupieTable[GroupieTableIndex].NameLabel:setClickCallback(function() send("r " .. Player.name) end)
  GroupieTable[GroupieTableIndex].InfoLabel:echo(SmallScreen and "<center>" .. Player.class .. "</center>" or "<left>" .. Player.race .. "-" .. Player.class .. "</left>")
  GroupieTable[GroupieTableIndex].InfoLabel:setClickCallback(function() OnMobDeathQueue("monitor " .. Player.name) end)

  local PosistionLabelEcho = ""
  if Player.position == "Busy" or Player.position == "STUN" then
      PosistionLabelEcho = "<span style='color: rgb(128,0,128)'>"
  elseif Player.position == "Rest" then
      PosistionLabelEcho = "<span style='color: rgb(0,255,0)'>"
  elseif Player.position == "Fight" then
      PosistionLabelEcho = "<span style='color: rgb(255,0,0)'>"
  elseif Player.position == "Stand" then
      PosistionLabelEcho = "<span style='color: rgb(0,255,0)'>"
  end
  
  PosistionLabelEcho = PosistionLabelEcho .. (SmallScreen and string.sub(Player.position, 1, 3) or Player.position)
  GroupieTable[GroupieTableIndex].PositionLabel:echo("<right>" .. PosistionLabelEcho .. "</right>")
 
  local PlayerMaxHP = tonumber(Player.maxhp)
  local PlayerHP = math.min(tonumber(Player.hp), PlayerMaxHP)

  GroupieTable[GroupieTableIndex].HPBar:setValue(PlayerHP, PlayerMaxHP,"<center><font-size ='4px'><span style='color: rgb(0,0,0)'>".. Player.hp .. (SmallScreen and "" or "/" .. PlayerMaxHP) .. "</center>")
  local HPBar_HealSpell = StatTable.Level == 125 and "cast comfort " .. Player.name or "cast divinity ".. Player.name
  GroupieTable[GroupieTableIndex].HPMaskLabel:setClickCallback(function() send(HPBar_HealSpell) end)
  
  local PlayerMaxMana = tonumber(Player.maxmp)
  local PlayerMana = math.min(tonumber(Player.mp), PlayerMaxMana)    
      
  if(PlayerMaxMana == nil or PlayerMaxMana == 0) then
    GroupieTable[GroupieTableIndex].ManaBar:setValue(1,1,"<center><font-size ='5px'>No MP</center>")
  else
    GroupieTable[GroupieTableIndex].ManaBar:setValue(PlayerMana,PlayerMaxMana,"<center><font-size ='4px'><span style='color: rgb(0,0,0)'>".. Player.mp .. (SmallScreen and "" or "/" .. PlayerMaxMana) .. "</center>")
  end

  if (Player.class == "Sor" or Player.class == "Mag" or Player.class == "Wzd" or Player.class == "Psi" or Player.class == "Mnd" or Player.class == "Stm") then
      GroupieTable[GroupieTableIndex].ManaBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc);]])
  elseif (Player.class == "Prs" or Player.class == "Cle" or Player.class == "Dru" or Player.class == "Pal" or Player.class == "Viz") then
      GroupieTable[GroupieTableIndex].ManaBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffff66, stop: 0.3 #ffff00, stop: 1 #ff9900);]])           
  else
      GroupieTable[GroupieTableIndex].ManaBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3399ff, stop: 0.1 #3399ff, stop: 0.49 #92c7fc, stop: 0.5 #178bff, stop: 1 #17aaff);]])
  end

  GroupieTable[GroupieTableIndex]:show()
end