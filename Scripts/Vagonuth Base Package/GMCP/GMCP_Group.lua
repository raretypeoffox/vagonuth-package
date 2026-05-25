-- Script: GMCP_Group
-- Attribute: isActive
-- GMCP_Group() called on the following events:
-- gmcp.Char.Group.List

-- Script Code:
local IncludeNecMobName = false -- set to true to show the Nec Mob's name

function GMCP_Group()
    local GroupieTableIndex = 0
    StatTable.InjuredCount = 0
    StatTable.CriticalInjured = 0
    GlobalVar.VizMonitor = ""
    LastGroupUpdate = deepcopy(GlobalVar.GroupMates) or {}
    GlobalVar.GroupMates = {}
    GlobalVar.NecMobList = {}
    GlobalVar.PsiInGroup = false
    
    local InjuredPercent = StaticVars.InjuredPercent
    local CriticalPercent = StaticVars.CriticalPercent
    
    local smallest_hppct = InjuredPercent -- swap monitors to groupie with lowest hp% < 85%
    local GroupList = gmcp.Char.Group.List or nil
    local PlayersInRoom = gmcp.Room.Players or nil
    
    
    if not GroupList then return end
    
    -- Remove necro mobs, put them in their own list
    for i = #GroupList, 1, -1 do
      local level = GroupList[i].level
      if level and level:find("Mob", 1, true) then  -- case-sensitive, no pattern
        table.insert(GlobalVar.NecMobList, GroupList[i])
        table.remove(GroupList, i)
      end
    end
    
    -- Hide all the group labels
    for index = 1, StaticVars.MaxGroupLabels do
      GroupieTable[index]:hide()
    end

    for _, Player in ipairs(GroupList) do
      GroupieTableIndex = GroupieTableIndex + 1    
      
      -- Clean's the players name if they are currently coloured
      Player.name = GMCP_name(RemoveColourCodes(Player.name))
      
      -- We're blind! Let's see if we can figure out who is who anyways
      if Player.name == "Someone" then
        Player.name = UpdateGroupMatesFindSomeone(Player, LastGroupUpdate)
      end
      
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
          if (player_hppct < smallest_hppct) and not GlobalVar.AutoHealExclusionList[Player.name] then
            smallest_hppct = player_hppct
            GlobalVar.VizMonitor = Player.name
          end
        end
      end -- end of counting injured groupies
      
      if StatTable.Position == "Sleep" and Player.position == "Fight" then
        TryPrint("Alert! Group mates are fighting!", 10)
      end
      
    end -- end of player for loop
    
    
    if GlobalVar.ShowNecMobs or StatTable.Class == "Nec" then -- NecMobFlag
      for _, NecMob in ipairs(GlobalVar.NecMobList) do
        GroupieTableIndex = GroupieTableIndex + 1 
        
        if NecMob.name == "Someone" then
          NecMob.name = "Nec Mob"
        elseif NecMob.name:match("^%S+$") then --single word, must be companion
          NecMob.name = NecMob.name
        else
          if IncludeNecMobName then
            local mobtype, mobname
            
            mobtype, _, mobname = NecMob.name:match("^A%s+(%w+)%s+(%w+)%s+(.+)$")
            NecMob.name = firstToUpper(mobtype:sub(1,3)) .. " - " .. firstToUpper(mobname)
          else
            NecMob.name = firstToUpper(NecMob.name:match("^A%s+(%w+)%s+"))
          end
        end
       
        NecMob.name = "<left><span style='color: rgb(211,211,211)'>" .. NecMob.name .. "</span>"
        
        if GlobalVar.GUI and GroupieTableIndex <= StaticVars.MaxGroupLabels then
          UpdateGroupGUI(GroupieTableIndex, NecMob)
        end
        
      end
    end -- end of NecMob for loop
end

function UpdateGroupMatesFindSomeone(Player, LastGroupUpdate)
  if TableSize(LastGroupUpdate) == 0 then return "Someone" end
  
  for player_name, playertbl in pairs(LastGroupUpdate) do
    if playertbl.class == Player.class and playertbl.maxhp == tonumber(Player.maxhp) and playertbl.maxmp == tonumber(Player.maxmp) then  
      return player_name
    end         
  end 
  return "Someone"
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

local function formatMobDisplay(s)
    local mobType, _, mobName = s:match("^A%s+(%w+)%s+(named|tagged)%s+(.+)$")
    if not mobType then return s end   -- fallback if format unexpected
    return mobType .. " - " .. mobName
end
