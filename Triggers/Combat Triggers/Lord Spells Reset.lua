-- Trigger: Lord Spells Reset 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): You become your true self again!

-- Script Code:
if StatTable.Level ~= 125 then return end

printGameMessage("Lord Returned", "Spells and skills reset to lord defaults", "yellow", "white")

local ACisOff = false
if not GlobalVar.AutoCast then ACisOff = true end

Init.Char(StatTable.Class, StatTable.Race, StatTable.Level, StatTable.SubLevel)


if GlobalVar.LordSurgeLevel then 
  GlobalVar.SurgeLevel = GlobalVar.LordSurgeLevel;
  GlobalVar.LordSurgeLevel = nil
end

if ACisOff then AutoCastOFF() else AutoCastStatus(); AutoCastSetGUI() end
