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
}

local DoNotArea_MobList = {
  "A long, dark figure cracks his knuckles.", -- Bailey
  "A disinterested halfling glares at you.", -- Rickitt
  "An elven woman is here, in plain clothes.", --Mayraema
  "A naiad is here, staring fearfully at you." -- Kiahla
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
  
  local Players = gmcp.Room.Players
  local MobCount = 0

  -- Sort all Players into enemies and friendlies
  for PlayerName,_ in pairs(Players) do
    -- Mobs have numbered "names" vs PCs who have real names, can eliminate PCs by removing non-numbered names
    if tonumber(Players[PlayerName].name) then
      MobCount = MobCount + 1
    end
  end
  
  GlobalVar.MobCount = MobCount
  UpdateAutoCastSpell()
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

  -- First check if we are in a room that we do not AOE in. If we are, swap to single target spell.
  for _, DoNotArea_RoomName in ipairs(DoNotArea_RoomList) do
    if gmcp.Room.Info.name == DoNotArea_RoomName then
      if GlobalVar.AutoCaster == GlobalVar.AutoCasterAOE then
        AutoCastSetSpell(GlobalVar.AutoCasterSingle)
      end
      return
    end
  end
  
  -- Second check if there are any mobs that we do not AOE. If so, swap to single target
  for _,mob in pairs(gmcp.Room.Players) do
    if(tonumber(mob.name) ~= nil and ArrayHasSubstring(DoNotArea_MobList, mob.fullname)) then
        AutoCastSetSpell(GlobalVar.AutoCasterSingle)
      return
    end
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

