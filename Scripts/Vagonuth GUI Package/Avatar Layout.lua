-------------------------------------------------
-- Main AVATAR GUI Layout File    
-- Creates all the consoles / gauges / labels                      
-------------------------------------------------

Layout = Layout or {}
Layout.Labels = Layout.Labels or {}
Layout.DefaultFontSize = GlobalVar.FontSize or 8
Layout.AffectLabelHeight = 20
Layout.BottomPanelHeight = 140

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

TabChat = TabChat or {
  tabs = {"All", "Channels", "GroupChat", "BuddyChat"},  -- Added "All" as first tab
  color1 = "MidnightBlue", -- Matching your current theme
  color2 = "black",
  currentTab = "All", -- Default tab changed to "All"
  borderColor = "black" -- Added border color property
}


function createTabbedChat(parent)
  -- Create main container for tabs
  TabChat.container = Geyser.Container:new({
      name = "TabChat",
      x = 0, y = 0,
      width = "100%", height = "75%",
  }, parent)

  -- Create header for tabs
  TabChat.header = Geyser.HBox:new({
      name = "TabChat.header",
      x = 0, y = 0,
      width = "100%",
      height = "5%",
  }, TabChat.container)

  -- Create main content area
  TabChat.main = Geyser.Container:new({
      name = "TabChat.Main",
      x = 0, y = "5%",
      width = "100%", height = "95%"
  }, TabChat.container)

  -- Create tabs and content areas
  for _, tabName in ipairs(TabChat.tabs) do
      -- Create tab button
      TabChat[tabName.."tab"] = Geyser.Label:new({
          name = "TabChat."..tabName.."tab",
      }, TabChat.header)

      TabChat[tabName.."tab"]:setStyleSheet([[
          background-color: ]] .. (tabName == TabChat.currentTab and TabChat.color1 or TabChat.color2) .. [[;
          border-top-left-radius: 10px;
          border-top-right-radius: 10px;
          margin-right: 1px;
          margin-left: 1px;
          border: 1px solid ]] .. TabChat.borderColor .. [[;
      ]])

      TabChat[tabName.."tab"]:echo("<center>"..tabName.."</center>")
      TabChat[tabName.."tab"]:setClickCallback("switchChatTab", tabName)

      -- Create content container
      TabChat[tabName.."Holder"] = Geyser.Container:new({
          name = "TabChat."..tabName.."Holder",
          x = 0, y = 0,
          width = "100%",
          height = "100%",
      }, TabChat.main)

      -- Create console
      TabChat[tabName.."Content"] = Geyser.MiniConsole:new({
          name = tabName,  -- Use same names as traditional windows for compatibility
          x = 0, y = 0,
          autoWrap = true,
          scrollBar = true,
          fontSize = Layout.DefaultFontSize,
          width = "100%",
          height = "100%",
      }, TabChat[tabName.."Holder"])

      TabChat[tabName.."Content"]:setColor("black")
      TabChat[tabName.."Holder"]:hide()
  end

  -- Show default tab
  TabChat[TabChat.currentTab.."Holder"]:show()
  
end

-- Function to switch between tabs
function switchChatTab(tabName)
  -- Hide current tab content
  TabChat[TabChat.currentTab.."Holder"]:hide()
  TabChat[TabChat.currentTab.."tab"]:setStyleSheet([[
      background-color: ]] .. TabChat.color2 .. [[;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
      margin-right: 1px;
      margin-left: 1px;
      border: 1px solid ]] .. TabChat.borderColor .. [[;
  ]])

  -- Show new tab content
  TabChat.currentTab = tabName
  TabChat[tabName.."Holder"]:show()
  TabChat[tabName.."tab"]:setStyleSheet([[
      background-color: ]] .. TabChat.color1 .. [[;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
      margin-right: 1px;
      margin-left: 1px;
      border: 1px solid ]] .. TabChat.borderColor .. [[;
  ]])

end


function toggleTabbedChat()
  if not GlobalVar.GUI then return end
  
  GlobalVar.TabbedChat = not GlobalVar.TabbedChat
  LoadLayout()  
  send("look")
end

-- Function to generate style sheet
local function generateStyleSheet(params)
  if (not params) then traceback_detail() end
  return string.format([[
  border-width: 1px;
  border-style: solid;
  border-color: %s;
  background-color: %s;
  border-radius: %spx;
  ]], params.borderColor, params.backgroundColor, params.borderRadius)
