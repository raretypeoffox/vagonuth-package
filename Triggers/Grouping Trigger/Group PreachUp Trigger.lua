-- Trigger: Group PreachUp Trigger 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): * tells the group 'preachup'
-- 1 (substring): * tells the group 'preach'
-- 2 (start of line): You tell the group 'preach'
-- 3 (start of line): You tell the group 'preachup'

-- Script Code:
OnMobDeathQueueClear()
PreachUp()


 