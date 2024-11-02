-- Trigger: Groupmate Frenzy 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells the group '\w+ has lost Frenzy'$
-- 1 (regex): ^\*?(\w+)\*? tells the group 'frenzy pl
-- 2 (regex): ^\*?(\w+)\*? tells the group 'frenzy'$

-- Script Code:
if GroupLeader() or (StatTable.Class == "Berserker" or StatTable.Class == "Priest" or StatTable.Class == "Shadowfist" or StatTable.Class == "Sorcerer") or (StatTable.Level < 51 or StatTable.SubLevel < 41) or StatTable.Alignment < 300 then
  return
end

if Battle.Combat then
  OnMobDeath("cast frenzy " .. matches[2])
  printGameMessage("Request", "Added frenzy on " .. matches[2] .. " to queue")
else
  send("cast frenzy " .. matches[2])
  printGameMessage("Request", "Casting frenzy on " .. matches[2])
end