end

-- Function to create labels
local function createLabel(name, x, y, width, height, fgColor, message, container, fontSizeAdj, styleSheetParams)
  fontSize = Layout.DefaultFontSize + tonumber(fontSizeAdj or 0)
  local parent = container or Geyser
  local label = Geyser.Label:new({
      name = name,
      x = x, y = y,
      width = width, height = height,
      fgColor = fgColor,
      message = message
  }, parent)
  if styleSheetParams then label:setStyleSheet(generateStyleSheet(styleSheetParams)) end
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
  RunStats.Reset()
  RunStats.EchoSession()
  DamageCounter.ReportEcho()
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

function AutoKillSetGUI()
  if not GlobalVar.GUI then return end
  if not GlobalVar.KillStyle then GlobalVar.KillStyle = "kill" end
  
  local statusMessage = GlobalVar.AutoKill and GlobalVar.KillStyle or "OFF"
  local styleSheet = GlobalVar.AutoKill and styleSheetOn or styleSheetOff
  
  AutoKillLabel:echo("<center>AutoKill - " .. statusMessage .. "</center>")
  AutoKillLabel:setStyleSheet(generateStyleSheet(styleSheet))
end

function AutoSkillSetGUI()
  if not GlobalVar.GUI then return end
  
  local statusMessage = GlobalVar.AutoSkill and GlobalVar.SkillStyle or "OFF"
  local styleSheet = GlobalVar.AutoSkill and styleSheetOn or styleSheetOff
  
  AutoSkillLabel:echo("<center>AutoSkill - " .. statusMessage .. "</center>")
  AutoSkillLabel:setStyleSheet(generateStyleSheet(styleSheet))
end

function AutoTargetSetGUI()
  if not GlobalVar.GUI then return end
  
  local statusMessage = GlobalVar.AutoTarget and "ON" or "OFF"
  local styleSheet = GlobalVar.AutoTarget and styleSheetOn or styleSheetOff

  AutoTargetLabel:echo("<center>AutoTarget " .. statusMessage .. "</center>")
  AutoTargetLabel:setStyleSheet(generateStyleSheet(styleSheet))

end

function AutoCastSetGUI()
  if not GlobalVar.GUI then return end
  
  local statusMessage = GlobalVar.AutoCast and "AutoCast - ".. GlobalVar.AutoCaster or "AutoCast OFF"
  local styleSheet = GlobalVar.AutoCast and styleSheetOn or styleSheetOff

  AutoCastLabel:echo("<center>" .. statusMessage .. "</center>")
  AutoCastLabel:setStyleSheet(generateStyleSheet(styleSheet))

end

