-- Trigger: Migraine 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (start of line): You feel a slight headache growing stronger...

-- Script Code:

if (StatTable.WaterBreathingExhaust == nil) then
  --Battle.Interupt("cast water", 5)
  Battle.NextAct("cast water", 5)
elseif (StatTable.GiantStrengthExhaust == nil) then
  --Battle.Interupt("cast 'giant strength'", 5)
  Battle.NextAct("cast 'giant strength'", 5)
elseif StatTable.FlyExhaust == nil then
  --Battle.Interupt("cast fly", 5)
  Battle.NextAct("cast fly", 5)
else
  --Battle.Interupt("cast endurance", 5)
  Battle.NextAct("cast 'cure light'", 5)
end




-- spells learned by every class (ex-bzk): water breathing, fly, giant str, endurance
