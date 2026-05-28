-- Trigger: Dagger hand 


-- Trigger Patterns:
-- 0 (start of line): Your hands return to normal.

-- Script Code:
-- now handled by buff manager

if GlobalVar.AutoStance then return end -- Leave it to GameLoop

if StatTable.Level == 51 and StatTable.ArmorClass > -1000 then
  if not StatTable.Fortitude then return end

  Battle.DoAfterCombat("cast 'dagger hand'")
  
end


