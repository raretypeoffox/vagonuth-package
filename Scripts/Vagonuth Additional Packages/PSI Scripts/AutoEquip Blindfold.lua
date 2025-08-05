-- Script: AutoEquip Blindfold
-- Attribute: isActive

-- Script Code:
-- if exporting, requires:
-- + SafeMudlet Script
-- + raiseEvent("CustomGameLoop") somewhere (timer for example, I use every 5 seconds)

AutoEquipBlindfold = AutoEquipBlindfold or {}

AutoEquipBlindfold.Enabled = AutoEquipBlindfold.Enabled or true
AutoEquipBlindfold.Init = AutoEquipBlindfold.Init or false
AutoEquipBlindfold.Count = AutoEquipBlindfold.Count or 0
AutoEquipBlindfold.isEquipped = AutoEquipBlindfold.isEquipped or false

-- optional args, comment out if not using
local MindsEyeBagName = "loot"
local MindsEyeAltGear = "crown pain wire shards glass"

function AutoEquipBlindfold.Equip()
  local isAsleep = (StatTable.Position == "Sleep" and true or false)
  
  if isAsleep then send("rest") end
  
  if MindsEyeBagName then
    send("get 'yorimandil blindfold' '" .. MindsEyeBagName .. "'")
  end
  
  send("wear 'yorimandil blindfold'")
  
  if MindsEyeBagName and MindsEyeAltGear then
    send("put '" .. MindsEyeAltGear .. "' '" .. MindsEyeBagName .. "'")
  end
  
  if isAsleep then send("sleep") end
end

function AutoEquipBlindfold.Remove()
  local isAsleep = (StatTable.Position == "Sleep" and true or false)
  
  if isAsleep then send("rest") end
  
  send("remove 'yorimandil blindfold'")
  
  if MindsEyeBagName then 
    send("put 'yorimandil blindfold' '" .. MindsEyeBagName .. "'")
    if MindsEyeAltGear then
      send("get '" .. MindsEyeAltGear .. "' '" .. MindsEyeBagName .. "'")
      send("wear '" .. MindsEyeAltGear .. "'")
    end
  end

  if isAsleep then send("sleep") end
  
end

function AutoEquipBlindfold.Check()
  if not AutoEquipBlindfold.Enabled then return end
  if StatTable.Class ~= "Psionicist" then return end -- only for Psi's by defualt

  if not StatTable.MindsEye then
    if AutoEquipBlindfold.Init then
      safeKillTrigger("AutoEquipBlindfold.Wear")
      safeKillTrigger("AutoEquipBlindfold.Worn")
      safeKillTrigger("AutoEquipBlindfold.Worn2")
      safeKillTrigger("AutoEquipBlindfold.Removed")
      safeKillTrigger("AutoEquipBlindfoldPickup")
      safeKillAlias("AutoEquipBlindfoldAblut")
      AutoEquipBlindfold.Init = false
    end
    return 
  end

  if not AutoEquipBlindfold.Init then
    safeTempTrigger("AutoEquipBlindfold.Wear", "You wear Yorimandil's Blindfold on your head.", function() AutoEquipBlindfold.isEquipped = true end, "begin")
    safeTempTrigger("AutoEquipBlindfold.Worn", "<worn on head>      Yorimandil's Blindfold", function() AutoEquipBlindfold.isEquipped = true end, "begin")
    safeTempTrigger("AutoEquipBlindfold.Worn2", "<worn on head>      (Magical) Yorimandil's Blindfold", function() AutoEquipBlindfold.isEquipped = true end, "begin")
    safeTempTrigger("AutoEquipBlindfold.Removed", "You stop using Yorimandil's Blindfold.", function() AutoEquipBlindfold.isEquipped = false end, "begin")
    safeTempTrigger("AutoEquipBlindfoldPickup", "You get Yorimandil's Blindfold from corpse of " .. StatTable.CharName, function() if AutoEquipBlindfold.isEquipped then AutoEquipBlindfold.Remove() end; end, "begin")
    safeTempAlias("AutoEquipBlindfoldAblut", "^c(ast)? ablut", function() if AutoEquipBlindfold.isEquipped then AutoEquipBlindfold.Remove() end; send("cast ablution") end)
    AutoEquipBlindfold.Init = true
  end

  if AutoEquipBlindfold.Count < 0 then
    AutoEquipBlindfold.Count = AutoEquipBlindfold.Count + 1
    return
  end
  
  if AutoEquipBlindfold.isEquipped == false and StatTable.MindsEye > 50 then
    AutoEquipBlindfold.Equip()
    AutoEquipBlindfold.Count = -10 -- waits 10 calls of CustomGameLoop (about 5 seconds per loop or 50 seconds in total)
  elseif AutoEquipBlindfold.isEquipped and StatTable.MindsEye < 2 then
    AutoEquipBlindfold.Remove()
    AutoEquipBlindfold.Count = -10 -- waits 10 calls of CustomGameLoop (about 5 seconds per loop or 50 seconds in total)
  end

end

safeEventHandler("AutoEquipBlindfold", "CustomGameLoop", "AutoEquipBlindfold.Check", false)
