-- Trigger: Treasure Hunter 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): naeadonna's choker
-- 1 (substring): a floating circle of books
-- 2 (substring): exaltra's mirror
-- 3 (substring): some astral powder
-- 4 (substring): the amulet of the Cat's Eye
-- 5 (substring): crown of crystal
-- 6 (substring): an orb of gith
-- 7 (substring): a jade bracer
-- 8 (substring): the armband of the Unseen
-- 9 (substring): sandblasted emerald
-- 10 (substring): Treaty of purity of faith
-- 11 (substring): Orb of Bravery
-- 12 (substring): a green silken sarong
-- 13 (substring): a silver iguana
-- 14 (substring): Rod of the wicked rulers
-- 15 (start of line): (Black Aura) A demon kicks debris in the empty vault, looking quite disgruntled.
-- 16 (substring): A darkenbeast feeds on a burnt corpse.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<green> [Treasure Hunter]")
