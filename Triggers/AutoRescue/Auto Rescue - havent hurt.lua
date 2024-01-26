-- Trigger: Auto Rescue - havent hurt 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.* (attack|attacks) haven't hurt (\w+)!

-- Script Code:
AR.Rescue(string.lower(matches[3]))