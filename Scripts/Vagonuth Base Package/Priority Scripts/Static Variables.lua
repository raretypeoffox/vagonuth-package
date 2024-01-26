-- Script: Static Variables
-- Attribute: isActive

-- Script Code:
StaticVars = StaticVars or {}

-- Update bots as required
StaticVars.DruidBots = { "Viridi", "FlutterFly", "Yorrick", "Idle"}
StaticVars.PsiBots = {"Neodox", "Xykith", "Raisteel"}
StaticVars.PrsBots = {"Martyr", "Gobo", "Eiri", "Arby"}

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

-- Edit to the name you want pgem's passed to on MDAY
StaticVars.PGemHolder = "Halgod"

-- default bag to put alleg items into
StaticVars.AllegBagName = "alleg"  

StaticVars.Junk = {
["scimitar of fire"] = "scimitar fire",
["black pentagram"] = "black pentagram",
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
["black bracer"] = "black bracer",
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
["grey robe lined with crystals"] = "crystals grey robe",
["silvery bow"] = "silvery bow",
["watershape"] = "watershape",
["small wooden lockbox"] = "small wooden lockbox",
["wide strip of hard flesh"] = "hard flesh strip lordgear",
["bow of light"] = "light bow lordgear",
["skeletal sword"] = "skeletal sword",
["enormous carved bone staff"] = "bone staff",
["coral Shield"] = "coral shield lordgear",
["Astral Longsword"] = "astral longsword",
["Lightspear"] = "lightspear",


}




