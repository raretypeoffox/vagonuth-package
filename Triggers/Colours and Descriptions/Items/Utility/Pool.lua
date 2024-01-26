-- Trigger: Pool 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): (Magical) An eerie pool of blood has formed here!

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .."<blue> [Pool]")

--if (StatTable.Class == "Vizier") then
--  if (tonumber(StatTable.Level) == 51 and tonumber(StatTable.SubLevel) > 100) then
--    send("cast 'sanguen pax' pool")
--  elseif(tonumber(StatTable.Level) > 51) then
--    send("cast 'sanguen pax' pool")
--  end
--end

