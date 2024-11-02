-- Vagonuth Package for AVATAR MUD (avatar.outland.org:3000)
-- README FILE
-- Installed with: lua installPackage("https://github.com/raretypeoffox/vagonuth-package/releases/latest/download/Vagonuth-Package.mpackage")


-- *** MDAY TIPS ***

-- By default, alts will try to put alleg looted into a bag with the keyword alleg.
-- This behaviour can be changed in Item Pickup Trigger -- TODO: change to a static variable

-- *** Preaching ***

-- if you'd like to have specific characters on your altlist do certain actions on preachup
-- add an entry for that character in CustomPreachup in the PreachUp script

-- *** Code Customization ***
-- This package auto-updates thus try not to edit the code in the package directly
-- but rather extend through your own triggers/aliases/scripts kept outside of the
-- Vagonuth folders. If you find any bugs that you'd like fixed in the main package,
-- please reach out to Vagonuth/Xykoi/Olodagh on AVATAR or raretypeoffox on Discord.

-- *** Code Customization -- Events ***
-- This package raises custom events that allows you to run code in your own scripts
-- on certain events without having to edit the package code directly. Events you can
-- use include:

-- "CustomProfileInit" -- called 5 seconds after you login. Good for setting up initial variables
-- "CustomGameLoop" -- called continously every 5 seconds. Good for checking StatTable variables
-- "OnMobDeath" -- called whenever a mob dies
-- "OnPreachUp" -- called when a group leader preaches up the group
-- "OnQuit" -- called whenever the player types quit to leave the game
-- "OnCombat" -- called when you enter a fight
-- "EndCombat" -- called when you end the fight
-- "OnLevel" -- called when you level


-- To have your function ExampleFunction() called on one of these events, simply add the following
-- line of code to the end of your script (replacing "CustomGameLoop" with whichever event)

-- safeEventHandler("ExampleFunctionEventID", "CustomGameLoop", "ExampleFunction", false)


-- *** Useful Global Variables ***
-- Battle.Combat -- returns true if in combat, otherwise false
-- StatTable.XXX -- table containing many of your core stats and affects, see script GMCP_Vitals
-- StatTable.Position -- string that contains your position, eg "Sleep", "Stand"
-- GlobalVar.GroupMates -- table containing all your groupmates and their vitals
                        -- you can also use this function: IsGroupMate(groupie_name) (boolean)
-- Battle.Combat -- boolean, true is in combat, otherwise false


-- *** Useful Functions ***

-- GMCP_name(char_name) -- input a characters name, will return their name in GMCP's format
                        -- ie, first letter capitalized only, eg: Vagonuth
                        -- useful for standardizing how you use names in your code
                        
-- printGameMessage(title, message, colour, colour_message)
                        -- prints a message in the bottom right corner window
                        -- used to display status messages
                        -- colour_message is optional
                        
-- beep()               -- Used to play a quick sound to alert you
-- QuickBeep()

-- Grouped()                 -- returns true if grouped, otherwise false 
-- GroupLeader()             -- returns true if you are the group leader, otherwise false
-- IsGroupMate(groupie_name) -- return true if group_name is a player in our group
-- IsGroupLeader(groupie_name) -- returns true if "groupie_name" is the the group leader, otherwise false

-- SafeArea()           -- returns true if Sanctum or Thorngate

-- TryAction(action, wait) -- will attempt an action only if the action hasn't already been tried in the current wait period
                           -- e.g. TryAction("racial revival", 10)
                           
-- Safe Mudlet Functions will handle keeping tracking of all your temp triggers, events, timers and events
      -- safeTempTimer(id, time, func, repeating)
      -- safeKillTimer(id)
      -- safeEventHandler(id, event_name, func, one_shot)
      -- safeKillEventHandler(id)
      -- safeTempTrigger(id, pattern, func, triggerType, expireAfter)
      -- safeKillTrigger(id)
      -- safeTempAlias(id, pattern, func)
      -- safeKillAlias(id)

-- *** Scripts Overview ***

-- Below is a summary of the scripts in this package and what they do.
-- The most important scripts are:
-- Init GlobalVars
-- GMCP Vitals
-- GMCP Group
-- GameLoop
-- Vagonuth GUI Package
-- Battle.Init
-- OnMobDeath

-- *Overview*
-- Events:
-- gmcp.Char.Status / Vitals update -> calls GMCP_Vitals() -> updates GUI with UpdateGUI()
-- gmcp.Char.Group update -> calls GMCP_Group() -> updates GUI with UpdateGroupGUI()

-- Loops:
-- every 5 seconds, call GameLoop() -> if in combat, call GameLoopClass() and GameLoopRace()
-- On the start of combat, call Battle.OnCombat() -> starts Battle.Act() loop until combat ends
------ if autocasting, calls: Battle.AutoCast() / if autohealing, calls: Battle.AutoHeal()


