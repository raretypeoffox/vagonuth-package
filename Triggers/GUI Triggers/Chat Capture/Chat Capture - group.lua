-- Trigger: Chat Capture - group 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You tell the group '.*'$
-- 1 (regex): ^\w+ tells the group '.*'$
-- 2 (regex): ^\*\w+\* tells the group '.*'$

-- Script Code:
selectString(line,1)
copy()
appendBuffer("GroupChat")
deselect()
deleteLine()