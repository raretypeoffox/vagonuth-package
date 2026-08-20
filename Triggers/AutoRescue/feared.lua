local rescue_target_feared = matches[2]
if not GlobalVar.Silent then TryAction("gtell |BW|Feared!|N| couldn't rescue " .. rescue_target_feared .. "!", 30) end
printGameMessage("Feared!", "Couldn't rescue " .. rescue_target_feared .. "!", "red", "white")