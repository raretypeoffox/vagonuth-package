-- Trigger: Other hit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<attacker>.*)'s attacks? strikes? (?<victim>.*) (\d+) times?, with (?<dmgdesc>.*) \w+(!|.)
-- 1 (regex): ^(?<attacker>.*)'s attacks haven't hurt (?<victim>\w+)!
-- 2 (regex): ^(?<attacker>.*)'s (?<spell>.*) strikes? (?<victim>.*) with (?<dmgdesc>.*) \w+(!|.)

-- Script Code:
-- config setup:
--[-battleother] You will see others' hits condensed to one line.
--[-battleself ] You will see your hits condensed to one line.
--[-battlenone ] You will see other players' hits.

-- Obsolete:
-- ^(?<attacker>\w+)'?s? (.*) (?<victim>\w+) (\d+) times?, with (?<dmgdesc>.*) \w+(!|.)
-- ^(?<attacker>\w+)'?s? (.*) haven't hurt (?<victim>\w+)!
-- ^(?<attacker>.*)'s (.*) (?<victim>\w+) (\d+) times?, with (?<dmgdesc>.*) \w+(!|.)
-- ^(?<attacker>.*)'s (.*) haven't hurt (?<victim>\w+)!

--print("\n" .. matches.attacker .. " hits " .. matches.victim)

GroupiesUnderAttack = GroupiesUnderAttack or {}

-- GMCP always reports names as capital first letter, remainder lowercase
-- where as game reports character names as they were registered (e.g. could be all caps)
-- Adjust names pulled from the regex match to match the GMCP format
local groupie_victim = GMCP_name(matches.victim)
local groupie_attacker = GMCP_name(matches.attacker)

if groupie_victim == "You" then groupie_victim = GMCP_name(StatTable.CharName) end

-- Code to track how many of our groupmates are tanking
-- Was it our group mate hit? Exclude AOE attacks (eg blast of gas, meteor swarm)
if (GlobalVar.GroupMates[groupie_victim]) 
  and (matches.spell ~= "blast of gas")
  and (matches.spell ~= "acid rain")
  and (matches.spell ~= "shard storm")
  and (matches.spell ~= "cataclysm strikes") 
  and (matches.spell ~= "meteor swarm")
  and (matches.spell ~= "Meteor Swarm") then

  -- Add 1 to how many mobs are attacking our groupmate
  if GroupiesUnderAttack[groupie_victim] == nil then
    GroupiesUnderAttack[groupie_victim] = 1
  else
    GroupiesUnderAttack[groupie_victim] = GroupiesUnderAttack[groupie_victim] + 1
  end
end

-- For the damge counter, if our group mate is the attacker, add their damage to the counter
if GlobalVar.GroupMates[groupie_attacker] and matches.dmgdesc then
  --print("DamageCounter.AddDmg("..matches.attacker..", "..matches.dmgdesc..")")
  local bash = false
  if matches.spell == "bash" then bash = true end
  DamageCounter.AddDmg(matches.attacker, matches.dmgdesc, bash)
  --print(matches.attacker, matches.dmgdesc)
end

--if not Battle.Combat and (GlobalVar.GroupMates[groupie_victim] or GlobalVar.GroupMates[groupie_attacker]) then 
--  raiseEvent("OnCombat") 
--end
