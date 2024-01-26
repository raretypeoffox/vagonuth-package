-- Trigger: BattleEnd 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): is DEAD!!
-- 1 (start of line): You have been KILLED!!
-- 2 (start of line): You flee
-- 3 (regex): ^(\w+) bellows out a bloodcurdling roar!
-- 4 (start of line): You sleep.
-- 5 (substring): has fled
-- 6 (start of line): You have been calmed by
-- 7 (start of line): You form a magical vortex and step into it...
-- 8 (start of line): Cast the spell on whom?
-- 9 (start of line): You sense something large flying at you, and realize, with a thud, that it is the ground!

-- Script Code:
raiseEvent("EndCombat")


