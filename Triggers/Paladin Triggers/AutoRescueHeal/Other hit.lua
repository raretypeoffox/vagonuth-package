-- Trigger: Other hit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<attacker>\w+)'?s? (.*) (?<victim>\w+) (\d+) times?, with (?<dmgdesc>.*) \w+(!|.)
-- 1 (regex): ^(?<attacker>\w+)'?s? (.*) haven't hurt (?<victim>\w+)!

-- Script Code:
local Groupies = Groupies or {}
if (#Groupies == 0) then
  for k,v in ipairs(gmcp.Char.Group.List) do
    table.insert(Groupies,v.name)
  end
end

--display(Groupies)
--print(matches.victim)
GroupiesUnderAttack = GroupiesUnderAttack or {}
if (#Groupies == 0) then
  for k,v in ipairs(gmcp.Char.Group.List) do
    table.insert(Groupies,v.name)
  end
end


if ArrayHasValue(Groupies,matches.victim) then
  --print("Under attack! " .. matches.victim)
  if GroupiesUnderAttack[matches.victim] == nil then
    GroupiesUnderAttack[matches.victim] = 1
  else
    GroupiesUnderAttack[matches.victim] = GroupiesUnderAttack[matches.victim] + 1
  end
end



--print("\n" .. matches.attacker .. " hits " .. matches.victim)

--A psychotic clown's attacks strike Wolthu 4 times, with massacring intensity!   

