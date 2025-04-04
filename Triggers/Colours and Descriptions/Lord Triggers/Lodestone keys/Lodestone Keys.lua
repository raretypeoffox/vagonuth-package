-- Trigger: Lodestone Keys 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ffff00
-- mBgColour: transparent

-- Trigger Patterns:
-- 0 (substring): A roaring flame dances to and fro, blindingly bright.
-- 1 (substring): A huge amorphous creature of water radiates deadly power.
-- 2 (substring): A face forms from the air, ringed by noxious green gases.
-- 3 (substring): Defying all logic, a collosus of earth moves quickly to attack.

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Lodestone key]")