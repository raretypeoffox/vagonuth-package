-- Trigger: AutoRescue List REMOVE 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells the group 'remove me'$

-- Script Code:
AR.Remove(matches[2])