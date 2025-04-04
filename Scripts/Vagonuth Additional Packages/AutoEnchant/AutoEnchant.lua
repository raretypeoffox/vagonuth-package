-- Script: AutoEnchant
-- Attribute: isActive

-- Script Code:

AutoEnchantTable = AutoEnchantTable or {}

-- Customizable Variables
AutoEnchantTable.BrillTarget = AutoEnchantTable.BrillTarget or 2

-- Global Variables for Enchanting Module
AutoEnchantTable.Status = AutoEnchantTable.Status or false
AutoEnchantTable.Item = AutoEnchantTable.Item or ""
AutoEnchantTable.ItemType = AutoEnchantTable.ItemType or ""
AutoEnchantTable.ID = AutoEnchantTable.ID or 0
AutoEnchantTable.Container = AutoEnchantTable.Container or "icesphere"
AutoEnchantTable.Brills = AutoEnchantTable.Brills or 0
AutoEnchantTable.debug = AutoEnchantTable.debug or true
AutoEnchantTable.BaseLevel = 125 --51 for hero, 125 for lord


-- For DB
AutoEnchantTable.ItemName = AutoEnchantTable.ItemName or ""
AutoEnchantTable.ItemIDType = AutoEnchantTable.ItemType or ""
AutoEnchantTable.ItemFlags = AutoEnchantTable.ItemFlags or ""
AutoEnchantTable.ItemBaseLevel = AutoEnchantTable.ItemBaseLevel or 0
AutoEnchantTable.ItemLevel = AutoEnchantTable.ItemLevel or 0
AutoEnchantTable.ItemMinDmg = AutoEnchantTable.ItemMinDmg or 0
AutoEnchantTable.ItemMaxDmg = AutoEnchantTable.ItemMaxDmg or 0
AutoEnchantTable.ItemAC = AutoEnchantTable.ItemAC or 0
AutoEnchantTable.Day = AutoEnchantTable.Day or ""
AutoEnchantTable.Month = AutoEnchantTable.Month or ""
AutoEnchantTable.Tingle = AutoEnchantTable.Tingle or 0
AutoEnchantTable.Artificer = AutoEnchantTable.Artificer or 0

-- Unused atm
AutoEnchantTable.ItemBrills = AutoEnchantTable.ItemBrills or 0




function AutoEnchantInit(item, type)
  AutoEnchantTable.Status = true
  AutoEnchantTable.Item = item
  AutoEnchantTable.ItemType = type

  AutoEnchantReset()
end

function AutoEnchantReset()
  AutoEnchantTable.ID = 0
  AutoEnchantTable.ItemName = ""
  AutoEnchantTable.ItemIDType = ""
  AutoEnchantTable.ItemFlags = ""
  AutoEnchantTable.ItemBaseLevel = 0
  AutoEnchantTable.ItemLevel = 0
  AutoEnchantTable.ItemMinDmg = 0
  AutoEnchantTable.ItemMaxDmg = 0
  AutoEnchantTable.ItemAC = 0
  AutoEnchantTable.Day = ""
  AutoEnchantTable.Month = ""
  AutoEnchantTable.Tingle = 0
  AutoEnchantTable.Artificer = 0
  AutoEnchantTable.Brills = 0
    
  AutoEnchantTry()
end

function AutoEnchantTry()
  local AutoEnchantWeaponMaxLevel = 4
  local AutoEnchantArmorMaxLevel = 2

  if (AutoEnchantTable.ID == 0) then
    send("look " .. AutoEnchantTable.Item)
    send("time")
    send("slearn enchant " .. AutoEnchantTable.ItemType)
    send("affects")
    send("cast identify " .. AutoEnchantTable.Item)
    -- AutoEnchantTable.ID = 1 --moved to trigger
  else
    if ((AutoEnchantTable.ItemType == "bow" or AutoEnchantTable.ItemType == "weapon") and AutoEnchantTable.ItemLevel > (AutoEnchantTable.BaseLevel + AutoEnchantWeaponMaxLevel)) then
      AutoEnchantPrint(AutoEnchantTable.ItemType .. " is level " .. AutoEnchantTable.ItemLevel .. ", putting in bag")
      send("put " .. AutoEnchantTable.Item .. " " .. AutoEnchantTable.Container)
      AutoEnchantReset()
    elseif (AutoEnchantTable.ItemType == "armor" and AutoEnchantTable.ItemLevel > (AutoEnchantTable.BaseLevel + AutoEnchantArmorMaxLevel)) then
      send("put " .. AutoEnchantTable.Item .. " " .. AutoEnchantTable.Container)
      AutoEnchantReset()
    else
      send("cast 'enchant " .. AutoEnchantTable.ItemType .. "' " .. AutoEnchantTable.Item)
    end
      
  end

end


function AutoEnchantBrill()
  AutoEnchantTable.Brills = AutoEnchantTable.Brills + 1
  print("")
  print("AutoEnchantTable.Brills " .. AutoEnchantTable.Brills .. " >= " .. AutoEnchantTable.BrillTarget .. " AutoEnchantTable.BrillTarget")
  if (AutoEnchantTable.Brills >= AutoEnchantTable.BrillTarget) then
    -- todo: make a better solution
    AutoEnchantPrint("Success! Moving to bag")
    send("put " .. AutoEnchantTable.Item .. " " .. AutoEnchantTable.Container)
    AutoEnchantReset()
  else
   AutoEnchantTry()
  end
end

function AutoEnchantAddLevel()
  local WeaponMaxLevel = 4 -- should usually be 4 but switch to 2 when autoweapon being used on special armor (eg gith hands)
  local ArmorMaxLevel = 2

  AutoEnchantTable.ItemLevel = AutoEnchantTable.ItemLevel + 1
  
  if ((AutoEnchantTable.ItemType == "bow" or AutoEnchantTable.ItemType == "weapon") and AutoEnchantTable.ItemLevel > (AutoEnchantTable.BaseLevel + WeaponMaxLevel)) then
      printGameMessage("AutoEnchant", "Max Level, moving to bag")
      send("put " .. AutoEnchantTable.Item .. " " .. AutoEnchantTable.Container)
      AutoEnchantReset()
      return false
  elseif (AutoEnchantTable.ItemType == "armor" and AutoEnchantTable.ItemLevel > (AutoEnchantTable.BaseLevel + ArmorMaxLevel)) then
      printGameMessage("AutoEnchant", "Max Level, moving to bag")
      send("put " .. AutoEnchantTable.Item .. " " .. AutoEnchantTable.Container)
      AutoEnchantReset()
      return false
  else
    return true
  end
end

function AutoEnchantDebug(debug_message)
 if (AutoEnchantTable.debug) then
    print("")
    print(debug_message)
 end
end

function AutoEnchantPrint(print_message)
  if GlobalVar.GUI then
    printGameMessage("AutoEnchant", print_message)
  else
    print(print_message)
  end
end