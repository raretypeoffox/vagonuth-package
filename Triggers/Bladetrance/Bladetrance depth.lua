-- Trigger: Bladetrance depth 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Bladetrance depth: (\d+)$

-- Script Code:
StatTable.BladetranceLevel = tonumber(matches[2])