-- Trigger: Portal Popped 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^A blood stained portal to (.*) has congealed here!
-- 1 (substring): A portal congealed from blood.

-- Script Code:
-- A blood stained portal to Darker Castle has congealed here!
send("get portal")

if matches[2] then
  printGameMessage("Portal!", "A portal to " .. matches[2] .. " popped here!")
end