-- Trigger: BattleStart 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): is in excellent condition.
-- 1 (substring): has a few scratches.
-- 2 (substring): has some small wounds and bruises.
-- 3 (substring): has quite a few wounds.
-- 4 (substring): has some big nasty wounds and scratches.
-- 5 (substring): looks pretty hurt.
-- 6 (substring): is in awful condition.
-- 7 (start of line): Screaming a battle-cry, you enter the fray!
-- 8 (start of line): Your attack
-- 9 (start of line): You start fighting

-- Script Code:

if string.find(line,"Your attack flow is enhanced for identical cutting weapons of weight") ~= nil then
  return
end

raiseEvent("OnCombat")

