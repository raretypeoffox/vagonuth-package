-- Trigger: Chat Capture - says 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You say '.*'$
-- 1 (regex): ^\w+ says '.*'$
-- 2 (regex): ^An Immortal says '.*'$
-- 3 (regex): ^\w+ ask.*$
-- 4 (regex): ^\w+ exclaim.*$

-- Script Code:
cecho("Channels", "<ansiYellow>" .. line .. "\n")