-- Trigger: get / drop / give 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(get|drop|give) (\d+|all)?.?(?<items>\w+) ?(?<container>\w+)?$

-- Script Code:
send(matches[1])

