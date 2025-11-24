-- Alias: ShowNecMobs
-- Attribute: isActive

-- Pattern: ^(?i)shownecmobs ?(on|off)?

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "on" then
    GlobalVar.ShowNecMobs = true
elseif args == "off" then
    GlobalVar.ShowNecMobs = false
else
  showCmdSyntax("Show Necromancer Mobs\n\tSyntax: shownecmobs (on|off)", {{"shownecmobs (on|off)", "show's necromancer mobs in groupie list (always on for Nec)"},})
end

printMessage("ShowNecMobs", "Set to " .. (GlobalVar.ShowNecMobs and "ON" or "OFF"))
