-- Alias: Track
-- Attribute: isActive

-- Pattern: ^(?i)track (\w+)$

-- Script Code:
GlobalVar.AutoTrackTarget = matches[2]
send("track " .. matches[2], false)