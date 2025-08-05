-- Alias: List of Package Commands
-- Attribute: isActive

-- Pattern: ^cmds?$

-- Script Code:
cmd_name = "Summary of Key Commands/Features Available\nMany of these commands provide more information if you type the command with no argument"

local syntax_tbl = {
  {"<red>Combat Commands",nil},
  {"autokill (on|off)", "whether to attack with killstyle (see below) on leader emote"},
  {"killstyle <style>", "what autokill style to attack with (e.g. kill, bash, backstab)"},
  {"autobash (on|off)", "automatically tries to bash if enemy is standing"},
  {"autotarget (on|off)", "auto tries to killstyle mob when entering/looking in rooms"},
  {"ar (command)", "autorescue package for tanks, type 'ar' for commands"},
  {"autorevive (on|off|#)", "auto revives when hp % falls below #", condition = (StatTable.Race == "Troll")},
  {"prayer <prayer>", "recast <prayer> when the spell falls", condition = (StatTable.Class == "Paladin")},
  {"palrescue (on|off)", "recast <prayer> when the spell falls", condition = (StatTable.Class == "Paladin")},
  {"nextstance <stance>", "overides autostance to manually change to the next bld dance"},
  {"dancepattern <pattern", "set your BLD's dance pattern, type dancepattern for details"},
  {"",nil},
  {"<blue>Caster Commands",nil},
  {"autocast (on|off|<spell>)", "autocasts <spell> during combat [on by default]"},
  {"(1|2|3|4|5)", "set surge level (only surges when mana is high) [2 by default]"},
  {"auto(weapon|armor|bow) <item>", "autoenchants all items named <item> in your inventory"},
  {"autobrill <#>", "default # of brills for autoenchant to try for [2 by default]"},
  {"kin (<spell1> <spell2>|clear)", "set kinetic enhancers spells to autocast (psi's only)", condition = (StatTable.Class == "Psionicist")},
  {"hm (<spell>|clear)", "set high magick (mag's only)"},
  {"",nil},
  {"<yellow>Healer Commands",nil},
  {"autoheal (on|off|<options>)", "autoheal either <target> or <lowest> groupmate [default: lowest]"},
  {"bra (commands)", "auto equips staff then requips armor, tracks charges"},
  {"panth (<spell>|clear)", "sets the cleric's pantheon spell to autocast", condition = (StatTable.Class == "Cleric")},
  {"",nil},
  {"<green>Archer Commands",nil},
  {"autofletch <ammo> <type>", "continues to fletch ammo until \"autofletch stop\" issued"},
  {"autotrack (on|off|echo)", "autotrack will walk to target if on, or echo to group chat"},
  {"",nil},
  {"<purple>General Commands",nil},
  {"queue <command>", "queues a command to be executed after a mob death"},
  {"autolotto", "lotto bot"},
  {"missing", "checks if any groupmates are missing and sends a message to gteel"},
  {"speedwalk <dirs>", "can speedwalk directions, e.g., speedwalk 3sesdede"},
  {"bud-set <name> <colour_code>", "sets name and colour for buddychat tag"},
  {"silent (on|off)", "turns on silent mode (minimal gtell / emotes)"},
  {"pwd <password>", "autologins with password (NOTE: stored in plain text!!)"},
  {"autostance (on|off)", "automatically switch stances on certain classes [default: OFF]"},
  {"autoplane (on|off)", "whether to auto plane when the leader does [default: OFF]"},
  {"ihelp", "explains the inventory list management system"},
  {"loadlayout", "redraws the GUI, helpful cmd when resizing the window etc"},
  {"cmds extra", "additional commands you may find useful, for more advanced users"},
  {"setup", "set up default aliases and configs"},
  {"download", "downloads the latest version of the package"},
  {"fontsize <#>", "set your GUI's font size"},
  {"quit #", "exits the client in # minutes"}
}

showCmdSyntax(cmd_name, syntax_tbl)