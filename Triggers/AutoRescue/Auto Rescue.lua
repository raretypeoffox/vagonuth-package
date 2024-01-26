-- Trigger: Auto Rescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.*(attacks|attack) (strike|strikes) (\w+)

-- Script Code:
AR.Rescue(string.lower(matches[4]))