-- Trigger: mega-shark 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): All this blood has attracting a beast from the deepest seas, its visage refracting within the Ulexite Forest!

-- Script Code:
if not GlobalVar.Silent then
  send("gtell " .. texttocolour("R", "MEGA-SHARK") .. " |BW|popped!")
end