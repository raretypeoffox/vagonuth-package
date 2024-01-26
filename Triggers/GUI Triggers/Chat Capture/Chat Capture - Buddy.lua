-- Trigger: Chat Capture - Buddy 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(You) buddychat '(.*)'$
-- 1 (regex): ^(\w+) buddychats '(.*)'$

-- Script Code:
selectString(line,1)
copy()
appendBuffer("BuddyChat")
deselect()
deleteLine()
--line = string.gsub(line, " buddychats", ":")
--cecho("BuddyChat", matches[2] .. ": " .. matches[3])