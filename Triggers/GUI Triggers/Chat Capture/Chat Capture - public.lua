-- Trigger: Chat Capture - public 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+ lordchats .*$
-- 1 (regex): ^\w+ herochats .*$
-- 2 (regex): ^You chat '.*'$
-- 3 (regex): ^\w+ chats '.*'$
-- 4 (regex): ^\S+ nchat.*'$
-- 5 (regex): ^You lordchat '.*'$
-- 6 (regex): ^You herochat '.*'$
-- 7 (regex): ^\S+ nChat.*'$
-- 8 (regex): ^\w+ quests.*$
-- 9 (regex): ^You quest.*$
-- 10 (start of line): [CREATION INFO]:
-- 11 (start of line): [HERO INFO]:
-- 12 (regex): ^An Immortal herochats '.*'$
-- 13 (regex): ^An Immortal lordchats '.*'$
-- 14 (regex): ^An Immortal chats '.*'$
-- 15 (regex): ^An Immortal nChats '.*'$
-- 16 (start of line): [GROUP INFO]:
-- 17 (start of line): [DEATH INFO]:

-- Script Code:
selectString(line,1)
copy()
appendBuffer("Channels")
deselect()
deleteLine()