-- * Profile Startup (Init GlobalVars) *

-- All Mudlet and first login of a character startup/init is done in "Init GlobalVars"
-- this script will load our GlobalVar table (via Init.GlobalVars()) which contains most of our global config
-- variables. It also calls Init.Profile() five seconds after you login with a new char. This function
-- sets up all your character specific variables (eg autocast for mages, autoheal for clerics, etc). Any
-- default race/class behaviour you want to setup should be done here.

-- * The Helper Scripts (the other scripts unders Priority Scripts) *
-- These scripts contain a number of useful functions that are used throughout the package.
-- SafeMudlet: provides a way to track and kill all the tempTriggers, tempTimers and temp events
--             generally recommended to use this for all your temps, ie, safeTempTrigger not tempTrigger
-- General: formatting functions, string parsing, etc.
-- Table and Array:  often used functions for working with tables and arrays. Note that if you assign a
--                   variable to an existing array in lua, this will only be a reference not a copy.
--                   When copy tables/arrays, especially when they themselves contain tables/arrays, use deepcopy()
-- Static variables: constant variables, user can edit these
-- Game functions: misc general game helper functions
-- TryAction: allows you to attempt an action once every X seconds, useful to prevent spamming commands
--            generally when sending a command off a trigger, you should use TryAction("command", 5) (eg once every 5 secs max)

-- *Support Packages*
-- Written by others
-- Cross Profile Communication (CPC): allows you to send commands to other profile windows on MDAY, type "#help" for details
-- Wait: provides the ability to wait during a script, see "2s" trigger for an example on how it works

-- *GMCP*
-- GMCP_Vitals: this script is event driven, eg, it'll run everytime the server sends gmcp.Char.Status or gmcp.Char.Vitals
--              the function that's called on event will set up the important StatTable table, which tracks all of our
--              characters current stats that we use throughout this package (eg, hp, mana).
--              The AffectsLookup table contains all the spells/affects affecting us (eg what you see when you type "aff" in game)
--              If you want a new StatTable affects var, simply add it to the table, eg for StatTable.Sanctuary, add:
--              ["Spell: sanctuary"] = "Sanctuary"
-- GMCP_Group:  this script is event driven on gmcp.Char.Group.List, which we request every 5 seconds from the server via a timer
--              it updates the GUI, GlobalVar.GroupMates[] (used many places), sets up any PSI triggers and finds the lowest health
--              group member (used by cleric types to autoheal / viz to monitor)
-- GMCP_Room:   minor script called on event gmcp.Room.Info

-- *GameLoop*
-- Important script that runs every 5 seconds. Manages all the race / class actions that aren't based on triggers
-- examples include tanks switch stances, blds switching dances, troll autorevive, priest out of combat stuff
-- if you want to add new class/race logic, add it to GameLoopClass or GameLoopRace -- note these are only called when in combat
-- if you need out of combat logic, add it to GameLoop

-- *Vagonuth GUI Package*
-- Avatar Layout: sets the main layout for the GUI, including the main window, group window, status window, chat windows, etc
-- Layout Update: updates all the labels in the GUI, called by GameLoop every 5 seconds
--                add custome Race/Class labels using the setNextAvailableLabel* functions
-- Group Update:  updates the group window, called by GMCP_Group every 5 seconds (assuming we recv gmcp.Char.Group.List)

-- *Vagonuth Additional Packages*
-- AutoEnchant: autoenchant script, see script for details
-- AutoCast: logic for auto swapping between single and AoE spells, extra logic for lord wzd sig spell
-- BattleScript: important script that manages all the combat, autocast and autoheal logic
-- OnMobDeath: processes the OnMobDeath queue (eg spells and skills used after killing a mob, like sanc)
-- AutoRescue: autorescue script
-- AutoTarget: autotarget script, including target exclusions
-- CheckMissing: check for missing groupmates
-- Damage Counter: combat damage counter
-- RunsStats: run / xp tracker
-- Battle Tracker: track how many mobs you're fighting for GUI and paladin rescue purposes
-- PreachUp Script: logic for getting spells from bots / self spelling during preachup
-- Online Players: keeps a table of all players online in GlobalVar.OnlinePlayers
-- MobListUpdate: tracks all the mobs you see and saves to MobList
-- GroupOrder script: automates group ordering when you're leading and preachup
-- AutoEquip Blindfold: script for managing Psi's yorimandil's blindfold
-- Psi Weapon Triggers: script for picking up your own/others psi weapons
-- Direction Script: tracks which way you've been moving (handy for maxes - alias showdirs)
-- Tank Direction Trigger script: implements gtell <yourname> <dir> by leader when running a tank
-- AutoLotto - lotto bot script
-- Alpha scripts - scripts still being worked on
