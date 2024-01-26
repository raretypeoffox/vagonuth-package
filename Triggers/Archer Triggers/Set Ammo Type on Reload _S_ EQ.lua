-- Trigger: Set Ammo Type on Reload / EQ 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You hold \d+ (.*) in your hands.$
-- 1 (regex): ^<held>              \[?.*?\]? ?\d+ (.*)$

-- Script Code:
GlobalVar.ReloadType = matches[2] 

--You hold 182 piercing arrows in your hands.
--<held>              102 piercing arrows
--<held>              [Pristine  ] 131 piercing arrows