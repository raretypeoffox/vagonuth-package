-- Script: README
-- Attribute: isActive

-- Script Code:
-- Vagonuth Package for AVATAR MUD (avatar.outland.org:3000)
-- README FILE
-- Installed with: lua installPackage("https://github.com/raretypeoffox/vagonuth-package/releases/latest/download/Vagonuth-Package.mpackage")


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


-- To have your function ExampleFunction() called on one of these events, simply add the following
-- line of code to the end of your script (replacing "CustomGameLoop" with whichever event)

-- safeEventHandler("ExampleFunctionEventID", "CustomGameLoop", "ExampleFunction", false)


-- *** Useful Global Variables ***
-- Battle.Combat -- returns true if in combat, otherwise false
-- StatTable.XXX -- table containing many of your core stats and affects, see script GMCP_Vitals
-- StatTable.Position -- string that contains your position, eg "Sleep", "Stand"
-- GlobalVar.GroupMates -- table containing all your groupmates and their vitals
                        -- you can also use this function: IsGroupMate(groupie_name) (boolean)


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
      
      
-- *** MDAY TIPS ***

-- By default, alts will try to put alleg looted into a bag with the keyword alleg.
-- This behaviour can be changed in Item Pickup Trigger -- TODO: change to a static variable

-- *** Preaching ***

-- if you'd like to have specific characters on your altlist do certain actions on preachup
-- add an entry for that character in CustomPreachup in the PreachUp script





