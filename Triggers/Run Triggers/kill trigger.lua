-- Trigger: kill trigger 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<attacker>\w+) is killing (?<victim>.+?)(?:\.)?$

-- Script Code:
-- Autokill is off or autotargetting, ignore
if not GlobalVar.AutoKill or GlobalVar.AutoTarget then
  return
end

-- Already in combat
if Battle.Combat then
  return
end



-- Only pick up emotes from GroupLeader
if GMCP_name(matches.attacker) ~= GlobalVar.GroupLeader and not GroupLeader() then
  return
end

if GroupLeader() then return end

local ks = string.lower(GlobalVar.KillStyle)
local NextActionLag = 1

-- Only pounce if we're above 50% hp
if ks == "pounce" and (StatTable.current_health / StatTable.max_health) < 0.5 then
  ks = "kill"
elseif ks == "shadowcast" then
  if(StatTable.Class == "Black Circle Initiate" and (StatTable.SubLevel > 101 or StatTable.Level == 125)) then
    ks = "Shadowcast fear"
  else
    ks = "surp"
  end
end

if GlobalVar.AutoBash then ks = "bash" end

local NextAction = ks .. " " .. matches.victim

Battle.NextAct(NextAction, NextActionLag)
