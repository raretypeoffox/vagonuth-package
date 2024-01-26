-- Trigger: MobFled 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) has fled (\w+)!

-- Script Code:
-- A hideous hunchback has fled down! 
raiseEvent("OnMobFled")