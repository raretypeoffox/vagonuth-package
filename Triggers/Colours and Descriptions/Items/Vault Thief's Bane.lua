-- Trigger: Vault Thief's Bane 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): soft nubuc hide
-- 1 (substring): glazed gith hide
-- 2 (substring): embossed hide
-- 3 (substring): whole hide of a merman
-- 4 (substring): hide of an unlucky human
-- 5 (substring): corpse of a gith thief
-- 6 (substring): corpse of Zlatan
-- 7 (substring): corpse of a merman thief
-- 8 (substring): corpse of The unlucky adventurer

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<green> [Thief Bane]")