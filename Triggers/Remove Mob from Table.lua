-- Trigger: Remove Mob from Table 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) is DEAD!!

-- Script Code:
if PSITrigger.GravitasMobs[matches[2]] then
  PSITrigger.GravitasMobs[matches[2]] = nil
end

if TableSize(PSITrigger.GravitasMobs) == 0 then
  AutoCastSetSpell("fandango")
end