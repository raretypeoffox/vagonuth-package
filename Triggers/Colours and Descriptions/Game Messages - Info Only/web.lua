if not IsGroupMate(matches[2]) then return end

printGameMessage("Web Alert!", matches[2] .. " is webbed!", "red", "white")

if IsMDAY() then
  send("gtell " .. matches[2] .. " webbed!")
end
