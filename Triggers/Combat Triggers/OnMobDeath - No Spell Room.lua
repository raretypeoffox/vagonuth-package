-- Trigger: OnMobDeath - No Spell Room
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): This room blocks your mind from spellcasting!

-- Script Code:
if type(BuffManager) == "table" and type(BuffManager.PauseSpellcasting) == "function" then
  BuffManager.PauseSpellcasting(10)
end
