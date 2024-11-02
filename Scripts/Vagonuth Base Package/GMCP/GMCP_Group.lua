-- Script: GMCP_Group
-- Attribute: isActive
-- GMCP_Group() called on the following events:
-- gmcp.Char.Group.List

-- Script Code:

function GMCP_Group()

    local GroupieTableIndex = 0
    
    StatTable.InjuredCount = 0
    StatTable.CriticalInjured = 0
    GlobalVar.VizMonitor = ""
    GlobalVar.GroupMates = {}
    GlobalVar.PsiInGroup = false
    
    local InjuredPercent = StaticVars.InjuredPercent
    local CriticalPercent = StaticVars.CriticalPercent
    
    local smallest_hppct = InjuredPercent -- swap monitors to groupie with lowest hp% < 85%
    local GroupList = gmcp.Char.Group.List or nil
    local PlayersInRoom = gmcp.Room.Players or nil
    
    if not GroupList then return end
    
    -- Hide all the group labels
    for index = 1, StaticVars.MaxGroupLabels do
      GroupieTable[index]:hide()
    end

    for _, Player in ipairs(GroupList) do
      GroupieTableIndex = GroupieTableIndex + 1
      
      -- Clean's the players name if they are currently coloured
      Player.name = GMCP_name(RemoveColourCodes(Player.name))
      
      -- Update GroupMates table
      UpdateGroupMateVitals(Player)
     
      -- Update GUI Groupmate table
      if GlobalVar.GUI and GroupieTableIndex <= StaticVars.MaxGroupLabels then
          UpdateGroupGUI(GroupieTableIndex, Player)
      end
    
      -- Save who the GroupLeader is for use in other functions
      if Player.leader then 
          GlobalVar.GroupLeader = Player.name
      end
      
      -- To improve trigger performance, only enable PSI weapon pick up trigs when a PSI is in the group
      if(Player.class == "Psi" and Player.race ~= "Gth" and Player.name ~= "Someone") then
          GlobalVar.PsiInGroup = true
          if not PSITrigger.TriedLookUp[Player.name] then pdebug("GMCP_Group called PSITrigger.Update() due to new Psi in the group"); PSITrigger.Update() end
      end

      -- Code to count how many injured and wounded (defined at the top) are in the group
      if(Player.position ~= "Sleep" and Player.position ~= "Rest") then --we don't want to capture groupings regening
        
        local player_hppct = tonumber(Player.hp) / tonumber(Player.maxhp)
          
        if(player_hppct < InjuredPercent) then
          StatTable.InjuredCount = StatTable.InjuredCount +1
          if(player_hppct < CriticalPercent) then
            StatTable.CriticalInjured = StatTable.CriticalInjured +1
          end
        end
        
        -- For all groupies that are not us, check who has the lowest % of HP and set them as our monitor
        if (Player.name ~= StatTable.CharName and (Player.position ~= "Sleep" or Player.position ~= "Rest")) then
          if (player_hppct < smallest_hppct) then
            smallest_hppct = player_hppct
            GlobalVar.VizMonitor = Player.name
          end
        end
      end -- end of counting injured groupies
      
      if StatTable.Position == "Sleep" and Player.position == "Fight" then
        TryPrint("Alert! Group mates are fighting!", 10)
      end
      
    end -- end for loop
end 

function UpdateGroupMateVitals(Player)
    -- Create Global Groupmate table for use in other functions. If more groupmate stats from GMCP needed, add below
    GlobalVar.GroupMates[Player.name] = {}
    GlobalVar.GroupMates[Player.name].hp = tonumber(Player.hp)
    GlobalVar.GroupMates[Player.name].maxhp = tonumber(Player.maxhp)
    GlobalVar.GroupMates[Player.name].mp = tonumber(Player.mp)
    GlobalVar.GroupMates[Player.name].maxmp = tonumber(Player.maxmp)
    GlobalVar.GroupMates[Player.name].class = Player.class
    return
end
