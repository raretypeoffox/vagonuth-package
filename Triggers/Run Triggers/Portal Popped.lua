-- A blood stained portal to Darker Castle has congealed here!
send("get portal")

if matches[2] then
  printGameMessage("Portal!", "A portal to " .. matches[2] .. " popped here!")
end