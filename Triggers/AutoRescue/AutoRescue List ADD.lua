-- Trigger: AutoRescue List ADD 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells the group 'add me'$

-- Script Code:
AR.Add(matches[2])