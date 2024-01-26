-- Trigger: BattleTracker - Mob Health (all) 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): is in excellent condition.
-- 1 (substring): has a few scratches.
-- 2 (substring): has some small wounds and bruises.
-- 3 (substring): has quite a few wounds.
-- 4 (substring): has some big nasty wounds and scratches.
-- 5 (substring): looks pretty hurt.
-- 6 (substring): is in awful condition.
-- 7 (substring): is DEAD!!

-- Script Code:
BattleTracker.MobHealth = matches[1]
BattleTracker.RoundOver()
BattleTracker.MobHealth = ""

