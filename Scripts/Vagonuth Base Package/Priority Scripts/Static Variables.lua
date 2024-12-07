-- Script: Static Variables
-- Attribute: isActive

-- Script Code:
StaticVars = StaticVars or {}

-- NOTE
-- FOR ALL CHARACTER NAMES IN THESE VARIABLES
-- Use the GMCP format, ie, first letter upper case, remainder lowercase
-- eg Xykoi (correct), NOT xykoi, XYKOI, XYKoi etc. (incorrect)

-- Maximum amount of groupmates to show on the left-hand side (large monitors may support more)
StaticVars.MaxGroupLabels = 32 

-- Update bots as required
StaticVars.DruidBots = { "Viridi", "FlutterFly", "Yorrick", "Idle"}
StaticVars.PsiBots = {"Neodox", "Xykith", "Raisteel"}
StaticVars.PrsBots = {"Martyr", "Gobo", "Eiri", "Arby", "Textual", "Logic"}

-- Some defualts
StaticVars.DarkRaces = {"Drow", "Duergar", "Gargoyle", "Kobold", "Deep Gnome", "Demonseed", "Troll"}
StaticVars.FrenzyClasses = {"Berserker", "Archer", "Assassin", "Fusilier", "Soldier", "Psionicist", "Rogue", "Black Cirle Initiate"}
StaticVars.GameMsgsChatOutput = "GameChat"

-- Priest Config: for soul cleanse trigger, set your characters bag name (eg loot) and default held (eg lodestone) for the trigger to work properly
StaticVars.SoulCleanse = {}
StaticVars.SoulCleanse.Defaults = {"loot", "sceptre"}
StaticVars.SoulCleanse = {
  ["Ayas"] = {"loot", "sceptre"},
  ["Zephyra"] = {"loot", "sceptre"},
} -- Make sure to use normal capitalization, eg, first letter capitalized, remainder lower case

-- List of default pantheon spells for your chars, edit as you like
StaticVars.Default_Pantheon = {
  ["Halgod"] = "artificer blessing",
  ["Hezzur"] = "glorious conquest",
}  -- Make sure to use normal capitalization, eg, first letter capitalized, remainder lower case

StaticVars.PantheonNumber = 4 -- number of mobs to wait for before activating grim harvest or unholy rampage


-- Edit to the name you want pgem's passed to on MDAY
StaticVars.PGemHolder = "Halgod"

-- default bag to put items into
StaticVars.AllegBagName = "alleg"  
StaticVars.LootBagName = "loot"

-- What hp % we consider a groupie injured or critical
-- affects a number of healing mechanics
StaticVars.InjuredPercent = 0.85
StaticVars.CriticalPercent = 0.6

