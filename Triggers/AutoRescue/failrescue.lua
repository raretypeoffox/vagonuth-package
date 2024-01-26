-- Trigger: failrescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You fail to rescue (\w+) from.*!

-- Script Code:
AR.Rescue(string.lower(matches[2]))
