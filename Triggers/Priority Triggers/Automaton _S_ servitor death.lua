-- Trigger: Automaton / servitor death 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): A servitor is DEAD!!
-- 1 (start of line): A mighty automaton of earth is DEAD!!
-- 2 (start of line): A furious automaton of fire is DEAD!!
-- 3 (start of line): A sizzling automaton of acid is DEAD!!
-- 4 (start of line): A frosty ice automaton is DEAD!!
-- 5 (start of line): A crackling lightning automaton is DEAD!!
-- 6 (start of line): A crashing water automaton is DEAD!!
-- 7 (start of line): A bellowing air automaton is DEAD!!

-- Script Code:
if (GlobalVar.GroupLeader == StatTable.CharName) then
  send("emote is killing elemental.")
  send(GlobalVar.KillStyle .. " elemental")
end
