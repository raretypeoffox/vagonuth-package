-- Trigger: Sanguen 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): There is a sickly red glow as a blood pool congeals!
-- 1 (substring): An eerie pool of blood has formed here!
-- 2 (regex): ^(\w+) dives into the pool.
-- 3 (substring): There is a sickly red glow as a blood pool congeals next to

-- Script Code:
if (StatTable.Level == 51 and StatTable.SubLevel >= 100 and StatTable.current_mana > 150) then
  if (StatTable.current_mana > StatTable.max_mana and StatTable.current_mana > 700 and StatTable.CriticalInjured > 1) then
    TryAction("augment 3",2)
    TryAction("cast sang pool",2)
    TryAction("augment off",2)
  elseif (StatTable.current_mana > (StatTable.max_mana * 0.85) and StatTable.current_mana > 500 and StatTable.CriticalInjured > 0) then
    TryAction("augment 2",2)
    TryAction("cast sang pool",2)
    TryAction("augment off",2)
  else
    TryAction("cast sang pool",2)
  end
elseif (StatTable.Level >= 125 and StatTable.current_mana > 150) then
  if (StatTable.current_mana > StatTable.max_mana and StatTable.current_mana > 700 and (StatTable.CriticalInjured > 1 or StatTable.InjuredCount > 3)) then
    TryAction("augment 4", 2)
    TryAction("cast vitae pool",2)
    TryAction("augment off",2)
  elseif (StatTable.current_mana > StatTable.max_mana and StatTable.current_mana > 700 and (StatTable.CriticalInjured > 0 or StatTable.InjuredCount > 2)) then
    TryAction("augment 3", 2)
    TryAction("cast vitae pool",2)
    TryAction("augment off",2)
  elseif (StatTable.current_mana > (StatTable.max_mana * 0.85) and StatTable.current_mana > 500 and (StatTable.CriticalInjured > 0 or StatTable.InjuredCount >2)) then
    TryAction("augment 2", 2)
    TryAction("cast vitae pool",2)
    TryAction("augment off",2)
  else
    TryAction("cast vitae pool",2)
  end
end
enableTrigger("Final Rites")
