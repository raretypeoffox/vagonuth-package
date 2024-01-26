-- Trigger: Forage 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You forage (.*).

-- Script Code:
if (tonumber(StatTable.forage_kits) >= tonumber(StatTable.number_kits)) then
  if (gmcp.Char.Status.room_name == "West Side of Tree of Knowledge") then
    cecho("Step 5 Fired.")
    send("sanctum")
    send("d")
    send("w")
    send("give all.fletch " .. StatTable.kit_requestor)
    StatTable.forage_kits = 0
    disableTrigger("Found Kit")
    disableTrigger("Forage")
  elseif (gmcp.Char.Status.room_name == "A Nook in the Forest") then
    cecho("Step 6 Fired.")
    send("w")
    send("n")
    send("n")
    send("n")
    send("n")
    send("n")
    send("n")
    send("n")
    send("n")
    send("n")
    send("e")
    send("e")
    send("give all.fletch " .. StatTable.kit_requestor)
    StatTable.forage_kits = 0
    disableTrigger("Found Kit")
    disableTrigger("Forage")
  end
else
  cecho("Step 7 Fired.")
  send("forage")
end