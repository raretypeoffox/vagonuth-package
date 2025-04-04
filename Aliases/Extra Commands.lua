-- Alias: Extra Commands
-- Attribute: isActive

-- Pattern: ^cmds extra?$

-- Script Code:
cmd_name = "Summary of Extra Commands/Features Available\nAdvanced commands for power users"

local syntax_tbl = {
  {"<red>Helpful on Runs", nil},
  {"ldirs", "Gtells the directions for chaos if the tablet is on the floor"},
  {"gt-(law|chaos)", "Gtells the rewards from law/chaos"},
  {"run-wasp", "speedwalks from kelsee to wasps"},
  {"veil max", "bld goes into max veil trance"},
  {"giveall <item>", "gives each groupmate one of an item (make sure they're in the same room)"},
  {"(show|clear)dirs", "shows the directions you recently moved"},
  {"g-adv <msg>", "advertises your group beckon message on lord/hero/chat"},
  {"",nil},
  {"<blue>Group Leader Commands", nil},
  {"gt max veil", nil},
  {"gt inspire", nil},
  {"gt dance check", nil},
  {"gt pick <dir>", nil},
  {"gt [get/drop] <item> [container]", "for mday, can have groupies drop/get (eg gt drop all.lockbox)"},
  {"gt [ablut/wear all]", "for mday, have groupies ablut/wear all"},
  
  
  
  {"",nil},
  {"<yellow>Spell Cost Checks", nil},
  {"spellcostcheck", "shows your spell cost reductions"},
  {"spellcostcomp <race>", "converts your mana into another race's mana (eg spellcostcomp high elf)"},
  {"spellcosttrans <amt> <race>", "converts another race's mana to your race (eg spellcosttrans 60000 troll)"},

  {"",nil},
  
  {"<white>Misc.", nil},
  {"showstats", "show all your xp / gains starts since you launched the mudlet session"},
  {"charstars <character>", "reports one of your characters stats"},
  {"repcharstats <char> <chat>", "reports character's HP/MP stats to chat channel"},
  {"iaw <equip", "insures and wears a piece of equipment"},
  {"autotrack", "different tracking options, see autotrack for details"},
  {"dropjunk", "drops all junk in inventory"},
  

}

showCmdSyntax(cmd_name, syntax_tbl)