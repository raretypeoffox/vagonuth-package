-- Trigger: Adult Elemental 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): Blazing brightly, this fire elemental hisses and growls.
-- 1 (substring): Sizzling and spitting, this acid lake swells and splatters.
-- 2 (substring): A crystalline ice matrix crackles angrily here.
-- 3 (substring): Glaring about with a featureless face, this elemental growls.
-- 4 (substring): Snapping and cracking against the crystals, this bolt is angry!
-- 5 (substring): This heavy wave crashes against the stone around it, roaring.
-- 6 (substring): This howling wind whips all before it.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<red> [AGGIE] Adult")