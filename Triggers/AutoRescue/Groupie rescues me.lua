-- Trigger: Groupie rescues me 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) successfully rescues you from

-- Script Code:
AR.GroupieRescuesMe(string.lower(matches[2]))

