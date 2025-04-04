-- Trigger: Lord Spell on Mid 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): You become a mere shadow of your former self...

-- Script Code:
if StatTable.Level ~= 125 then return end

printGameMessage("Lord on Midgaard", "Spells and skills reset to hero defaults", "yellow", "white")

local ACisOff = false
if not GlobalVar.AutoCast then ACisOff = true end
GlobalVar.LordSurgeLevel = GlobalVar.SurgeLevel

Init.Char(StatTable.Class, StatTable.Race, 51, 999)


if ACisOff then AutoCastOFF() else AutoCastStatus(); AutoCastSetGUI() end

