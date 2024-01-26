-- Trigger: Chat Capture - tell 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #00ffff
-- mBgColour: #000000

-- Trigger Patterns:
-- 0 (regex): ^You tell \w+ in your dreams '.*'$
-- 1 (regex): ^You dream of \w+ telling you '.*'$
-- 2 (regex): ^You tell \w+ '.*'$
-- 3 (regex): ^\w+ tells you '.*'$
-- 4 (regex): \w+ is asleep, but you tell \w+
-- 5 (regex): ^You dream of telling \w+
-- 6 (regex): ^An Immortal tells you '.*'$
-- 7 (regex): ^You dream of an Immortal telling you '.*'$

-- Script Code:
selectString(line,1)
copy()
appendBuffer("Channels")
deselect()
deleteLine()