-- Modify your layout loading function to handle both styles
function LoadLayout()
  local mainWidth, mainHeight = getMainWindowSize()--setup. Lets get the screen space we have available and chop it up
  local BottomPanelHeight = Layout.BottomPanelHeight
  local LeftPanelPercent = 20 -- left side panel should be what % of available space
  local LeftPanelWidth = tonumber(mainWidth)*(LeftPanelPercent/100)  
  local RightPanelPercent = 25 -- right panel should be 25% of the available space
  local RightPanelWidth = tonumber(mainWidth)*(RightPanelPercent/100)  
  local CentrePanelWidth = mainWidth - (RightPanelWidth + LeftPanelWidth)-- the middle area left after we have 2 side panels
  local CentrePanelSize = CentrePanelWidth/20 --break the space in middle up into 20 spaces for loading stuff in 
  
  Layout.DefaultFontSize = GlobalVar.FontSize or 8
  
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
    width = LeftPanelWidth, height="55%",      -- filling it up until the end
  },left_container)
  
  GroupPanel_background = createLabel("GroupPanel_background", "1%", "0", "95%", "100%", "black", nil, GroupContainer, nil, headerStyleSheet)
  lowerWindow("GroupPanel_background")

  GroupPanelHeader = createLabel("GroupPanelHeader", "1%", "0", "95%", "20", "orange", [[<center><b>Group<</b></center>]], GroupContainer, nil, headerStyleSheet)

  GroupContainerInner = Geyser.VBox:new({
    name = "GroupContainerInner",
    x="2%", y="25",                     
    width = "96%", height="99%", 
  }, GroupContainer)    
  
  
  GroupieTable = {}
  --group is set to max StaticVars.MaxGroupLabels (default 32)
  for i=1, StaticVars.MaxGroupLabels do
  
    GroupieTable[i] = Geyser.Container:new({name="groupy"..tostring(i),height="10",width="90%"},GroupContainerInner)
    GroupieTable[i].NameLabel = createLabel("NameLabel"..tostring(i), "0", "0", "22%", "90%", "yellow", "<left> Name </left>", GroupieTable[i], 0, nil)
    GroupieTable[i].InfoLabel = createLabel("InfoLabel"..tostring(i), "22%", "0", "13%", "90%", "yellow", "<left> Info </left>", GroupieTable[i], 0, nil)
    GroupieTable[i].PositionLabel = createLabel("PositionLabel"..tostring(i), "36%", "0", "12%", "90%", "white", "<left> Pos </left>", GroupieTable[i], 0, nil)
    GroupieTable[i].NameLabel:setStyleSheet([[ background-color: black; ]])
    GroupieTable[i].InfoLabel:setStyleSheet([[ background-color: black; ]])
    GroupieTable[i].PositionLabel:setStyleSheet([[ background-color: black; ]])
    
    GroupieTable[i].HPBar = Geyser.Gauge:new({
      name="HPBar"..tostring(i),
      x="45%", y="3%",
      width="25%", height="80%",
    },GroupieTable[i])
          
    GroupieTable[i].HPBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 2;
      padding: 3px;]])
    GroupieTable[i].HPBar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FFFFFF, stop: 1 #FFFFFF);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 2;
      padding: 3px;]])
         
    GroupieTable[i].HPMaskLabel = createLabel("HPMaskLabel"..tostring(i), "45%", "3%", "25%", "90%", "yellow", "", GroupieTable[i], 0, nil)
    GroupieTable[i].HPMaskLabel:setColor(0,0,0,0)
    GroupieTable[i].HPMaskLabel:setToolTip("Click the HP Bar to provide a divinity / comfort to target", 10)
    
    GroupieTable[i].ManaBar = Geyser.Gauge:new({
    name="ManaBar"..tostring(i),
    x="72%", y="3%",
    width="25%", height="80%",
    },GroupieTable[i])
              
    GroupieTable[i].ManaBar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 2;
      padding: 3px;]])
    GroupieTable[i].ManaBar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FFFFFF, stop: 1 #FFFFFF);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 2;
      padding: 3px;]])
      
      GroupieTable[i]:hide()

  end
  
  --LEFT MIDDLE START container on left for info
  left_container_middle = Geyser.Container:new({
    name = "left_container_middle",
    x=0, y="55%",                 
    width = "100%", height="15%", 
  }, left_container)
  
  left_container_middle_background = createLabel("left_container_middle_background", "1%", "1%", "95%", "98%", "black", nil, left_container_middle, nil, headerStyleSheet)
  lowerWindow("left_container_middle_background")
  leftmiddlePanelHeader = createLabel("leftmiddlePanelHeader", "1%", "1%", "95%", "20", "orange", [[<center><b>Room Info</b></center>]], left_container_middle, nil, headerStyleSheet)

  local styleSheetHidden = {
    borderColor = 'black',
    backgroundColor = 'black',
    borderRadius = 1,
  }

  RoomLabel = createLabel("RoomLabel", "3%", "22", "90%", "18", "white", [[<center>Room</center>]], left_container_middle, nil, styleSheetHidden)
  ExitListLabel = createLabel("ExitListLabel", "3%", "40", "90%", "18", "yellow", [[<left></left>]], left_container_middle, nil, styleSheetHidden)
  Victim1Label = createLabel("Victim1Label", "3%", "60", "90%", "18", "white", [[<left>...</left>]], left_container_middle, nil, styleSheetHidden)
  Victim2Label = createLabel("Victim2Label", "3%", "80", "90%", "18", "white", [[<left>...</left>]], left_container_middle, nil, styleSheetHidden)
  Victim3Label = createLabel("Victim3Label", "3%", "100", "90%", "18", "white", [[<left>...</left>]], left_container_middle, nil, styleSheetHidden)
  
  Victim1Label:hide()
  Victim2Label:hide()
  Victim3Label:hide()
  
  --bottom container on left for spell effects
  left_container_bottom = Geyser.Container:new({
    name = "left_container_bottom",
    x=0, y="70%",                 
    width = "100%", height="30%", 
  }, left_container)
  
  left_container_background = createLabel("left_container_background", "1%", "0", "95%", "100%", "black", nil, left_container_bottom, nil, headerStyleSheet)
  lowerWindow("left_container_background")
  leftlowerPanelHeader = createLabel("leftlowerPanelHeader", "1%", "0", "95%", "18", "orange", [[<center><b>Affects</b></center>]], left_container_bottom, nil, headerStyleSheet)

  local affectLabelHeight = Layout.AffectLabelHeight
  local rowSpacing = affectLabelHeight + 3
  local rowStartY = 26

  -- affect labels
  MoveHiddenLabel = createLabel("MoveHiddenLabel", "3%", rowStartY, "28%", affectLabelHeight, "white", [[<left>Move Hidden</left>]], left_container_bottom, nil, styleSheetOn)
  SneakLabel = createLabel("SneakLabel", "34%", rowStartY, "28%", affectLabelHeight, "white", [[<left>Sneak</left>]], left_container_bottom, nil, styleSheetOn)
  InvisLabel = createLabel("InvisLabel", "65%", rowStartY, "28%", affectLabelHeight, "white", [[<left>Invis</left>]], left_container_bottom, nil, styleSheetOn)
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
  
  for row = 1, 4 do
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
    x = mainWidth - RightPanelWidth, y = 0,
    width = RightPanelWidth, height = "100%",
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
  

  local function createTraditionalChat(right_container)
    PublicChannels = createChatWindow("Channels", "1%", "2%", "99%", "23%", right_container)
    GroupChat = createChatWindow("GroupChat", "1%", "27%", "99%", "23%", right_container)
    BuddyChat = createChatWindow("BuddyChat", "1%", "52%", "99%", "23%", right_container)
    GameChat = createChatWindow("GameChat", "1%", "77%", "99%", "23%", right_container)
  
    ChannelLabel = createLabel("ChannelLabel", "0", "0", "100%", "2%", "orange", [[<center><b>Public Channels</b></center>]], right_container, nil, headerStyleSheet)
    GroupLabel = createLabel("GroupLabel", "0", "25%", "100%", "2%", "orange", [[<center><b>Group Chat</b></center>]], right_container, nil, headerStyleSheet)
    BuddyLabel = createLabel("BuddyLabel", "0", "50%", "100%", "2%", "orange", [[<center><b>Buddy Chat</b></center>]], right_container, nil, headerStyleSheet)
    GameLabel = createLabel("GameLabel", "0", "75%", "100%", "2%", "orange", [[<center><b>Game Messages</b></center>]], right_container, nil, headerStyleSheet)
  end
  
  createTraditionalChat(right_container)
  createTabbedChat(right_container)

  if GlobalVar.TabbedChat then
    PublicChannels:hide()
    GroupChat:hide()
    BuddyChat:hide()
    
    ChannelLabel:hide()
    GroupLabel:hide()
    BuddyLabel:hide()
    
    createTabbedChat(right_container)
    TabChat.container:show()
  else
    TabChat.container:hide()
    
    createTraditionalChat(right_container)
    PublicChannels:show()
    GroupChat:show()
    BuddyChat:show()
    
    ChannelLabel:show()
    GroupLabel:show()
    BuddyLabel:show()
    

  end


  --BOTTOM STAT PANEL
  setBorderBottom(BottomPanelHeight)
  
  Bottom_container = Geyser.Container:new({
    name = "Bottom_container",
    x = LeftPanelWidth-12, 
    y= mainHeight-BottomPanelHeight,
    width = "100%", 
    height=BottomPanelHeight,      -- filling it up until the end
  })
  
  FillLabel = createLabel("FillLabel", "0", "0", "100%", "95%", "black", "<center></center>", Bottom_container, nil, {borderColor = "yellow", backgroundColor = "black", borderRadius = 3})
  
  CharPanel = Geyser.Container:new({
    name="CharPanel",
    x="0", y="0",
    width="100%", height="50",
  }, Bottom_container)
  
  CharBackGround = createLabel("CharBackGround", "0", "0", "100%", "100%", "black", "<center></center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "black", borderRadius = 3})

  -- Lower windows after creation
  lowerWindow("CharBackGround")
  lowerWindow("FillLabel")

  CharNameLabel = createLabel("CharNameLabel", "0", "0", CentrePanelSize*3, "50", "black", "<center>char name</center>", CharPanel, 6, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharInfoLabel = createLabel("CharInfoLabel", CentrePanelSize*3, "0", CentrePanelSize*3, "25", "black", "<center>Char info</center>", CharPanel, 2, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharLevelLabel = createLabel("CharLevelLabel", CentrePanelSize*3, "25", CentrePanelSize*3, "25", "black", "<center>Char levels</center>", CharPanel, 2, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharHitDamLabel = createLabel("CharHitDamLabel", CentrePanelSize*6, "0", CentrePanelSize*3, "25", "black", "<center>Hit/Dam</center>", CharPanel, 1, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  CharACLabel = createLabel("CharACLabel", CentrePanelSize*6, "25", CentrePanelSize*3, "25", "black", "<center>Armor Class</center>", CharPanel, 3, {borderColor = "yellow", backgroundColor = "DarkGoldenrod", borderRadius = 3})
  RunXPLabel = createLabel("RunXPLabel", CentrePanelSize*9, "0", CentrePanelSize*2, "25", "white", "<center>Run XP</center>", CharPanel, 2, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunKillsLabel = createLabel("RunKillsLabel", CentrePanelSize*9, "25", CentrePanelSize*2, "25", "white", "<center>Run Kills</center>", CharPanel, 2, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunLevelsLabel = createLabel("RunLevelsLabel", CentrePanelSize*11, "0", CentrePanelSize*2, "25", "white", "<center>Run levels</center>", CharPanel, 2, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunStatsLabel = createLabel("RunStatsLabel", CentrePanelSize*11, "25", CentrePanelSize*2, "25", "white", "<center>Run Stat</center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})

  -- Clickable Labels
  RunReportLabel = createLabel("RunReportLabel", CentrePanelSize*13, "0", CentrePanelSize*1, "50", "white", "<center>Report</center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunReportLabel:setClickCallback("ReportRun")

  RunResetLabel = createLabel("RunResetLabel", CentrePanelSize*14, "0", CentrePanelSize*1, "50", "white", "<center>Reset</center>", CharPanel, nil, {borderColor = "yellow", backgroundColor = "MidnightBlue", borderRadius = 3})
  RunResetLabel:setClickCallback("ResetRun")

  
  --SECTION FOR HANDLING AUTOKILL OPTIONS

  -- AutoKillLabel creation

  local function createKillLabel(name, message, callbackArg)
    local killLabel = AutoKillLabel:addChild({name=name, height=30, width=CentrePanelSize*2, layoutDir="TV", flyOut=true, message=message})
    killLabel:setClickCallback("AutoKillFunc", callbackArg)
    killLabel:setStyleSheet([[
        border-width: 1px;
        border-style: solid;
        border-color: yellow;
        background-color: green;
        border-radius: 3px;
    ]])
    killLabel:setFontSize(Layout.DefaultFontSize)
    return killLabel
  end

  AutoKillLabel = Geyser.Label:new({
    name = "AutoKillLabel",
    x = CentrePanelSize*15, y = "0",
    width = CentrePanelSize*2, height = "25",
    fgColor = "white",
    message = "<center>AutoKill - " .. (GlobalVar.KillStyle and GlobalVar.KillStyle or "OFF") .. "</center>",
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
  local autoSkillMessage = GlobalVar.AutoSkill and "<center>AutoSkill " .. GlobalVar.SkillStyle .. "</center>" or "<center>AutoSkill OFF</center>"

  AutoSkillLabel = createLabel("AutoSkillLabel", CentrePanelSize*17, 0, CentrePanelSize*3, 25, "white", autoSkillMessage, CharPanel, nil, autoSkillStyleSheet)
  AutoSkillLabel:setClickCallback("AutoSkillToggle")
  

  -- AutoTargetLabel creation
  local autoTargetStyleSheet = GlobalVar.AutoTarget and styleSheetOn or styleSheetOff
  local autoTargetMessage = GlobalVar.AutoTarget and "<center>AutoTarget ON</center>" or "<center>AutoTarget OFF</center>"

  AutoTargetLabel = createLabel("AutoTargetLabel", CentrePanelSize*15, 25, CentrePanelSize*2, 25, "white", autoTargetMessage, CharPanel, nil, autoTargetStyleSheet)
  AutoTargetLabel:setClickCallback("AutoTargetToggle")
  


  -- AutoCastLabel creation
  local autoCastStyleSheet = GlobalVar.AutoCast and styleSheetOn or styleSheetOff
  local autoCastMessage = GlobalVar.AutoCast and "<center>AutoCast - ".. GlobalVar.AutoCaster .. "</center>" or "<center>AutoCast OFF</center>"

  AutoCastLabel = createLabel("AutoCastLabel", CentrePanelSize*17, 25, CentrePanelSize*3, 25, "white", autoCastMessage, CharPanel, nil, autoCastStyleSheet)
  AutoCastLabel:setClickCallback("AutoCastToggle")
  
  LagLabel = createLabel("LagLabel", 10, 55, CentrePanelSize*1.5, 20, "white", "<center>Comm Lag</center>", Bottom_container, nil, styleSheetOff)
  QiLabel = createLabel("QiLabel", 10, 80, CentrePanelSize*1.5, 20, "white", "<center>Qi</center>", Bottom_container, nil, styleSheetOff)
  SavespellLabel = createLabel("SavespellLabel", 10, 105, CentrePanelSize*1.5, 20, "white", "<center>Savespell</center>", Bottom_container, nil, styleSheetOff)

  
  -- Gauges
  local commonFrontStyle = [[
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 7;
    padding: 3px;
  ]]
  local commonBackStyle = [[
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 7;
    padding: 3px;
  ]]
   
  local barTable = {
    MainHPBar = {
      x = 2, y = "55", width = 5.5, height = "20",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000)",
    },
    MainMPBar = {
      x = 2, y = "80", width = 5.5, height = "20",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #0099cc, stop: 1 #0099ff)",
    },
    MoveBar = {
      x = 8, y = "55", width = 5, height = "20",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #98f041, stop: 0.1 #8cf029, stop: 0.49 #66cc00, stop: 0.5 #52a300, stop: 1 #66cc00)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #78bd33, stop: 0.1 #6ebd20, stop: 0.49 #4c9900, stop: 0.5 #387000, stop: 1 #4c9900)",
    },
    TNLBar = {
      x = 8, y = "80", width = 5, height = "20",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffff66, stop: 0.3 #ffff00, stop: 1 #ff9900)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ff9900, stop: 1 #990000)",
    },
    MonitorBar = {
      x = 14, y = "55", width = 5, height = "20",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ff00ff, stop: 0.3 #ff33cc, stop: 1 #cc0066)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffffff, stop: 1 #ffccff)",
    },
    EnemyBar = {
      x = 14, y = "80", width = 5, height = "20",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000)",
    },
    WeightBar = {
      x = 2, y = "105", width = 5.5, height = "20",
      front = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #467387, stop:.04 #69b7db, stop:.09 #9feae5, stop:.28 #2addd1, stop:.46 #31f9f9, stop:.67 #29bbce, stop:1 #045f89)",
      back = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #0099cc, stop: 1 #0099ff)",
    },
    ItemsBar = {
      x = 8, y = "105", width = 5, height = "20",
      front = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3d787f, stop: .09 #054c54, stop: .16 #004147, stop: .23 #032e33, stop: .44 #00233a, stop:  .71 #1f004c, stop:  1 #57006d)",
      back = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #8a2f2f,stop: .22 #581111,stop: .48 #641414,stop: .68 #7e1919,stop: 1 #b17575)",
    },
    AlignmentBar = {
      x = 14, y = "105", width = 5, height = "20",
      back = "QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3d787f, stop: .09 #054c54, stop: .16 #004147, stop: .23 #032e33, stop: .44 #00233a, stop:  .71 #1f004c, stop:  1 #57006d)",
      front = "QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #000099, stop: 0.1 #000099, stop: 0.49 #3399ff, stop: 0.5 #0000ff, stop: 1 #0033cc)",

    },
  }
  
  -- Bar styles
  local barStyles = {}
  for barName, barVars in pairs(barTable) do
    barStyles[barName] = {
      x = CentrePanelSize * barVars.x,
      y = barVars.y,
      width = CentrePanelSize * barVars.width,
      height = barVars.height,
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



