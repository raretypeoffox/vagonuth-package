-- Trigger: Auto Rescue - look 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): is here, fighting (\w+).$

-- Script Code:
AR.Rescue(string.lower(matches[2]))