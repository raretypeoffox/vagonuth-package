-- Script: AutoCastSpellSwap
-- Attribute: isActive
-- AutoCastSpellSwap() called on the following events:
-- gmcp.Room.Players

-- Script Code:
GlobalVar = GlobalVar or {}
GlobalVar.MobCount = GlobalVar.MobCount or 0

local DoNotArea_RoomList = {
  "Spire of Knowledge", 
  "Another room name", 
  "Yet another room name",
  "Ponderous Flowers",
  "A menagerie",
  "A tiny cell",
  "A Battle of Wits",
}

local DoNotArea_MobList = {
  "A long, dark figure cracks his knuckles.", -- Bailey
  "A disinterested halfling glares at you.", -- Rickitt
  "An elven woman is here, in plain clothes.", --Mayraema
  "A naiad is here, staring fearfully at you.", -- Kiahla
  "The mess hall cook licks his lips and ogles you like a piece of meat.", -- forsaken asylum
}

local AutoCastOnMobDeathEventHandler = AutoCastOnMobDeathEventHandler or nil

-- Called the first time a Wizard/Mage receives a gmcp.Room.Players update
function AutoCastInit()
  if AutoCastOnMobDeathEventHandler then
    killAnonymousEventHandler(AutoCastOnMobDeathEventHandler)
  end
  AutoCastOnMobDeathEventHandler = registerAnonymousEventHandler("OnMobDeath","AutoCastOnMobDeath",false)
end

-- Called on Reconnect
function AutoCastCleanUp()
  if AutoCastOnMobDeathEventHandler then
    killAnonymousEventHandler(AutoCastOnMobDeathEventHandler)
    AutoCastOnMobDeathEventHandler = nil
  end
end

-- AutoCastSpellSwap()
-- Called whenever gmcp.Room.Players is updated (eg, on look, on move to new room)
function AutoCastSpellSwap()
  if (StatTable.Class ~= "Wizard" and StatTable.Class ~= "Mage" and StatTable.Level ~= 250) then 
    return 
  end
  
  if StatTable.Level < 125 then
    if not (gmcp.Room.Info.zone == "{*HERO*} Ctibor  Sem Vida" or gmcp.Room.Info.zone == "{*HERO*} Ibn     Aculeata Jatha-La") or StatTable.SubLevel < 101 then
      return
    end
  end
  
  if not AutoCastOnMobDeathEventHandler then AutoCastInit() end
  
  GlobalVar.MobCount = AutoCastCountMobs()
  UpdateAutoCastSpell()
end

function AutoCastCountMobs()
  local Players = gmcp and gmcp.Room and gmcp.Room.Players or {}
  local MobCount = 0

  -- Sort all Players into enemies and friendlies
  for _, mob in pairs(Players) do
    -- Mobs have numbered "names" vs PCs who have real names, can eliminate PCs by removing non-numbered names
    local fullname = mob.fullname or ""
    if tonumber(mob.name) and not fullname:find("%(CHARMED%)") then
      MobCount = MobCount + 1
    end
  end

  return MobCount
end

function AutoCastRoomAllowsAOE()
  if not gmcp or not gmcp.Room or not gmcp.Room.Info then return true end

  -- First check if we are in a room that we do not AOE in.
  for _, DoNotArea_RoomName in ipairs(DoNotArea_RoomList) do
    if gmcp.Room.Info.name == DoNotArea_RoomName then
      return false
    end
  end

  -- Second check if there are any mobs that we do not AOE.
  for _,mob in pairs(gmcp.Room.Players or {}) do
    local fullname = mob.fullname or ""
    if(tonumber(mob.name) ~= nil and not fullname:find("%(CHARMED%)") and ArrayHasSubstring(DoNotArea_MobList, fullname)) then
      return false
    end
  end

  return true
end

-- The function called to swap spells
function UpdateAutoCastSpell()

  -- Wizard's with ether crash exhausted can't AoE, set to single target
  if StatTable.Class == "Wizard" and StatTable.EtherCrash and StatTable.EtherCrash == 2 then
    if GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE then
      AutoCastSetSpell(GlobalVar.AutoCasterSingle)
    end
    return
  end

  -- First check if we are in a room that we do not AOE in, or if there are any mobs that we do not AOE.
  if not AutoCastRoomAllowsAOE() then
    if GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE then
      AutoCastSetSpell(GlobalVar.AutoCasterSingle)
    end
    return
  end
  
  -- Check if the MobCount is 3 or more. If so, AOE
  if GlobalVar.MobCount >= 3 then   
    AutoCastSetSpell(GlobalVar.AutoCasterAOE)
  else
   if GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE and GlobalVar.MobCount > 0 then
      AutoCastSetSpell(GlobalVar.AutoCasterSingle)
    end
  end
  
end

-- Called whenever a mob is killed
function AutoCastOnMobDeath()
  if (GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE and (StatTable.Class == "Mage" or StatTable.Class == "Wizard" or StatTable.Level == 250)) then
    GlobalVar.MobCount = GlobalVar.MobCount - 1
    UpdateAutoCastSpell()
  end
end

