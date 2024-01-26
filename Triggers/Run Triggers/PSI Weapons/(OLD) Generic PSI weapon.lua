-- Trigger: (OLD) Generic PSI weapon 


-- Trigger Patterns:
-- 0 (regex): ^(.*) clatters to the ground!$
-- 1 (regex): ^You get (.*) from corpse of
-- 2 (regex): ^(.*) falls to the ground, lifeless.
-- 3 (regex): ^You get (.*) from corpse

-- Script Code:
if matches[2] == "CLICK CLICK" then
  send("get all.calpchak")
  send("give all.calpchak claap")
elseif matches[2] == "a holy noodle of R'amen" then
  send("get all.noodle")
  send("give noodle rawil")
elseif matches[2] == "a spear shaped bucatini" then
  send("get all.bucatini")
  send("give bucatini rawil")
elseif matches[2] == "TICKLE FIGHT" or matches[2] == "I AM BEYONCE, ALWAYS" then
  send("get all.hitt")
  send("give all.hitt ramahdon")
elseif matches[2] == "Notes from Underground" then
  send("get bitterness")
  send("get despair")
  send("give bitter xues")
  send("give desp xues")
elseif matches[2] == "Sith Inquisitor" then
  send("get sith")
  send("give sith Flood")
elseif matches[2] == "Green Destiny" then
  send("get destiny")
  send("give destiny fango")
elseif matches[2] == "The Dragonknife" then
  send("get dragonknife")
  send("give dragonknife kesri")
  send("get wildwood")
  send("give wildwood kesri")
elseif matches[2] == "Trained Attack Sprite" then
  send("get sprite")
  send("give sprite chronos")
  --send("give sprite allisandra")
elseif matches[2] == "Sludge's fiery wield" or matches[2] == "Sludge's fiery offhand" then
  TryAction("get all.sludge",2)
  TryAction("give all.sludge sludge",2)
elseif matches[2] == "a saber of pure light" then
  TryAction("get all.ky",2)
  TryAction("give kylight kylise;give kydark kylise",2)
elseif matches[2] == "A winged angel" then
  TryAction("get all.wing",2)
  TryAction("give all.wing photon", 2)
elseif matches[2] == "Xanur's Murasame" and StatTable.CharName ~= "Xanur" then
  TryAction("get all.xanur",2)
  TryAction("give all.xanur",2)
elseif matches[2] == "Glitch" then
  TryAction("get all glitch",2)
  TryAction("give all.glitch glitch", 2)
elseif matches[2] == "Kiss of the Dragkhar" then
  TryAction("get 15662861781" .. getCommandSeparator() .. "get 15684033119",2)
  TryAction("give 15662861781 aginor" .. getCommandSeparator() .. "give 15684033119 aginor",2)

end

