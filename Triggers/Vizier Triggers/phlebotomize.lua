-- Trigger: phlebotomize 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) looks pretty hurt.
-- 1 (regex): ^(.*) is in awful condition.

-- Script Code:
if GlobalVar.NoPhleb then return end

if (tonumber(gmcp.Char.Vitals.lag) <= 3) and (StatTable.Level < 125) then
  if(tonumber(gmcp.Char.Status.opponent_health) < 40 and StatTable.current_mana >= 42) then
    TryCast("cast phlebotomize",5)
  end
end
if (tonumber(gmcp.Char.Vitals.lag) <= 3) and (StatTable.Level >= 125) then
  if(tonumber(gmcp.Char.Status.opponent_health) < 40 and StatTable.current_mana >= 42) then
    TryCast("cast enervate",5)
  end
end
