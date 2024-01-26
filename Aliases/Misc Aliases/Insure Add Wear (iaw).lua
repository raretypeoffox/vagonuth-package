-- Alias: Insure Add Wear (iaw)
-- Attribute: isActive

-- Pattern: ^(?i)iaw (.*)$

-- Script Code:
if (gmcp.Room.Info.name == "The Center of Thorngate Square" or gmcp.Room.Info.name == "Aelmon's Sanctuary") then
  send("insure add " .. matches[2])
  send("wear " .. matches[2])
else
  print("Error: can't insure in this room")
end