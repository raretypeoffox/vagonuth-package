-- Trigger: OnMobDeath - Unavailable action 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You are not trained in .+\.$
-- 1 (regex): ^You lack the training to do that\.$
-- 2 (regex): ^You are insufficiently skilled in quickcast\.$
-- 3 (regex): ^Your body has no special powers of revival\.$
-- 4 (regex): ^You can't breathe fire naturally!$
-- 5 (regex): ^You can't work yourself into a frenzy naturally!$
-- 6 (regex): ^You are not able to summon your inner fire!$
-- 7 (regex): ^This is not a valid racial for your race\. Try typing it out$
-- 8 (regex): ^Alert what now\?$
-- 9 (regex): ^You lack the motivational savvy to rally your group-mates\.$

-- Script Code:
if type(BuffManager) == "table" and type(BuffManager.BlockLastAttemptedAction) == "function" then
  BuffManager.BlockLastAttemptedAction("unavailable")
end