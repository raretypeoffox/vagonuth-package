if PSITrigger.GravitasMobs[matches[2]] then
  PSITrigger.GravitasMobs[matches[2]] = nil
end

if TableSize(PSITrigger.GravitasMobs) == 0 then
  AutoCastSetSpell("fandango")
end