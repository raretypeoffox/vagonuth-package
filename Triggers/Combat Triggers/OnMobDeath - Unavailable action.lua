-- Trigger: OnMobDeath - Unavailable action
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You are not trained in .+\.$
-- 1 (regex): ^You lack the training to do that\.$
-- 2 (regex): ^Shield bash takes practice, and you don't seem to have practiced\.$
-- 3 (regex): ^You better leave the heroic acts to those trained for them\.$
-- 4 (regex): ^You are insufficiently skilled in quickcast\.$
-- 5 (regex): ^You aren't familiar with counter attacks\.$
-- 6 (regex): ^You have no idea what a bladetrance feels like\.$
-- 7 (regex): ^Your body has no special powers of revival\.$
-- 8 (regex): ^You can't breathe fire naturally!$
-- 9 (regex): ^You can't work yourself into a frenzy naturally!$
-- 10 (regex): ^You are not able to summon your inner fire!$
-- 11 (regex): ^This is not a valid racial for your race\. Try typing it out$
-- 12 (regex): ^Alert what now\?$
-- 13 (regex): ^You lack the motivational savvy to rally your group-mates\.$

-- Script Code:
if type(BuffManager) == "table" and type(BuffManager.BlockLastAttemptedAction) == "function" then
  BuffManager.BlockLastAttemptedAction("unavailable")
end
