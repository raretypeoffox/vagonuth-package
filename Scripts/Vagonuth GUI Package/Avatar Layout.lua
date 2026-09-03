-------------------------------------------------
-- Main AVATAR GUI Layout File    
-- Creates all the consoles / gauges / labels                      
-------------------------------------------------

Layout = Layout or {}
Layout.Labels = Layout.Labels or {}
VagoGUI = VagoGUI or {}
Layout.DefaultFontSize = GlobalVar.FontSize or 8
Layout.CompactScale = 2 / 3
Layout.VerticalScale = GlobalVar.GUICompact and Layout.CompactScale or 1

local function scaleVertical(value)
  if value == 0 then return 0 end
  return math.max(1, math.floor(value * Layout.VerticalScale + 0.5))
end

local function groupRowHeight()
  if GlobalVar.GUICompact then
    return math.max(14, Layout.DefaultFontSize + 6)
  end

  return math.max(12, Layout.DefaultFontSize + 4)
end

local function affectLabelHeight()
  if GlobalVar.GUICompact then
    return math.max(17, Layout.DefaultFontSize + 9)
  end

  return scaleVertical(20)
end

local function sectionHeaderHeight(normalHeight)
  if GlobalVar.GUICompact then
    return math.max(17, Layout.DefaultFontSize + 9)
  end

  return scaleVertical(normalHeight)
end

local function roomLabelHeight()
  if GlobalVar.GUICompact then
    return math.max(17, Layout.DefaultFontSize + 9)
  end

  return scaleVertical(18)
end

local function characterRowHeight()
  if GlobalVar.GUICompact then
    return math.max(20, Layout.DefaultFontSize + 12)
  end

  return scaleVertical(25)
end

local function statusText(name, status, normalSeparator)
  local separator = GlobalVar.GUICompact and ": " or normalSeparator
  return name .. separator .. status
end

local function verticalCenterStyle(alignment)
  return "qproperty-alignment: '" .. (alignment or "AlignVCenter") .. "'; padding: 0px;"
end

Layout.GroupRowHeight = groupRowHeight()
Layout.AffectLabelHeight = affectLabelHeight()
Layout.BottomPanelHeight = scaleVertical(140)

styleSheetOff = {
  borderColor = 'yellow',
  backgroundColor = 'rgba(255, 0, 0, 0.5)',
  borderRadius = 3,
}

styleSheetOn = {
  borderColor = 'yellow',
  backgroundColor = 'green',
  borderRadius = 3,
}

headerStyleSheet = {
  borderColor = 'yellow',
  backgroundColor = 'black',
  borderRadius = 3
}

-- Function to generate style sheet
local function generateStyleSheet(params, alignment)
  if (not params) then traceback_detail() end
  return string.format([[
  border-width: 1px;
  border-style: solid;
  border-color: %s;
  background-color: %s;
  border-radius: %spx;
  ]], params.borderColor, params.backgroundColor, params.borderRadius) .. verticalCenterStyle(alignment)
end

-- Function to create labels
local function createLabel(name, x, y, width, height, fgColor, message, container, fontSizeAdj, styleSheetParams, alignment)
  fontSize = Layout.DefaultFontSize + tonumber(fontSizeAdj or 0)
  local parent = container or Geyser
  local label = Geyser.Label:new({
      name = name,
      x = x, y = y,
      width = width, height = height,
      fgColor = fgColor,
      message = message
  }, parent)
  if styleSheetParams then
    label:setStyleSheet(generateStyleSheet(styleSheetParams, alignment))
  else
    label:setStyleSheet(verticalCenterStyle(alignment))
  end
  label._vagoAlignment = alignment
  label:setFontSize(fontSize)
  return label
end

local function createSplitLabel(name, x, y, width, height, container)
  -- Create container for the split label
  local splitContainer = Geyser.Container:new({
    name = name .. "Container",
    x = x,
    y = y,
    width = width,
    height = height
}, container)

-- Create left half label with exact same styling as your other labels
local leftLabel = Geyser.Label:new({
    name = name .. "Left",
    x = "0%",
    y = "0%",
    width = "48%", -- Slightly smaller to account for spacing
    height = "100%",
    fgColor = "white",
    message = [[<left>Water</left>]]
}, splitContainer)

-- Create right half label
local rightLabel = Geyser.Label:new({
    name = name .. "Right",
    x = "52%", -- Slightly more offset to ensure clear separation
    y = "0%",
    width = "48%",
    height = "100%",
    fgColor = "white",
    message = [[<left>Fly</left>]]
}, splitContainer)

-- Apply initial styles using the same styleSheet as your other labels
leftLabel:setStyleSheet(generateStyleSheet(styleSheetOn))
rightLabel:setStyleSheet(generateStyleSheet(styleSheetOn))

-- Set font sizes to match other labels
leftLabel:setFontSize(Layout.DefaultFontSize)
rightLabel:setFontSize(Layout.DefaultFontSize)

return {
    container = splitContainer,
    left = leftLabel,
    right = rightLabel
}
end



