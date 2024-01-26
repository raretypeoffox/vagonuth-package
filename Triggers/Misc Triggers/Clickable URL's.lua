-- Trigger: Clickable URL's 
-- Attribute: isActive
-- Attribute: isPerlSlashGOption


-- Trigger Patterns:
-- 0 (regex): \b(?:(?:(?:https?|ftp|telnet)://[\w\d:#@%/;$()~_?\+\-=&]+|www|ftp)(?:\.[\w\d:#@%/;$()~_?\+\-=&]+)+|[\w\d._%+\-]+@[\w\d.\-]+\.[\w]{2,4})\b

-- Script Code:
for i,v in ipairs(matches) do
  selectString(matches[i], 1)
  setLink([[openUrl("]]..matches[i]..[[")]], matches[i])
end