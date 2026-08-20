--Dojo picks the gate above you.
--You unlock the door to the south.

local dir = matches[3]

if dir == "above" then dir = "up"
elseif dir == "below" then dir = "down" end

send("open " .. dir)