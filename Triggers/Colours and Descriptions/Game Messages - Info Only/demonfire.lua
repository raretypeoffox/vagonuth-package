local msg_txt = "has"
if matches[2] == "You" then msg_txt = "have" end

printGameMessage("Demonfire", matches[2] .. " " .. msg_txt .. " demonfire!", "red", "white")