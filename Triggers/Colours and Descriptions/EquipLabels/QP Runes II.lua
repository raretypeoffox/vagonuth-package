-- Trigger: QP Runes II 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): the fae rune for '(Insanity|Fire|Disease|Pain|Destruction|Enslavement|Despair)'

-- Script Code:
local qpvalue = 0

if matches[2] == "Destruction" or matches[2] == "Enslavement" then
  qpvalue = 12
elseif matches[2] == 'Despair' then
  qpvalue = 10
else
  qpvalue = 5
end

cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<green> [" .. qpvalue .. "QP Rune]")