function ReportRun()
  if (StatTable.Level < 125) then DamageCounter.Report() end
  RunStats.Report()
  DamageCounter.ReportEcho()
end

function ResetRun()
  RunStats.Echo()
  RunStats.Reset()
  RunStats.EchoSession()
  DamageCounter.ReportEcho("<", 20)
  DamageCounter.Reset()
end

function AutoKillFunc(name)
  echo("Trigger killstyle - " .. name .. "\n")
  closeAllLevels(AutoKillLabel)

  if (name == "OFF") then
    GlobalVar.KillStyle = "kill"
    GlobalVar.AutoKill = false
  else
    GlobalVar.KillStyle = name
    GlobalVar.AutoKill = true
  end
  AutoKillSetGUI()
end

function AutoSkillToggle()
  if GlobalVar.SkillStyle == "" then
    print("AutoSkill: please set a skill style first - useage: skillstyle <skill>")
    return
  end

  GlobalVar.AutoSkill = not GlobalVar.AutoSkill
  AutoSkillSetGUI()
end

function AutoTargetToggle()
  GlobalVar.AutoTarget = not GlobalVar.AutoTarget
  AutoTargetSetGUI()
end

function AutoCastToggle()
  if GlobalVar.AutoCast then
    AutoCastOFF()
  else
    AutoCastON()
  end
end

function RightContainerToggle()
  GlobalVar.RightContainer = not GlobalVar.RightContainer

  if not GlobalVar.RightContainer then
    GlobalVar.EchoToMainConsole = true
  else
    GlobalVar.EchoToMainConsole = false
  end

  if GlobalVar.GUI then
    LoadLayout()
  end

  if SaveProfileVars then
    SaveProfileVars()
  end
end

function AutoKillSetGUI()
  if not GlobalVar.GUI then return end
  if not GlobalVar.KillStyle then GlobalVar.KillStyle = "kill" end
  
  local statusMessage = GlobalVar.AutoKill and GlobalVar.KillStyle or "OFF"
  local styleSheet = GlobalVar.AutoKill and styleSheetOn or styleSheetOff
  
  AutoKillLabel:echo("<center>" .. statusText("AutoKill", statusMessage, " - ") .. "</center>")
  AutoKillLabel:setStyleSheet(generateStyleSheet(styleSheet))
end

function AutoSkillSetGUI()
  if not GlobalVar.GUI then return end
  
  local statusMessage = GlobalVar.AutoSkill and GlobalVar.SkillStyle or "OFF"
  local styleSheet = GlobalVar.AutoSkill and styleSheetOn or styleSheetOff
  
  AutoSkillLabel:echo("<center>" .. statusText("AutoSkill", statusMessage, " ") .. "</center>")
  AutoSkillLabel:setStyleSheet(generateStyleSheet(styleSheet))
end

function AutoTargetSetGUI()
  if not GlobalVar.GUI then return end
  
  local statusMessage = GlobalVar.AutoTarget and "ON" or "OFF"
  local styleSheet = GlobalVar.AutoTarget and styleSheetOn or styleSheetOff

  AutoTargetLabel:echo("<center>" .. statusText("AutoTarget", statusMessage, " ") .. "</center>")
  AutoTargetLabel:setStyleSheet(generateStyleSheet(styleSheet))

end

function AutoCastSetGUI()
  if not GlobalVar.GUI then return end
  
  local statusMessage = GlobalVar.AutoCast and GlobalVar.AutoCaster or "OFF"
  local styleSheet = GlobalVar.AutoCast and styleSheetOn or styleSheetOff

  AutoCastLabel:echo("<center>" .. statusText("AutoCast", statusMessage, GlobalVar.AutoCast and " - " or " ") .. "</center>")
  AutoCastLabel:setStyleSheet(generateStyleSheet(styleSheet))

end

