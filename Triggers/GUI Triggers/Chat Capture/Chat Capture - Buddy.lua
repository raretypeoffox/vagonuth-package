-- Trigger: Chat Capture - Buddy 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(You) buddychat '(.*)'$
-- 1 (regex): ^(\w+) buddychats '(.*)'$

-- Script Code:
selectString(line,1)
copy()
appendBuffer("BuddyChat")


if not GlobalVar.EchoToMainConsole then
  deselect()
  deleteLine()
end
