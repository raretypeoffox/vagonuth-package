-- Trigger: Chakra Look 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<mobname>.*)'s (?<chakra>\w+) chakra pulses with energy.$
-- 1 (regex): ^(?<mobname>.*)'s (?<chakra>\w+) chakra pulses with brilliant energy.$

-- Script Code:
if Battle.EnemiesChakra[firstToLower(matches.mobname)] and Battle.EnemiesChakra[firstToLower(matches.mobname)] ~= matches.chakra then
  -- two mobs with the same name in the same room and their chakra's don't match, throw them away :(
  Battle.EnemiesChakra[firstToLower(matches.mobname)] = nil
else
  Battle.EnemiesChakra[firstToLower(matches.mobname)] = matches.chakra
end