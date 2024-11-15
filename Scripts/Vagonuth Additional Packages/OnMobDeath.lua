-- Script: OnMobDeath
-- Attribute: isActive
-- OnMobDeath() called on the following events:
-- OnMobDeath

-- Script Code:
-- Dependencies: TryAction, pdebug(), splitstring

MobDeath = MobDeath or {}
MobDeath.Queue = MobDeath.Queue or {}
MobDeath.LastCommand = MobDeath.LastCommand or ""

MobDeath.CommandCheck = MobDeath.CommandCheck or {}

function MobDeath.UpdateCommandCheck()
  MobDeath.CommandCheck["cast sanctuary"] = StatTable.Sanctuary or 0
  MobDeath.CommandCheck["cast 'iron monk'"] = StatTable.Sanctuary or 0
  if (StatTable.Sanctuary == "continuous") then MobDeath.CommandCheck["cast sanctuary"] = 99 end
  MobDeath.CommandCheck["cast frenzy"] = StatTable.Frenzy or 0
  MobDeath.CommandCheck["cast mystical"] = StatTable.Mystical or 0
  MobDeath.CommandCheck["cast 'death shroud'"] = StatTable.DeathShroud or 0
  MobDeath.CommandCheck["cast 'glorious conquest'"] = StatTable.GloriousConquest or 0
  MobDeath.CommandCheck["cast 'artificer blessing'"] = StatTable.ArtificerBlessing or 0
  MobDeath.CommandCheck["cast discordia"] = StatTable.Discordia or 0

  MobDeath.CommandCheck["sneak"] = StatTable.Sneak or 0
  MobDeath.CommandCheck["move hidden"] = StatTable.MoveHidden or 0
  MobDeath.CommandCheck["cast intervention"] = StatTable.Intervention or 0
  MobDeath.CommandCheck["cast 'ether link'"] = StatTable.EtherLink or 0
  MobDeath.CommandCheck["cast 'ether warp'"] = StatTable.EtherWarp or 0
  
  MobDeath.CommandCheck["cast 'dagger hand'"] = StatTable.DaggerHand or 0
  MobDeath.CommandCheck["cast 'stone fist'"] = StatTable.StoneFist or 0
  
  MobDeath.CommandCheck["cast 'gravitas'"] = StatTable.Gravitas or 0
  MobDeath.CommandCheck["cast 'hive mind'"] = StatTable.HiveMind or 0
  
  -- Paladin
  if (GlobalVar.PrayerName ~= "") then
    MobDeath.CommandCheck["cast prayer '" .. GlobalVar.PrayerName .. "'"] = StatTable.Prayer or 0
  end
  MobDeath.CommandCheck["cast fervor"] = StatTable.Fervor or 0
  if (StatTable.Fervor == nil and StatTable.Frenzy ~= nil) then MobDeath.CommandCheck["cast fervor"] = StatTable.Frenzy end
  MobDeath.CommandCheck["cast 'holy zeal'"] = StatTable.HolyZeal or 0
  
  --Psi
  MobDeath.CommandCheck["cast 'kinetic chain'"] = StatTable.KineticChain or 0
  MobDeath.CommandCheck["cast 'stunning weapon'"] = StatTable.StunningWeapon or 0
  MobDeath.CommandCheck["cast savvy"] = StatTable.Savvy or 0
  
  -- Rogue-likes
  MobDeath.CommandCheck["alertness"] = StatTable.Alertness or 0
end



function OnMobDeath()

    MobDeath.UpdateCommandCheck()
    
    -- TODO better implementation
    if (StatTable.Class == "Paladin" and StatTable.Oath ~= "" and GlobalVar.PaladinRescue) then
      if (StatTable.Level == 51 and StatTable.SubLevel >= 250 and StatTable.JoinedBoon == nil and StatTable.HeroicBoon == nil and StatTable.Foci) then TryAction("cast 'joined boon'",30) end
      if (StatTable.Level == 125 and StatTable.SharedBoon == nil and StatTable.ValorousBoon == nil and StatTable.FinalBoon == nil and StatTable.Foci) then TryAction("cast 'shared boon'",30) end
    end

    if (MobDeath.LastCommand ~= "") then
      if (MobDeath.CommandCheck[MobDeath.LastCommand] == 0) then
        printGameMessageVerbose("OnMobDeath", "Trying again: " .. MobDeath.LastCommand)
        OnMobDeathQueuePriority(MobDeath.LastCommand)
      end
      MobDeath.LastCommand = ""
    end
    
    if #MobDeath.Queue < 1 then
      return -- Queue is empty, return
    end

    -- Check if the last command was a) in our CommandCheck list and b) if it was not cast successfully. If both true, try it again
    if (MobDeath.CommandCheck[MobDeath.Queue[1]] ~= nil and MobDeath.CommandCheck[MobDeath.Queue[1]] > 0) then
      pdebug("OnMobDeath(): You already have " .. MobDeath.Queue[1] .. " - not casting again")
      table.remove(MobDeath.Queue, 1)
      OnMobDeath()
      return
    end
    
    -- Quick check to see if we still need to cast certain spells
    if MobDeath.Queue[1] == "cast 'cure blindness'" and not StatTable.Blindness then
      table.remove(MobDeath.Queue, 1)
      return
    end
    
    
    -- We have something in the queue and we passed our checks, let's try casting it!
    pdebug("OnMobDeath(): Queue is positive with # of entries: " .. #MobDeath.Queue)
    pdebug("OnMobDeath(): Next command: " .. MobDeath.Queue[1])
    printGameMessageVerbose("OnMobDeath", "Trying: " .. MobDeath.Queue[1])
    MobDeath.LastCommand = MobDeath.Queue[1]
    TryAction(MobDeath.LastCommand,3)
    table.remove(MobDeath.Queue, 1)
      
end

function OnMobDeathQueuePriority(command)
  pdebug("OnMobDeathQueuePriority(): Command added to top of queue: " .. command)
  printGameMessageVerbose("OnMobDeath", command .. " added to queue (priority)")
  table.insert(MobDeath.Queue, 1, command)
end

function OnMobDeathQueueClear(echo)
  if echo ~= false then echo = true end
  pdebug("OnMobDeathQueueClear()")
  if echo then printGameMessageVerbose("OnMobDeath", "queue cleared") end
  MobDeath.Queue = {}
  MobDeath.LastCommand = ""
end

function OnMobDeathQueue(command)
  pdebug("OnMobDeathQueue(): Command added to bottom of queue: " .. command)
  printGameMessageVerbose("OnMobDeath", command .. " added to queue")
  table.insert(MobDeath.Queue, command)
end

function OnMobDeathWake()
    if (#MobDeath.Queue > 0) then
      if MobDeath.CommandCheck[MobDeath.Queue[1]] == nil then
        pdebug("OnMobDeathWake(): next command a self spell, called OnMobDeath()")
        OnMobDeath()
      end
    end
end
