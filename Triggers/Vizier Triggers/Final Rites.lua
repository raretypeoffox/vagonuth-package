-- Trigger: Final Rites 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Your attacks haven't hurt (.*)!
-- 1 (regex): ^Your attack strikes (.*)
-- 2 (regex): ^You start fighting (.*)

-- Script Code:
if(StatTable.SubLevel > 100 or StatTable.Level == 125) then
  if((StatTable.current_mana > 175) and ((StatTable.InjuredCount > 1 or StatTable.CriticalInjured > 0) or StatTable.Level == 125) and not GlobalVar.VizFinalRites) then
    TryAction("cast 'final rites'",2)
  end
end