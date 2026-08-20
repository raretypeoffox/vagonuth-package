printGameMessage("Det Alert!", matches[2] .. " vanishes suddenly!", "red", "white")

if IsMDAY() then
  send("gtell " .. matches[2] .. " detted!")
end

--Moments before detonation, your the Ruling Glyph vanishes suddenly!