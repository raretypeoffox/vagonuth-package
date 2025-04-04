-- Trigger: Gearbox 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): The seal on the next gate is released as the Deathwish crumples to the ground.

-- Script Code:
if (GlobalVar.GUI) then
  printGameMessage("Unlock", "Gearbox unlocked", "purple", "yellow")
end