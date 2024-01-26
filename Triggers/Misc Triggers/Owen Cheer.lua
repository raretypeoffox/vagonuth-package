-- Trigger: Owen Cheer 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You hear a loud cheer emanate from Owen's home.

-- Script Code:
GlobalVar.OwenCheer = GlobalVar.OwenCheer or 0
GlobalVar.OwenCheer = GlobalVar.OwenCheer + 1

cecho (string.rep (" ",55-tonumber(string.len(line))) .."<white>[ " .. GlobalVar.OwenCheer .. " ]")