StaticVars.Junk = {
["small wooden lockbox"] = "small wooden lockbox",
["lab memo"] = "memo",
["silver broad sword"] = "silver broad sword",
["dark blue sleeves"] = "dark blue sleeves",
["scimitar of fire"] = "scimitar fire",
["black pentagram"] = "pentagram",
["angelic lance"] = "angel lance",
["kzinti pickaxe"] = "pickaxe",
["kzinti melee claw"] = "kzinti melee claw lordgear",
["huge bastard sword"] = "bastard sword",
["shiv"] = "shiv",
["ethereal shield"] = "ethereal shield",
["obsidian shield"] = "obsidian shield",
["obsidian spear"] = "obsidian spear",
["military cloak"] = "military cloak",
["banded mail uniform"] = "banded mail uniform",
["obsidian crossbow"] = "obsidian crossbow",
["clutch of lightning arrows"] = "lightning arrows",
["clutch of ice arrows"] = "ice arrows",
["brace of lightning bolts"] = "brace lightning bolts",
["ivory bow"] = "ivory bow tusk",
["obsidian dagger"] = "obsidian dagger",
["servant's dagger"] = "servant's dagger",
["silver dagger"] = "silver dagger",
["ornate staff"] = "ornate staff",
["ivory hilted silver dagger"] = "ivory hilted silver dagger",
["black soft leather boots"] = "black soft leather boots",
["glowing silver sword"] = "glowing silver sword",
["dull silver sword"] = "dull silver sword",
["jagged silver sword"] = "jagged silver sword",
["jet black robe"] = "jet black robe",
["3-pronged iron claw"] = "3-pronged iron claw",
["cruel iron bow"] = "cruel iron bow",
["big stone slab"] = "stone slab",
["giant's club"] = "giant's club",
["long salamander spear"] = "long salamander spear",
["vial of murky fluid"] = "potion vial murky",
["flowing dark blue robe"] = "flowing dark blue robe",
["armor of the Purifying Flame"] = "armor red white flame lordgear",
["steel tower shield"] = "steel tower shield",
["flowing dark blue robe"] = "flowing dark blue robe",
["gold hilted flaming silver sword"] = "gold hilted flaming silver sword",
["ivory hilted silver dagger"] = "ivory hilted silver dagger",
--["black bracer"] = "black bracer",
["silver long sword"] = "silver long sword",
["loose fitting black silk pants"] = "loose fitting black silk pants",
["black master's robe"] = "black master's master robe",
["crystalline spear"] = "crystalline spear",
["mithril and glass leg plates"] = "mithril glass leg plates",
["mithril and glass chestplate"] = "mithril glass chestplate",
["mithril and glass helm"] = "mithril glass helm",
["mithril and glass arm plates"] = "mithril glass arm plates",
["mithril and glass boots"] = "mithril glass boots",
["mithril and glass bracer"] = "mithril glass bracer",
["mithril and glass girth"] = "mithril glass girth",
["lightning crossbow"] = "lightning crossbow",
["florentine longsword"] = "florentine longsword",
["crystal sabre"] = "crystal sabre",
["thought shield"] = "thought shield",
["ruby dagger"] = "ruby dagger",
["silver trident"] = "silver trident",
["copper spear"] = "copper spear",
["deadly manople"] = "manople deadly sword",
["bronze flyssa"] = "flyssa bronze blade",
["silver spear wrapped in ivy"] = "silver spear ivy",
["poisonous kzin claws"] = "poisonous claws",
["ethereal Glass Shield"] = "astral shield ethereal",
["Astral Chestplate"] = "astral chestplate armor ethereal",
["circular band of malachite"] = "malachite band lordgear",
["silvery knife"] = "silvery knife",
["silvery dagger"] = "silvery dagger",
["silvery sword"] = "silvery sword",
["splint mail vest"] = "vest splint",
["pair of splint mail sleeves"] = "sleeves splint",
["splint mail skirt"] = "skirt splint",
["thin two-handed sword"] = "sword thin two two-handed",
["extremely sharp and thin sword"] = "thin sword",
["carrion beetle mandible"] = "carrion beetle mandible",
["lava-rock blackjack"] = "lava rock blackjack lordgear",
["fire dagger"] = "fire dagger lordgear",
["gauntlets of protection"] = "gauntlets protection",
["broken silver blade"] = "blade githyanki gith silver lordgear",
["dark green robe"] = "dark green robe",
["rusty axe"] = "rusty axe",
["leg of a table"] = "leg table",
["black sabre"] = "black sabre lordwield",
["stone-capped spear"] = "stone capped spear",
["polished splintmail"] = "splint splintmail",
["dwarven sling"] = "dwarven sling",
["hording claw"] = "hording claw",
["kzinti hunting claw"] = "kzinti hunting claw lordgear",
["animal hides"] = "animal hides lordgear",
["mithrilmail skirt"] = "mithrilmail skirt",
["mithrilmail collar"] = "mithrilmail collar",
["mithrilmail belt"] = "mithrilmail belt",
["mithrilmail sleeves"] = "mithrilmail sleeves",
["mithrilmail cowl"] =  "mithrilmail cowl",
["mithrilmail armor"] =  "mithrilmail armor",
["heartstopping stiletto"] = "heartstopping stiletto",
["vicious vial"] = "vicious vial",
["necrokukri"] = "necrokukri curved knife",
["dagger tinged with green"] = "dagger green",
["sunset-red dagger"] = "dagger sunset-red",
["darkwood shield"] = "darkwood shield",
["blood-mithril skirt"] = "blood-mithril hauberk skirt chain",
["blood-mithril cowl"] = "blood-mithril cowl mithril chain",
["blood-mithril hauberk"] = "blood-mithril hauberk mithril chain ",
["blood-mithril mantle"] = "blood-mithril mantle mithril chain",
["lightning axe"] = "lightning axe",
["ice blade"] = "ice blade",
["dark red mace"] = "red dark mace lordgear",
["iron-studded mace"] = "iron mace",
["iron trident"] = "iron trident",
["small, deadly sword"] = "small deadly sword",
["large band of elemental earth"] = "elemental earth band lordgear",
["barbed black spear"] = "black spear barbed lordgear",
["crimson spear"] = "crimson spear",
["glass halberd"] = "glass halberd",
["ephemeral blade"] = "ephemeral blade",
["darkwood shield"] = "darkwood shield",
["iron barbed flail"] = "iron barbed flail",
["mist of Tarterus"] = "mist tarterus lordgear",
["sharp blood-covered sword"] = "sword blood-covered",
["jagged spear of crystal-clear ice"] = "ice spear jagged",
["cracked stone spear"] = "spear stone cracked",
["watchman's shield"] = "watchman's shield round smooth obsidian silver",
["fang axe"] = "fang axe beast darkwood white",
["serated barb"] = "serated barb",
["obsidian bow"] = "obsidian bow smooth arc",
["grey robe lined with crystals"] = "crystals grey robe",
["silvery bow"] = "silvery bow",
["watershape"] = "watershape",
["pink ice ring"] = "pink ice ring",
["wide strip of hard flesh"] = "hard flesh strip lordgear",
["bow of light"] = "light bow lordgear",
["skeletal sword"] = "skeletal sword",
["enormous carved bone staff"] = "bone staff",
["coral Shield"] = "coral shield lordgear",
["Astral Longsword"] = "astral longsword",
["Lightspear"] = "lightspear",
["glass sphere wrapped in green web"] = "glass sphere green web",
["green web cloak"] = "web cloak green",
["emerald-encrusted silver shield"] = "emerald shield silver",
["sultan's Greaves"] = "coral sultan greaves",
["public Approval"] = "public approval",
["plate of the oblivious defender"] = "armor plate oblivious defender",
["helm of the oblivious defender"] = "helmet oblivious defender",
["gleam of fading hope"] = "gleam ember flicker fading hope",
["violet psi-blade"] = "psi-blade energy violet",
["smoky psi-blade"] = "psi-blade energy smoky",
--["pure psi-blade"] = "psi-blade energy pure",
["emerald-encrusted silver shield"] = "emerald shield silver",
["dull blood-smeared sword"] = "blood-smeared sword",
["hurling hammer"] = "hurling hammer",
["sturdy oaken staff"] = "oaken staff",
["(Dull) a slaves pick axe"] = "pick axe slave",
["standard issue lantern"] = "standard issue lantern",
["sacrificial dagger"] = "sacrificial dagger blade",
["girtablilu stinger"] = "girtablilu stinger",
["curved girtablilu longbow"] = "girtablilu longbow bow",
["witches broom"] = "witches broom",
["old but nasty morningstar"] = "old morningstar",
["honed dirk"] = "dirk",
["sinister-looking blackjack"] = "blackjack stick",
["heavily tarnished scythe"] = "tarnished scythe",
["skeletal bow"] = "skeletal bow",
["black buckler"] = "black spike buckler skin lordgear",
["two-handed broad sword"] = "broad sword",
["blade of the Crusaders"] = "crusader blade lordgear",
["stone demonhide"] = "stone demonhide",
["crimson spear"] = "crimson spear",
["blue-green demonscale wrap"] = "blue-green demonscale wrap",
["Staff of Torment"] = "staff torment",
["sturdy scimitar"] = "scimitar",
["reinforced buckler"] = "buckler shield",


-- situtionally decent items, you may want to comment out if you're new:
["Great Shield, \"Tyranny\""] = "great shield tyranny lordgear",
["lord's head chalice"] = "chalice head lord",
["sword of ascension"] = " sword ascension",
["white dragonscale vambrace"] = "white dragonscale vambrace",

}

