-- Trigger: longshot 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): \* tells the group 'ls (.*)'

-- Script Code:
local MinLongshotHP = 1200
local MyClass = StatTable.Class or ""

-- comment out the line below if you wish to ls as fusilier
if MyClass == "Fusilier" then return end -- Fus normally using sling, not able to ls

if StatTable.current_health < MinLongshotHP then
  if not GlobalVar.Silent and StatTable.max_health > MinLongshotHP then send("gtell Longshot: need more than " .. MinLongshotHP .. "hp", false) end
  printGameMessage("Longshot", "Didn't fire, need more than " .. MinLongshotHP .. "hp")
  return
end

if MyClass == "Archer" or MyClass == "Druid" or MyClass == "Soldier" or MyClass == "Fusilier" then
  send("ls " .. matches[2])
elseif MyClass == "Assassin" and (StatTable.SubLevel > 250 or StatTable.Level == 125) then
  send("snipe " .. matches[2])
elseif MyClass == "Assassin" and StatTable.SubLevel > 95 then
  send("ls " .. matches[2])
end