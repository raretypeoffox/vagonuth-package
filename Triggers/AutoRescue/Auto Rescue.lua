-- Trigger: Auto Rescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.*'s (.*) (strike|strikes) (\w+)'?s? ?(\w+)?

-- Script Code:
local AOE_attacks = {
  "blast of acid",
  "blast of flame",
  "blast of frost",
  "blast of gas",
  "blast of lightning",
  "meteor swarm",
  "acid rain",
  "shard storm",
  "cataclysm",
  "vampire touch",
  "Meteor Swarm",
  "FLASH",
  "field of death",
  "earthbind",
  "smash",
  "freeze",
  "disintegrate",
  
  
  
}


if ArrayHasValue(AOE_attacks, matches[2]) then
  AR.Debug("\n<white>AutoRescue:<ansi_white> didn't add to rescue list, AOE attack")
  return
end



if matches[5] and matches[5] == "shade" then return end
--print("\n")
--printMessage("Debug", "Attempting to rescue: " .. string.lower(matches[4]))
AR.Rescue(string.lower(matches[4]))

--^.*(attacks|attack) (strike|strikes) (\w+)



-- old: ^.*(attacks|attack)? (strike|strikes) (\w+)'?s? ?(\w+)?

-- new: ^.*'s (.*) (strike|strikes) (\w+)'?s? ?(\w+)?