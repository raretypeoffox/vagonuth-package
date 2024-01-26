-- Alias: prayer
-- Attribute: isActive

-- Pattern: ^prayer\s*(.*)

-- Script Code:
if (matches[2] == "") then
  print("Syntax: prayer <name> - autocasts prayer (for paladins)")
else
  print("Prayer set to " .. matches[2])
  GlobalVar.PrayerName = matches[2]
  if (StatTable.Prayer == nil) then send("cast prayer '" .. GlobalVar.PrayerName .. "'") end
end