DamageVerbTable = DamageVerbTable or {}

DamageVerbTable["nil"] = {0, 0, "white"}
DamageVerbTable["pathetic"] = {1, 2, "white"}
DamageVerbTable["weak"] = {3, 4, "white"}
DamageVerbTable["intensity"] = {5, 6, "white"}
DamageVerbTable["punishing"] = {7, 8, "white"}
DamageVerbTable["surprising"] = {9, 10, "white"}
DamageVerbTable["amazing"] = {11, 14, "white"}
DamageVerbTable["astonishing"] = {15, 18, "white"}
DamageVerbTable["mauling"] = {19, 22, "white"}
DamageVerbTable["MAULING"] = {23, 26, "white"}
DamageVerbTable["*MAULING*"] = {27, 30, "white"}
DamageVerbTable["**MAULING**"] = {31, 34, "white"}
DamageVerbTable["***MAULING***"] = {35, 38, "white"}
DamageVerbTable["decimating"] = {39, 42, "white"}
DamageVerbTable["DECIMATING"] = {43, 46, "white"}
DamageVerbTable["*DECIMATING*"] = {47, 50, "white"}
DamageVerbTable["**DECIMATING**"] = {51, 55, "white"}
DamageVerbTable["***DECIMATING***"] = {56, 60, "white"}
DamageVerbTable["devastating"] = {61, 65, "white"}
DamageVerbTable["DEVASTATING"] = {66, 70, "white"}
DamageVerbTable["*DEVASTATING*"] = {71, 75, "white"}
DamageVerbTable["**DEVASTATING**"] = {76, 80, "white"}
DamageVerbTable["***DEVASTATING***"] = {81, 85, "white"}
DamageVerbTable["pulverizing"] = {86, 90, "white"}
DamageVerbTable["PULVERIZING"] = {91, 95, "white"}
DamageVerbTable["*PULVERIZING*"] = {96, 100, "white"}
DamageVerbTable["**PULVERIZING**"] = {101, 110, "white"}
DamageVerbTable["***PULVERIZING***"] = {111, 120, "white"}
DamageVerbTable["maiming"] = {121, 130, "white"}
DamageVerbTable["MAIMING"] = {131, 140, "white"}
DamageVerbTable["*MAIMING*"] = {141, 150, "white"}
DamageVerbTable["**MAIMING**"] = {151, 160, "white"}
DamageVerbTable["***MAIMING***"] = {161, 170, "white"}
DamageVerbTable["eviscerating"] = {171, 180, "white"}
DamageVerbTable["EVISCERATING"] = {181, 190, "white"}
DamageVerbTable["*EVISCERATING*"] = {191, 200, "white"}
DamageVerbTable["**EVISCERATING**"] = {201, 225, "white"}
DamageVerbTable["***EVISCERATING***"] = {226, 250, "white"}
DamageVerbTable["mutilating"] = {251, 275, "pink"}
DamageVerbTable["MUTILATING"] = {276, 300, "pink"}
DamageVerbTable["*MUTILATING*"] = {301, 325, "pink"}
DamageVerbTable["**MUTILATING**"] = {326, 350, "pink"}
DamageVerbTable["***MUTILATING***"] = {351, 375, "pink"}
DamageVerbTable["disemboweling"] = {376, 400, "pink"}
DamageVerbTable["DISEMBOWELING"] = {401, 425, "pink"}
DamageVerbTable["*DISEMBOWELING*"] = {426, 450, "pink"}
DamageVerbTable["**DISEMBOWELING**"] = {451, 475, "pink"}
DamageVerbTable["***DISEMBOWELING***"] = {476, 500, "green"}
DamageVerbTable["dismembering"] = {501, 550, "green"}
DamageVerbTable["DISMEMBERING"] = {551, 600, "green"}
DamageVerbTable["*DISMEMBERING*"] = {601, 650, "green"}
DamageVerbTable["**DISMEMBERING**"] = {651, 700, "green"}
DamageVerbTable["***DISMEMBERING***"] = {701, 750, "green"}
DamageVerbTable["massacring"] = {751, 800, "green"}
DamageVerbTable["MASSACRING"] = {801, 850, "green"}
DamageVerbTable["*MASSACRING*"] = {851, 900, "green"}
DamageVerbTable["**MASSACRING**"] = {901, 950, "green"}
DamageVerbTable["***MASSACRING***"] = {951, 1000, "green"}
DamageVerbTable["mangling"] = {1001, 1100, "yellow"}
DamageVerbTable["MANGLING"] = {1101, 1200, "yellow"}
DamageVerbTable["*MANGLING*"] = {1201, 1300, "yellow"}
DamageVerbTable["**MANGLING**"] = {1301, 1400, "yellow"}
DamageVerbTable["***MANGLING***"] = {1401, 1500, "yellow"}
DamageVerbTable["demolishing"] = {1501, 1600, "yellow"}
DamageVerbTable["DEMOLISHING"] = {1601, 1700, "yellow"}
DamageVerbTable["*DEMOLISHING*"] = {1701, 1800, "yellow"}
DamageVerbTable["**DEMOLISHING**"] = {1801, 1900, "yellow"}
DamageVerbTable["***DEMOLISHING***"] = {1901, 2000, "yellow"}
DamageVerbTable["obliterating"] = {2001, 2200, "red"}
DamageVerbTable["OBLITERATING"] = {2201, 2400, "red"}
DamageVerbTable["*OBLITERATING*"] = {2401, 2600, "red"}
DamageVerbTable["**OBLITERATING**"] = {2601, 2800, "red"}
DamageVerbTable["***OBLITERATING***"] = {2801, 3000, "red"}
DamageVerbTable["annihilating"] = {3001, 3200, "red"}
DamageVerbTable["ANNIHILATING"] = {3201, 3400, "red"}
DamageVerbTable["*ANNIHILATING*"] = {3401, 3600, "red"}
DamageVerbTable["**ANNIHILATING**"] = {3601, 3800, "red"}
DamageVerbTable["***ANNIHILATING***"] = {3801, 4100, "red"}
DamageVerbTable[">***ANNIHILATING***<"] = {4001, 4500, "red"}
DamageVerbTable[">>***ANNIHILATING***<<"] = {4501, 5000, "red"}
DamageVerbTable[">>>***ANNIHILATING***<<<"] = {5001, 5500, "red"}
DamageVerbTable[">>>>***ANNIHILATING***<<<<"] = {5501, 6000, "red"}
DamageVerbTable["eradicating"] = {6001, 6500, "blue"}
DamageVerbTable["ERADICATING"] = {6500, 7000, "blue"}
DamageVerbTable["*ERADICATING*"] = {7000, 7500, "blue"}
DamageVerbTable["**ERADICATING**"] = {7500, 7800, "blue"}
DamageVerbTable["***ERADICATING***"] = {7800, 8200, "blue"}
DamageVerbTable[">***ERADICATING***<"] = {8200, 8500, "blue"}
DamageVerbTable[">>***ERADICATING***<<"] = {8500, 9000, "blue"}
DamageVerbTable[">>>***ERADICATING***<<<"] = {9000, 9500, "blue"}
DamageVerbTable[">>>>***ERADICATING***<<<<"] = {9500, 1000, "blue"}
DamageVerbTable["vaporizing"] = {10000, 11000, "blue"}
DamageVerbTable["VAPORIZING"] = {11000, 12000, "blue"}
DamageVerbTable["*VAPORIZING*"] = {12000, 13000, "blue"}
DamageVerbTable["**VAPORIZING**"] = {13000, 14000, "blue"}
DamageVerbTable["***VAPORIZING***"] = {14000, 15000, "blue"}
DamageVerbTable[">***VAPORIZING***<"] = {15000, 16500, "blue"}
DamageVerbTable[">>***VAPORIZING***<<"] = {16500, 18000, "blue"}
DamageVerbTable[">>>***VAPORIZING***<<<"] = {18000, 19000, "blue"}
DamageVerbTable[">>>>***VAPORIZING***<<<<"] = {19000, 20000, "blue"}
DamageVerbTable["destructive"] = {20000, 21000, "purple"}
DamageVerbTable["DESTRUCTIVE"] = {21000, 22000, "purple"}
DamageVerbTable["*DESTRUCTIVE*"] = {22000, 23000, "purple"}
DamageVerbTable["**DESTRUCTIVE**"] = {23000, 24000, "purple"}
DamageVerbTable["***DESTRUCTIVE***"] = {24000, 25000, "purple"}
DamageVerbTable["****DESTRUCTIVE****"] = {25000, 26000, "purple"}
DamageVerbTable[">****DESTRUCTIVE****<"] = {26000, 27000, "purple"}
DamageVerbTable[">>****DESTRUCTIVE****<<"] = {27000, 28000, "purple"}
DamageVerbTable[">>>****DESTRUCTIVE****<<<"] = {28000, 29000, "purple"}
DamageVerbTable[">>>>****DESTRUCTIVE****<<<<"] = {29000, 30000, "purple"}
DamageVerbTable["=>>>>***DESTRUCTIVE***<<<<="] = {30000, 31000, "purple"}
DamageVerbTable["==>>>>**DESTRUCTIVE**<<<<=="] = {31000, 32000, "purple"}
DamageVerbTable["===>>>>*DESTRUCTIVE*<<<<==="] = {32000, 33000, "purple"}
DamageVerbTable["====>>>>DESTRUCTIVE<<<<===="] = {33000, 34000, "purple"}
DamageVerbTable["extreme"] = {34000, 35000, "dark_violet"}
DamageVerbTable["EXTREME"] = {35000, 36000, "dark_violet"}
DamageVerbTable["*EXTREME*"] = {36000, 37000, "dark_violet"}
DamageVerbTable["**EXTREME**"] = {37000, 38000, "dark_violet"}
DamageVerbTable["***EXTREME***"] = {38000, 39000, "dark_violet"}
DamageVerbTable["****EXTREME****"] = {39000, 40000, "dark_violet"}
DamageVerbTable[">****EXTREME****<"] = {40000, 41000, "dark_violet"}
DamageVerbTable[">>****EXTREME****<<"] = {41000, 42000, "dark_violet"}
DamageVerbTable[">>>****EXTREME****<<<"] = {42000, 43000, "dark_violet"}
DamageVerbTable[">>>>****EXTREME****<<<<"] = {43000, 44500, "dark_violet"}
DamageVerbTable["=>>>>***EXTREME***<<<<="] = {44500, 47000, "dark_violet"}
DamageVerbTable["==>>>>**EXTREME**<<<<=="] = {47000, 48000, "dark_violet"}
DamageVerbTable["===>>>>*EXTREME*<<<<==="] = {48000, 50000, "dark_violet"}
DamageVerbTable["====>>>>EXTREME<<<<===="] = {50000, 51000, "dark_violet"}
DamageVerbTable["porcine"] = {51000, 53000, "gold"}
DamageVerbTable["PORCINE"] = {53000, 55000, "gold"}
DamageVerbTable["*PORCINE*"] = {55000, 57000, "gold"}
DamageVerbTable["**PORCINE**"] = {57000, 59000, "gold"}
DamageVerbTable["***PORCINE***"] = {59000, 61000, "gold"}
DamageVerbTable[">***PORCINE***<"] = {61000, 65000, "gold"}
DamageVerbTable[">>***PORCINE***<<"] = {65000, 70000, "gold"}
DamageVerbTable[">>>***PORCINE***<<<"] = {70000, 75000, "gold"}
DamageVerbTable[">>>>***PORCINE***<<<<"] = {75000, 80000, "gold"}
DamageVerbTable["Divine"] = {80000, 100000, "gold"}
DamageVerbTable["daunting"] = {100000, 200000, "gold"}








