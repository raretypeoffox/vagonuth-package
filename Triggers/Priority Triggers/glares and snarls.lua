-- Trigger: glares and snarls 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): (.*) GLARES at \w+ and SNARLS!

-- Script Code:
local function getWord(str)
    local firstWord, secondWord = string.match(str, "(%S+)%s*(%S*)")
    
    if secondWord and #secondWord > 0 then
        return secondWord
    else
        return firstWord
    end
end

-- if a mob glares and snarls and we're not in combat, try attacking it
if Battle.Combat then return end

mob_target = getWord(matches[2])

if mob_target == "Someone" then
  if gmcp.Room.Info.zone == "{*HERO*} Ibn     Aculeata Jatha-La" then mob_target = "wasp"
  else return; end
end




if (StatTable.current_health / StatTable.max_health) < 0.5 then return end

if GlobalVar.AutoKill and GlobalVar.KillStyle and (GlobalVar.KillStyle ~= "kill" or AR.Status) then
  TryAction(GlobalVar.KillStyle .. " " .. mob_target, 5)
end