-- Modify your layout loading function to handle both styles
function LoadLayout()
  local mainWidth = getMainWindowSize()--setup. Lets get the screen space we have available and chop it up
  local LeftPanelPercent = 20 -- left side panel should be what % of available space
  local LeftPanelWidth = tonumber(mainWidth)*(LeftPanelPercent/100)  
  local RightPanelPercent = 25 -- right panel should be 25% of the available space
  local RightContainerEnabled = GlobalVar.RightContainer
  if RightContainerEnabled == nil then RightContainerEnabled = true end
  local FullRightPanelWidth = tonumber(mainWidth)*(RightPanelPercent/100)
  local RightPanelWidth = RightContainerEnabled and FullRightPanelWidth or 0
  local CentrePanelWidth = mainWidth - (RightPanelWidth + LeftPanelWidth)-- the middle area left after we have 2 side panels
  local CentrePanelSize = CentrePanelWidth/20 --break the space in middle up into 20 spaces for loading stuff in 
  
  Layout.DefaultFontSize = GlobalVar.FontSize or 8
  Layout.VerticalScale = GlobalVar.GUICompact and Layout.CompactScale or 1
  Layout.GroupRowHeight = groupRowHeight()
  Layout.AffectLabelHeight = affectLabelHeight()
  Layout.BottomPanelHeight = scaleVertical(140)
  local BottomPanelHeight = Layout.BottomPanelHeight
  -- Geyser's root area includes Mudlet's native input line. Keep the compact
  -- panel above it without shrinking the now-readable lower rows.
  local BottomInputInset = GlobalVar.GUICompact and 12 or 0
  local GroupPanelHeight = GlobalVar.GUICompact and "52%" or "55%"
  local RoomPanelY = GlobalVar.GUICompact and "52%" or "55%"
  local RoomPanelHeight = GlobalVar.GUICompact and "16%" or "15%"
  local AffectPanelY = GlobalVar.GUICompact and "68%" or "70%"
  local AffectPanelHeight = GlobalVar.GUICompact and "32%" or "30%"
  if not RightContainerEnabled then GlobalVar.EchoToMainConsole = true end
  
  -- left hand panel - full height
  setBorderLeft(LeftPanelWidth)
  
  left_container = Geyser.Container:new({
    name = "left_container",
    x="0", y=0,                    -- makes the container start 20% of the screen away from the right side
    width = LeftPanelWidth, height="100%",      -- filling it up until the end
  })
  
  GroupContainer = Geyser.Container:new({
    name = "GroupContainer",
    x="0", y=0,                    -- makes the container start 20% of the screen away from the right side
    width = LeftPanelWidth, height=GroupPanelHeight,      -- filling it up until the end
  },left_container)
  
  GroupPanel_background = createLabel("GroupPanel_background", "1%", "0", "95%", "100%", "black", nil, GroupContainer, nil, headerStyleSheet)
  lowerWindow("GroupPanel_background")

  local groupHeaderHeight = sectionHeaderHeight(20)
  GroupPanelHeader = createLabel("GroupPanelHeader", "1%", "0", "95%", groupHeaderHeight, "orange", [[<center><b>Group</b></center>]], GroupContainer, nil, headerStyleSheet)

  GroupContainerInner = Geyser.VBox:new({
    name = "GroupContainerInner",
    x="2%", y=GlobalVar.GUICompact and groupHeaderHeight + 2 or scaleVertical(25),
    width = "96%", height="99%", 
  }, GroupContainer)    
  
  
  GroupieTable = {}
  local groupFontSizeAdjustment = GlobalVar.GUICompact
    and math.max(6, Layout.DefaultFontSize - 1) - Layout.DefaultFontSize
    or 0
  local groupGaugeY = GlobalVar.GUICompact and 0 or "5%"
  -- Leave a fixed one-pixel separator between compact rows. Using an integer
  -- inset keeps every gauge the same height while avoiding Qt percentage rounding.
  local groupGaugeHeight = GlobalVar.GUICompact and math.max(1, Layout.GroupRowHeight - 1) or "90%"
  --group is set to max StaticVars.MaxGroupLabels (default 32)
  for i=1, StaticVars.MaxGroupLabels do
  
    GroupieTable[i] = Geyser.Container:new({name="groupy"..tostring(i),height=Layout.GroupRowHeight,width="90%"},GroupContainerInner)
    GroupieTable[i].NameLabel = createLabel("NameLabel"..tostring(i), "0", "0", "22%", "100%", "yellow", "<left> Name </left>", GroupieTable[i], groupFontSizeAdjustment, nil)
    GroupieTable[i].InfoLabel = createLabel("InfoLabel"..tostring(i), "22%", "0", "13%", "100%", "yellow", "<left> Info </left>", GroupieTable[i], groupFontSizeAdjustment, nil)
    GroupieTable[i].PositionLabel = createLabel("PositionLabel"..tostring(i), "36%", "0", "12%", "100%", "white", "<left> Pos </left>", GroupieTable[i], groupFontSizeAdjustment, nil)
    GroupieTable[i].NameLabel:setStyleSheet([[ background-color: black; ]] .. verticalCenterStyle())
    GroupieTable[i].InfoLabel:setStyleSheet([[ background-color: black; ]] .. verticalCenterStyle())
    GroupieTable[i].PositionLabel:setStyleSheet([[ background-color: black; ]] .. verticalCenterStyle())
    
    GroupieTable[i].HPBar = Geyser.Gauge:new({
      name="HPBar"..tostring(i),
      x="45%", y=groupGaugeY,
      width="25%", height=groupGaugeHeight,
    },GroupieTable[i])
          
    GroupieTable[i].HPBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 2;
      padding: 0px;
      qproperty-alignment: 'AlignCenter';]])
    GroupieTable[i].HPBar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FFFFFF, stop: 1 #FFFFFF);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 2;
      padding: 0px;
      qproperty-alignment: 'AlignCenter';]])
         
    GroupieTable[i].HPMaskLabel = createLabel("HPMaskLabel"..tostring(i), "45%", groupGaugeY, "25%", groupGaugeHeight, "yellow", "", GroupieTable[i], 0, nil)
    GroupieTable[i].HPMaskLabel:setColor(0,0,0,0)
    GroupieTable[i].HPMaskLabel:setToolTip("Click the HP Bar to provide a divinity / comfort to target", 10)
    
    GroupieTable[i].ManaBar = Geyser.Gauge:new({
    name="ManaBar"..tostring(i),
    x="72%", y=groupGaugeY,
    width="25%", height=groupGaugeHeight,
    },GroupieTable[i])
              
    GroupieTable[i].ManaBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 2;
      padding: 0px;
      qproperty-alignment: 'AlignCenter';]])
    GroupieTable[i].ManaBar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FFFFFF, stop: 1 #FFFFFF);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 2;
      padding: 0px;
      qproperty-alignment: 'AlignCenter';]])
      
      GroupieTable[i]:hide()

  end
  
  --LEFT MIDDLE START container on left for info
  left_container_middle = Geyser.Container:new({
    name = "left_container_middle",
    x=0, y=RoomPanelY,
    width = "100%", height=RoomPanelHeight,
  }, left_container)
  
  left_container_middle_background = createLabel("left_container_middle_background", "1%", "1%", "95%", "98%", "black", nil, left_container_middle, nil, headerStyleSheet)
  lowerWindow("left_container_middle_background")
  local roomHeaderHeight = sectionHeaderHeight(20)
  leftmiddlePanelHeader = createLabel("leftmiddlePanelHeader", "1%", "1%", "95%", roomHeaderHeight, "orange", [[<center><b>Room Info</b></center>]], left_container_middle, nil, headerStyleSheet)

  local styleSheetHidden = {
    borderColor = 'black',
    backgroundColor = 'black',
    borderRadius = 1,
  }

  local roomTextHeight = roomLabelHeight()
  local roomRowStart = GlobalVar.GUICompact and roomHeaderHeight + 2 or scaleVertical(22)
  local roomRowSpacing = GlobalVar.GUICompact and roomTextHeight + 1 or nil
  local function roomRowY(row, normalY)
    if GlobalVar.GUICompact then return roomRowStart + row * roomRowSpacing end
    return scaleVertical(normalY)
  end

  RoomLabel = createLabel("RoomLabel", "3%", roomRowY(0, 22), "90%", roomTextHeight, "white", [[<center>Room</center>]], left_container_middle, nil, styleSheetHidden)
  ExitListLabel = createLabel("ExitListLabel", "3%", roomRowY(1, 40), "90%", roomTextHeight, "yellow", [[<left></left>]], left_container_middle, nil, styleSheetHidden)
  Victim1Label = createLabel("Victim1Label", "3%", roomRowY(2, 60), "90%", roomTextHeight, "white", [[<left>...</left>]], left_container_middle, nil, styleSheetHidden)
  Victim2Label = createLabel("Victim2Label", "3%", roomRowY(3, 80), "90%", roomTextHeight, "white", [[<left>...</left>]], left_container_middle, nil, styleSheetHidden)
  Victim3Label = createLabel("Victim3Label", "3%", roomRowY(4, 100), "90%", roomTextHeight, "white", [[<left>...</left>]], left_container_middle, nil, styleSheetHidden)
  
  Victim1Label:hide()
  Victim2Label:hide()
  Victim3Label:hide()
  
  --bottom container on left for spell effects
  left_container_bottom = Geyser.Container:new({
    name = "left_container_bottom",
    x=0, y=AffectPanelY,
    width = "100%", height=AffectPanelHeight,
  }, left_container)
  
  left_container_background = createLabel("left_container_background", "1%", "0", "95%", "100%", "black", nil, left_container_bottom, nil, headerStyleSheet)
  lowerWindow("left_container_background")
  local affectHeaderHeight = sectionHeaderHeight(18)
  leftlowerPanelHeader = createLabel("leftlowerPanelHeader", "1%", "0", "95%", affectHeaderHeight, "orange", [[<center><b>Affects</b></center>]], left_container_bottom, nil, headerStyleSheet)

  local affectLabelHeight = Layout.AffectLabelHeight
  local rowSpacing = GlobalVar.GUICompact and affectLabelHeight + 1 or scaleVertical(23)
  local rowStartY = GlobalVar.GUICompact and affectHeaderHeight + 2 or scaleVertical(26)

  -- affect labels
  MoveSneakLabel = createSplitLabel("MoveSneak", "3%", rowStartY, "28%", affectLabelHeight, left_container_bottom)
  InvisLabel = createLabel("InvisLabel", "34%", rowStartY, "28%", affectLabelHeight, "white", [[<left>Invis</left>]], left_container_bottom, nil, styleSheetOn)
  DetectsLabel = createLabel("DetectsLabel", "65%", rowStartY, "28%", affectLabelHeight, "white", [[<left>Detects</left>]], left_container_bottom, nil, styleSheetOn)
  SancLabel = createLabel("SancLabel", "3%", rowStartY + rowSpacing, "28%", affectLabelHeight, "white", [[<left>Sanctuary</left>]], left_container_bottom, nil, styleSheetOn)
  FrenzyLabel = createLabel("FrenzyLabel", "34%", rowStartY + rowSpacing, "28%", affectLabelHeight, "white", [[<left>Frenzy</left>]], left_container_bottom, nil, styleSheetOn)
  WaterFlyLabel = createSplitLabel("WaterFly", "65%", rowStartY + rowSpacing, "28%", affectLabelHeight, left_container_bottom)
  FortLabel = createLabel("FortLabel", "3%", rowStartY + 2 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Fortitudes</left>]], left_container_bottom, nil, styleSheetOn)
  FociLabel = createLabel("FociLabel", "34%", rowStartY + 2 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Foci</left>]], left_container_bottom, nil, styleSheetOn)
  AwenLabel = createLabel("AwenLabel", "65%", rowStartY + 2 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Awen</left>]], left_container_bottom, nil, styleSheetOn)
  InvincLabel = createLabel("InvincLabel", "3%", rowStartY + 3 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Invinc</left>]], left_container_bottom, nil, styleSheetOn)
  BarkLabel = createLabel("BarkLabel", "34%", rowStartY + 3 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Barkskin</left>]], left_container_bottom, nil, styleSheetOn)
  SteelLabel = createLabel("SteelLabel", "65%", rowStartY + 3 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Steel Skel</left>]], left_container_bottom, nil, styleSheetOn)
  IronLabel = createLabel("IronLabel", "3%", rowStartY + 4 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Iron Skin</left>]], left_container_bottom, nil, styleSheetOn)
  ConcentrateLabel = createLabel("ConcentrateLabel", "34%", rowStartY + 4 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Concentrate</left>]], left_container_bottom, nil, styleSheetOn)
  WerreLabel = createLabel("WerreLabel", "65%", rowStartY + 4 * rowSpacing, "28%", affectLabelHeight, "white", [[<left>Werrebocler</left>]], left_container_bottom, nil, styleSheetOn)

  --START SPECIFICS
    -- Create an empty table to store the Layout.Labels
  local labelIndex = 1  -- Counter for label names
  rowStartY = rowStartY + 5 * rowSpacing
  
  for row = 1, 5 do
    for column = 1, 3 do
      local x, y
      if column == 1 then
        x = "3%"
      elseif column == 2 then
        x = "34%"
      else
        x = "65%"
      end
      
      
      local y = tostring(rowStartY + (row - 1) * rowSpacing)
  
      Layout.Labels[labelIndex] = createLabel("Skill" .. labelIndex .. "Label", x, y, "28%", affectLabelHeight, "white", "Extra Label", left_container_bottom, nil, styleSheetOn)
      Layout.Labels[labelIndex]:hide()
  
      labelIndex = labelIndex + 1
    end
  end

  -- RIGHT CONTAINER
  setBorderRight(RightPanelWidth)
  
  -- Top border
  right_container = Geyser.Container:new({
    name = "right_container",
    x = RightContainerEnabled and mainWidth - FullRightPanelWidth or mainWidth,
    y = 0,
    width = FullRightPanelWidth, height = "100%",
  })
  
  -- RightOutline
  RightOutline = createLabel("LeftBorder", "0", "0", "100%", "100%", "black", [[<center></center>]], right_container, nil, headerStyleSheet)
  lowerWindow("RightOutline")


  -- Channel Consoles
  local function createChatWindow(name, x, y, width, height, parent)
    return Geyser.MiniConsole:new({
      name = name,
      x = x, y = y,
      autoWrap = true,
      color = "black",
      scrollBar = true,
      fontSize = Layout.DefaultFontSize,
      width = width, height = height,
    }, parent)
  end

  function VagoGUI.RefreshChatWrap()
    local chatWindows = {PublicChannels, GroupChat, BuddyChat, GameChat}

    for _, chatWindow in ipairs(chatWindows) do
      if chatWindow then
        chatWindow:disableAutoWrap()
        local columns = tonumber(chatWindow:getColumnCount()) or 1
        -- Mudlet 5/Qt 6 rounds the viewport column count while its Windows
        -- scrollbar overlays the text area. Three columns clear that edge.
        chatWindow:setWrap(math.max(1, columns - 3))
      end
    end
  end

  function VagoGUI.ScheduleChatWrap()
    -- Wait until Geyser has applied the new geometry before measuring width.
    safeTempTimer("VagoGUI.ChatWrap", 0.05, VagoGUI.RefreshChatWrap)
  end
  

  local function createTraditionalChat(right_container)
    local chatHeaderHeight = GlobalVar.GUICompact and "2.5%" or "2%"
    local chatWindowHeight = GlobalVar.GUICompact and "22.5%" or "23%"
    local chatWindowOffset = GlobalVar.GUICompact and "2.5%" or "2%"

    PublicChannels = createChatWindow("Channels", "1%", chatWindowOffset, "99%", chatWindowHeight, right_container)
    GroupChat = createChatWindow("GroupChat", "1%", GlobalVar.GUICompact and "27.5%" or "27%", "99%", chatWindowHeight, right_container)
    BuddyChat = createChatWindow("BuddyChat", "1%", GlobalVar.GUICompact and "52.5%" or "52%", "99%", chatWindowHeight, right_container)
    GameChat = createChatWindow("GameChat", "1%", GlobalVar.GUICompact and "77.5%" or "77%", "99%", chatWindowHeight, right_container)

    ChannelLabel = createLabel("ChannelLabel", "0", "0", "100%", chatHeaderHeight, "orange", [[<center><b>Public Channels</b></center>]], right_container, nil, headerStyleSheet)
    GroupLabel = createLabel("GroupLabel", "0", "25%", "100%", chatHeaderHeight, "orange", [[<center><b>Group Chat</b></center>]], right_container, nil, headerStyleSheet)
    BuddyLabel = createLabel("BuddyLabel", "0", "50%", "100%", chatHeaderHeight, "orange", [[<center><b>Buddy Chat</b></center>]], right_container, nil, headerStyleSheet)
    GameLabel = createLabel("GameLabel", "0", "75%", "100%", chatHeaderHeight, "orange", [[<center><b>Game Messages</b></center>]], right_container, nil, headerStyleSheet)
  end
  
  createTraditionalChat(right_container)
  VagoGUI.ScheduleChatWrap()
  safeEventHandler("VagoGUI.ChatWrapResize", "sysWindowResizeEvent", VagoGUI.ScheduleChatWrap, false)

  StaticVars.GameMsgsChatOutput = "GameChat"

  if RightContainerEnabled then
    right_container:show()
    PublicChannels:show()
    GroupChat:show()
    BuddyChat:show()
    GameChat:show()

    ChannelLabel:show()
    GroupLabel:show()
    BuddyLabel:show()
    GameLabel:show()
  else
    right_container:hide()
  end
    
  --BOTTOM STAT PANEL
  setBorderBottom(BottomPanelHeight + BottomInputInset)
  
  Bottom_container = Geyser.Container:new({
    name = "Bottom_container",
    x = LeftPanelWidth-12, 
    y = -(BottomPanelHeight + BottomInputInset),
    width = "100%", 
    height=BottomPanelHeight,      -- filling it up until the end
  })
  
  FillLabel = createLabel("FillLabel", "0", "0", "100%", "100%", "black", "<center></center>", Bottom_container, nil, {borderColor = "black", backgroundColor = "black", borderRadius = 3})

  local CharRowHeight = characterRowHeight()
  local CharPanelHeight = CharRowHeight * 2
  -- Qt 6 needs more than the scaled 13px height to center an 8pt label.
  -- Three 16px rows still fit within the compact bottom panel.
  local LowerRowHeight = GlobalVar.GUICompact
    and math.max(16, Layout.DefaultFontSize + 8)
    or scaleVertical(20)
  local LowerRowSpacing = GlobalVar.GUICompact and LowerRowHeight or scaleVertical(25)
  local LowerRowStart = CharPanelHeight + scaleVertical(5)
  local statFontSizeAdjustment = 2
  
  CharPanel = Geyser.Container:new({
    name="CharPanel",
    x="0", y="0",
    width="100%", height=CharPanelHeight,
  }, Bottom_container)
  
  CharBackGround = createLabel("CharBackGround", "0", "0", "100%", "100%", "black", "<center></center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "black", borderRadius = 3})

  -- Lower windows after creation
  lowerWindow("CharBackGround")
  lowerWindow("FillLabel")

  CharNameLabel = createLabel("CharNameLabel", "0", "0", CentrePanelSize*3, CharPanelHeight, "black", "<center>char name</center>", CharPanel, 6, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharInfoLabel = createLabel("CharInfoLabel", CentrePanelSize*3, "0", CentrePanelSize*3, CharRowHeight, "black", "<center>Char info</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharLevelLabel = createLabel("CharLevelLabel", CentrePanelSize*3, CharRowHeight, CentrePanelSize*3, CharRowHeight, "black", "<center>Char levels</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharHitDamLabel = createLabel("CharHitDamLabel", CentrePanelSize*6, "0", CentrePanelSize*3, CharRowHeight, "black", "<center>Hit/Dam</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharACLabel = createLabel("CharACLabel", CentrePanelSize*6, CharRowHeight, CentrePanelSize*3, CharRowHeight, "black", "<center>Armor Class</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  RunXPLabel = createLabel("RunXPLabel", CentrePanelSize*9, "0", CentrePanelSize*2, CharRowHeight, "white", "<center>Run XP</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunKillsLabel = createLabel("RunKillsLabel", CentrePanelSize*9, CharRowHeight, CentrePanelSize*2, CharRowHeight, "white", "<center>Run Kills</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunLevelsLabel = createLabel("RunLevelsLabel", CentrePanelSize*11, "0", CentrePanelSize*2, CharRowHeight, "white", "<center>Run levels</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunStatsLabel = createLabel("RunStatsLabel", CentrePanelSize*11, CharRowHeight, CentrePanelSize*2, CharRowHeight, "white", "<center>Run Stat</center>", CharPanel, statFontSizeAdjustment, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})

  -- Clickable Labels
  RunReportLabel = createLabel("RunReportLabel", CentrePanelSize*13, "0", CentrePanelSize*1, CharPanelHeight, "white", "<center>Report</center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunReportLabel:setClickCallback("ReportRun")

  RunResetLabel = createLabel("RunResetLabel", CentrePanelSize*14, "0", CentrePanelSize*1, CharPanelHeight, "white", "<center>Reset</center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunResetLabel:setClickCallback("ResetRun")

  
  --SECTION FOR HANDLING AUTOKILL OPTIONS

  -- AutoKillLabel creation

  local function createKillLabel(name, message, callbackArg)
    local killLabel = AutoKillLabel:addChild({name=name, height=scaleVertical(30), width=CentrePanelSize*2, layoutDir="TV", flyOut=true, message=message})
    killLabel:setClickCallback("AutoKillFunc", callbackArg)
    killLabel:setStyleSheet([[
        border-width: 1px;
        border-style: solid;
        border-color: yellow;
        background-color: green;
        border-radius: 3px;
    ]] .. verticalCenterStyle())
    killLabel:setFontSize(Layout.DefaultFontSize)
    return killLabel
  end

  AutoKillLabel = Geyser.Label:new({
    name = "AutoKillLabel",
    x = CentrePanelSize*15, y = "0",
    width = CentrePanelSize*2, height = CharRowHeight,
    fgColor = "white",
    message = "<center>" .. statusText("AutoKill", GlobalVar.KillStyle and GlobalVar.KillStyle or "OFF", " - ") .. "</center>",
    nestable = true
}, CharPanel)
  
  AutoKillLabel:setStyleSheet(generateStyleSheet(styleSheetOn))
  -- Add other AutoKillLabel configurations here...
  
  KillLabel1 = createKillLabel("KillLabel1", "Kill", "Kill")
  KillLabel2 = createKillLabel("KillLabel2", "Surp", "Surp")
  KillLabel3 = createKillLabel("KillLabel3", "Backstab", "BS")
  KillLabel4 = createKillLabel("KillLabel4", "Bash", "Bash")
  KillLabel5 = createKillLabel("KillLabel5", " ", "OFF")
  KillLabel6 = createKillLabel("KillLabel6", "AUTO OFF", "OFF")
  
  -- AutoSkillLabel creation
  local autoSkillStyleSheet = GlobalVar.AutoSkill and styleSheetOn or styleSheetOff
  local autoSkillStatus = GlobalVar.AutoSkill and GlobalVar.SkillStyle or "OFF"
  local autoSkillMessage = "<center>" .. statusText("AutoSkill", autoSkillStatus, " ") .. "</center>"

  AutoSkillLabel = createLabel("AutoSkillLabel", CentrePanelSize*17, 0, CentrePanelSize*3, CharRowHeight, "white", autoSkillMessage, CharPanel, nil, autoSkillStyleSheet)
  AutoSkillLabel:setClickCallback("AutoSkillToggle")
  

  -- AutoTargetLabel creation
  local autoTargetStyleSheet = GlobalVar.AutoTarget and styleSheetOn or styleSheetOff
  local autoTargetMessage = "<center>" .. statusText("AutoTarget", GlobalVar.AutoTarget and "ON" or "OFF", " ") .. "</center>"

  AutoTargetLabel = createLabel("AutoTargetLabel", CentrePanelSize*15, CharRowHeight, CentrePanelSize*2, CharRowHeight, "white", autoTargetMessage, CharPanel, nil, autoTargetStyleSheet)
  AutoTargetLabel:setClickCallback("AutoTargetToggle")
  


  -- AutoCastLabel creation
  local autoCastStyleSheet = GlobalVar.AutoCast and styleSheetOn or styleSheetOff
  local autoCastStatus = GlobalVar.AutoCast and GlobalVar.AutoCaster or "OFF"
  local autoCastMessage = "<center>" .. statusText("AutoCast", autoCastStatus, GlobalVar.AutoCast and " - " or " ") .. "</center>"

  AutoCastLabel = createLabel("AutoCastLabel", CentrePanelSize*17, CharRowHeight, CentrePanelSize*3, CharRowHeight, "white", autoCastMessage, CharPanel, nil, autoCastStyleSheet)
  AutoCastLabel:setClickCallback("AutoCastToggle")
  
  LagLabel = createLabel("LagLabel", 10, LowerRowStart, CentrePanelSize*1.5, LowerRowHeight, "white", "<center>Comm Lag</center>", Bottom_container, nil, styleSheetOff, "AlignCenter")
  QiLabel = createLabel("QiLabel", 10, LowerRowStart + LowerRowSpacing, CentrePanelSize*1.5, LowerRowHeight, "white", "<center>Qi</center>", Bottom_container, nil, styleSheetOff, "AlignCenter")
  SavespellLabel = createLabel("SavespellLabel", 10, LowerRowStart + 2 * LowerRowSpacing, CentrePanelSize*1.5, LowerRowHeight, "white", "<center>Savespell</center>", Bottom_container, nil, styleSheetOff, "AlignCenter")

  
  -- Gauges
  local gaugePadding = GlobalVar.GUICompact and 2 or 3
  local commonFrontStyle = string.format([[
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 7;
    padding: %dpx;
    qproperty-alignment: 'AlignCenter';
  ]], gaugePadding)
  local commonBackStyle = string.format([[
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 7;
    padding: %dpx;
    qproperty-alignment: 'AlignCenter';
  ]], gaugePadding)
   
  local barTable = {
    MainHPBar = {
      x = 2, row = 0, width = 5.5,
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000)",
    },
    MainMPBar = {
      x = 2, row = 1, width = 5.5,
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #0099cc, stop: 1 #0099ff)",
    },
    MoveBar = {
      x = 8, row = 0, width = 5,
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #98f041, stop: 0.1 #8cf029, stop: 0.49 #66cc00, stop: 0.5 #52a300, stop: 1 #66cc00)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #78bd33, stop: 0.1 #6ebd20, stop: 0.49 #4c9900, stop: 0.5 #387000, stop: 1 #4c9900)",
    },
    TNLBar = {
      x = 8, row = 1, width = 5,
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffff66, stop: 0.3 #ffff00, stop: 1 #ff9900)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ff9900, stop: 1 #990000)",
    },
    MonitorBar = {
      x = 14, row = 0, width = 5,
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ff00ff, stop: 0.3 #ff33cc, stop: 1 #cc0066)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffffff, stop: 1 #ffccff)",
    },
    EnemyBar = {
      x = 14, row = 1, width = 5,
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000)",
    },
    WeightBar = {
      x = 2, row = 2, width = 5.5,
      front = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #467387, stop:.04 #69b7db, stop:.09 #9feae5, stop:.28 #2addd1, stop:.46 #31f9f9, stop:.67 #29bbce, stop:1 #045f89)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #0099cc, stop: 1 #0099ff)",
    },
    ItemsBar = {
      x = 8, row = 2, width = 5,
      front = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3d787f, stop: .09 #054c54, stop: .16 #004147, stop: .23 #032e33, stop: .44 #00233a, stop:  .71 #1f004c, stop:  1 #57006d)",
      back = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #8a2f2f,stop: .22 #581111,stop: .48 #641414,stop: .68 #7e1919,stop: 1 #b17575)",
    },
    AlignmentBar = {
      x = 14, row = 2, width = 5,
      back = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3d787f, stop: .09 #054c54, stop: .16 #004147, stop: .23 #032e33, stop: .44 #00233a, stop:  .71 #1f004c, stop:  1 #57006d)",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc)",

    },
  }
  
  -- Bar styles
  local barStyles = {}
  for barName, barVars in pairs(barTable) do
    barStyles[barName] = {
      x = CentrePanelSize * barVars.x,
      y = LowerRowStart + barVars.row * LowerRowSpacing,
      width = CentrePanelSize * barVars.width,
      height = LowerRowHeight,
      front = "background-color: "..barVars.front..";"..commonFrontStyle,
      back = "background-color: "..barVars.back..";"..commonBackStyle,
    }
  end
  
  -- Bar creation function
  function createBar(name, styles, parent)
    local bar = Geyser.Gauge:new({
      name=name,
      x=styles.x, y=styles.y,
      width=styles.width, height=styles.height,
    }, parent)
    
    bar.front:setStyleSheet(styles.front)
    bar.back:setStyleSheet(styles.back)
    return bar
  end
  
  MainHPBar = createBar("MainHPBar", barStyles["MainHPBar"], Bottom_container)
  MainMPBar = createBar("MainMPBar", barStyles["MainMPBar"], Bottom_container)
  MoveBar = createBar("MoveBar", barStyles["MoveBar"], Bottom_container)
  TNLBar = createBar("TNLBar", barStyles["TNLBar"], Bottom_container)
  MonitorBar = createBar("MonitorBar", barStyles["MonitorBar"], Bottom_container)
  EnemyBar = createBar("EnemyBar", barStyles["EnemyBar"], Bottom_container)
  WeightBar = createBar("WeightBar", barStyles["WeightBar"], Bottom_container)
  ItemsBar = createBar("ItemsBar", barStyles["ItemsBar"], Bottom_container)
  AlignmentBar = createBar("AlignmentBar", barStyles["AlignmentBar"], Bottom_container)

end

Layout.FirstLoad = Layout.FirstLoad or false
if GlobalVar.GUI and not Layout.FirstLoad then LoadLayout(); Layout.FirstLoad = true end

--registerAnonymousEventHandler("sysWindowResizeEvent", LoadLayout)



