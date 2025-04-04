-- Trigger: Migraine 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (start of line): You feel a slight headache growing stronger...

-- Script Code:

if (StatTable.WaterBreathingExhaust == nil) then
  Battle.NextAct("cast 'water breathing'", 5)

elseif IsClass({"Priest", "Paladin", "Ripper", "Druid",}) then
  if (StatTable.CureLightExhaust == nil) then
    Battle.NextAct("cast 'cure light'", 5)
  elseif (StatTable.CureSeriousExhaust == nil) then
    Battle.NextAct("cast 'cure serious'", 5)
  elseif (StatTable.CureCriticalExhaust == nil) then
    Battle.NextAct("cast 'cure critical'", 5) 
  end
else 
  if (StatTable.FireballExhaust == nil) then
    Battle.NextAct("cast fireball", 5)
  elseif StatTable.AcidBlastExhaust == nil then
    Battle.NextAct("cast 'acid blast'", 5) 
  elseif StatTable.ChillTouchExhaust == nil then
    Battle.NextAct("cast 'chill touch'", 5)
  elseif StatTable.BurningHandsExhaust == nil then
    Battle.NextAct("cast 'burning hands'", 5)  
  elseif StatTable.LightningBoltExhaust == nil then
    Battle.NextAct("cast 'lightning bolt'", 5)  
  end
end


