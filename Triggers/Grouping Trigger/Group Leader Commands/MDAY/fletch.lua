-- Trigger: fletch 


-- Trigger Patterns:
-- 0 (regex): ^fletch (?<arrow>\w+) ?(?<type>\w+)?$

-- Script Code:


arrow = matches.arrow
type = matches.type or ""



send("autofletch " .. items .. " " .. container)