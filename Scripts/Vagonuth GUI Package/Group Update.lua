-- Script: Group Update
-- Attribute: isActive

-- Script Code:
-------------------------------------------------
-- Group GUI Update Script   
-- Updates all the groupmate info in the group container
-------------------------------------------------

local SmallScreen = true
VagoGUI = VagoGUI or {}
VagoGUI.GroupVisibleCount = VagoGUI.GroupVisibleCount or nil

local function guiEcho(label, text)
  if type(VagoGUI.Echo) == "function" then
    VagoGUI.Echo(label, text)
  elseif label then
    label:echo(text)
  end
end

local function guiSetClick(label, key, callback, ...)
  if type(VagoGUI.SetClick) == "function" then
    VagoGUI.SetClick(label, key, callback, ...)
  elseif label then
    label:setClickCallback(callback, ...)
  end
end

local function guiSetGauge(gauge, current, maximum, text)
  if type(VagoGUI.SetGauge) == "function" then
    VagoGUI.SetGauge(gauge, current, maximum, text)
  elseif gauge then
    gauge:setValue(current, maximum, text)
  end
end

local function guiSetStyle(label, style)
  if type(VagoGUI.SetStyle) == "function" then
    VagoGUI.SetStyle(label, style)
  elseif label then
    label:setStyleSheet(style)
  end
end

local function guiShow(widget)
  if type(VagoGUI.Show) == "function" then
    VagoGUI.Show(widget)
  elseif widget then
    widget:show()
  end
end

local function guiHide(widget)
  if type(VagoGUI.Hide) == "function" then
    VagoGUI.Hide(widget)
  elseif widget then
    widget:hide()
  end
end

local function groupGaugeText(value)
  local textSize = math.max(6, (Layout and Layout.DefaultFontSize or 8) - 1)
  return "<center><span style='font-size: " .. textSize .. "pt; color: rgb(0,0,0);'>" .. value .. "</span></center>"
end

-- called on update to GMCP_Group()
function UpdateGroupGUI(GroupieTableIndex, Player)
  if not GroupieTable or not GroupieTable[GroupieTableIndex] then return end

  local groupRow = GroupieTable[GroupieTableIndex]
  local player_name = Player.name
  
  if StatTable.CharName == Player.name then
    player_name = "<left><span style='color: rgb(255,255,255)'>" .. Player.name .. "</span>"
    if Player.leader then player_name = "<b>" .. player_name .. "</b>" end
  elseif Player.leader then
    player_name = "<b><left><span style='color: rgb(255,0,0)'>" .. Player.name .. "</span></b>"
  
  end
  
  if AR.Status then
      guiEcho(groupRow.NameLabel, "<left>" .. (AR.RescueList[string.lower(Player.name)] and "<b><span style='color: rgb(10,126,242)'>*</span></b>" or "<span style='color: rgb(0,0,0)'>*</span>") .. player_name .. "</left>")
  else
      guiEcho(groupRow.NameLabel, "<left>" .. (AR.RescueList[string.lower(Player.name)] and "<b><span style='color: rgb(125,125,125)'>*</span></b>" or "<span style='color: rgb(0,0,0)'>*</span>") .. player_name  .. "</left>")
  end
  
  guiSetClick(groupRow.NameLabel, "rescue:" .. Player.name, function() send("r " .. Player.name) end)
  guiEcho(groupRow.InfoLabel, SmallScreen and "<center>" .. Player.class .. "</center>" or "<left>" .. Player.race .. "-" .. Player.class .. "</left>")
  guiSetClick(groupRow.InfoLabel, "monitor:" .. Player.name, function() OnMobDeathQueue("monitor " .. Player.name) end)

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
  guiEcho(groupRow.PositionLabel, "<right>" .. PosistionLabelEcho .. "</right>")
 
  local PlayerMaxHP = tonumber(Player.maxhp) or 1
  local PlayerHP = math.min(tonumber(Player.hp) or 0, PlayerMaxHP)

  guiSetGauge(groupRow.HPBar, PlayerHP, PlayerMaxHP, groupGaugeText(Player.hp .. (SmallScreen and "" or "/" .. PlayerMaxHP)))
  local HPBar_HealSpell = StatTable.Level == 125 and "cast comfort " .. Player.name or "cast divinity ".. Player.name
  guiSetClick(groupRow.HPMaskLabel, "heal:" .. HPBar_HealSpell, function() send(HPBar_HealSpell) end)
  
  local PlayerMaxMana = tonumber(Player.maxmp)
      
  if(PlayerMaxMana == nil or PlayerMaxMana == 0) then
    guiSetGauge(groupRow.ManaBar, 1, 1, groupGaugeText("No MP"))
  else
    local PlayerMana = math.min(tonumber(Player.mp) or 0, PlayerMaxMana)
    guiSetGauge(groupRow.ManaBar, PlayerMana, PlayerMaxMana, groupGaugeText(Player.mp .. (SmallScreen and "" or "/" .. PlayerMaxMana)))
  end

  if (Player.class == "Sor" or Player.class == "Mag" or Player.class == "Wzd" or Player.class == "Psi" or Player.class == "Mnd" or Player.class == "Stm" or Player.class == "Fyr" or Player.class == "Nec") then
      guiSetStyle(groupRow.ManaBar.front, [[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc);]])
  elseif (Player.class == "Prs" or Player.class == "Cle" or Player.class == "Dru" or Player.class == "Pal" or Player.class == "Viz") then
      guiSetStyle(groupRow.ManaBar.front, [[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffff66, stop: 0.3 #ffff00, stop: 1 #ff9900);]])
  else
      guiSetStyle(groupRow.ManaBar.front, [[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3399ff, stop: 0.1 #3399ff, stop: 0.49 #92c7fc, stop: 0.5 #178bff, stop: 1 #17aaff);]])
  end

  guiShow(groupRow)
end

function RenderGroupGUI(players)
  if not GlobalVar.GUI or not GroupieTable or not players then return false end

  local visibleCount = math.min(#players, StaticVars.MaxGroupLabels)
  for index = 1, visibleCount do
    UpdateGroupGUI(index, players[index])
  end

  local previousVisibleCount = VagoGUI.GroupVisibleCount or StaticVars.MaxGroupLabels
  for index = visibleCount + 1, previousVisibleCount do
    guiHide(GroupieTable[index])
  end

  VagoGUI.GroupVisibleCount = visibleCount
  return true
end

function ScheduleGroupGUIUpdate(players)
  if not GlobalVar.GUI then return false end

  if type(VagoGUI.Schedule) == "function" then
    return VagoGUI.Schedule("group", function()
      RenderGroupGUI(players)
    end)
  end

  return RenderGroupGUI(players)
end
