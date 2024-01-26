-- Trigger: Clarify Groupie 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells the group 'clarify

-- Script Code:
TryAction("cast clarify " .. matches[2],5)
