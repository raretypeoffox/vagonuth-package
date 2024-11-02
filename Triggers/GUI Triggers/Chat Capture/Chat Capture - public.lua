-- Trigger: Chat Capture - public 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+ lordchats '.*'$
-- 1 (regex): ^\w+ herochats '.*'$
-- 2 (regex): ^You chat '.*'$
-- 3 (regex): ^\[?\S+\]? n?(c|C)hats '.*'$
-- 4 (regex): ^You lordchat '.*'$
-- 5 (regex): ^You herochat '.*'$
-- 6 (regex): ^\w+ quests '.*'$
-- 7 (regex): ^You quest '.*'$
-- 8 (start of line): [CREATION INFO]:
-- 9 (start of line): [HERO INFO]:
-- 10 (regex): ^An Immortal herochats '.*'$
-- 11 (regex): ^An Immortal lordchats '.*'$
-- 12 (regex): ^An Immortal chats '.*'$
-- 13 (regex): ^An Immortal nChats '.*'$
-- 14 (start of line): [GROUP INFO]:
-- 15 (start of line): [DEATH INFO]:
-- 16 (regex): ^\w+ teamchats '.*'$
-- 17 (regex): ^You teamchat '.*'$
-- 18 (regex): ^\w+ legendchats '.*'$
-- 19 (regex): ^You legendchat '.*'$

-- Script Code:
selectString(line,1)
copy()
appendBuffer("Channels")
deselect()
deleteLine()