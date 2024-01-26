-- Trigger: KDR Gear 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): the habiliments of purity
-- 1 (substring): pure psi-blade
-- 2 (substring): an ant chakram
-- 3 (substring):  wings of superior elegance
-- 4 (substring): a pink ice ring
-- 5 (regex): nothing$
-- 6 (substring): a blue-green demonscale wrap
-- 7 (substring): a ring of major imagery

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .."<purple> [KDR Gear]")