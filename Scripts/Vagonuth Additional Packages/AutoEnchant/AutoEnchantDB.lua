-- Script: AutoEnchantDB
-- Attribute: isActive

-- Script Code:
local AutoEnchantDB = db:create("AutoEnchant Database",
  {
    Enchants = {
              EnchantTime = db:Timestamp("CURRENT_TIMESTAMP"),
              CharName = "",
              CharRace = "",
              CharClass = "",
              CharLevel = 0,
              CharSubLevel = 0,
              CharStr = "",
              CharInt = "",
              CharWis = "",
              CharDex = "",
              CharCon = "",
              CharWorship = "",
              Day = "",
              Month = "",
              Tingle = 0,
              Artificer = 0,
              EnchantItem = "",
              EnchantItemType = "",
              EnchantItemFlags = "",
              EnchantItemBaseLevel = 0,
              EnchantItemLevel = 0,
              EnchantItemMinDmg = 0,
              EnchantItemMaxDmg = 0,
              EnchantItemAC = 0,
              EnchantOutcome = ""
     
              }
  })
  
function AutoEnchantDBAdd(outcome)

  db:add(AutoEnchantDB.Enchants, {
    CharName = gmcp.Char.Status.character_name,
    CharRace = gmcp.Char.Status.race,
    CharClass = gmcp.Char.Status.class,
    CharLevel = tonumber(gmcp.Char.Status.level),
    CharSubLevel = tonumber(gmcp.Char.Status.sublevel),
    CharStr = tonumber(gmcp.Char.Status.str),
    CharInt = tonumber(gmcp.Char.Status.int),
    CharWis = tonumber(gmcp.Char.Status.wis),
    CharDex = tonumber(gmcp.Char.Status.dex),
    CharCon = tonumber(gmcp.Char.Status.con),
    CharWorship = AltList.Chars[StatTable.CharName].Worship or "",
    Day = AutoEnchantTable.Day,
    Month = AutoEnchantTable.Month,
    Tingle = AutoEnchantTable.Tingle,
    Artificer = AutoEnchantTable.Artificer,
    EnchantItem = AutoEnchantTable.ItemName,
    EnchantItemType = AutoEnchantTable.ItemIDType,
    EnchantItemFlags = AutoEnchantTable.ItemFlags,
    EnchantItemBaseLevel = AutoEnchantTable.ItemBaseLevel,
    EnchantItemLevel = AutoEnchantTable.ItemLevel,
    EnchantItemMinDmg = AutoEnchantTable.ItemMinDmg,
    EnchantItemMaxDmg = AutoEnchantTable.ItemMaxDmg,
    EnchantItemAC = AutoEnchantTable.ItemAC;
    EnchantOutcome = outcome,
    })
  
end

function AutoEnchantDBQuery()
  temp = db:fetch(AutoEnchantDB.Enchants)
  for k,v in pairs(temp) do
    display(v)
    break
    --print(temp[k].EnchantOutcome)
  end
end