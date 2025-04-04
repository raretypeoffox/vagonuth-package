-- Script: Immo Script

-- Script Code:
function ImmoMob(mobname)
  if not StatTable.Immolation then
    TryCast("cast immolation " .. mobname, 5)
  elseif not StatTable.AstralPrison then
    TryCast("cast 'astral prison' " .. mobname, 5)
  end
end