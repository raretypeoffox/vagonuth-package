-- Trigger: preachup - prs trg 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*(\w+)\* tells the group 'ayas preachup'

-- Script Code:
if getProfileName() ~= "Artemis" and StatTable.current_mana >= 3500 then
  send("wake")
  send("gtell Spells incoming")
  send("preach holy sight")
  send("preach iron skin")
  send("preach holy sight")
  send("preach water breathing")
  send("preach fortitudes")
  send("preach foci")
  send("preach aegis")
  send("preach sanctuary")
  send("sleep")
else
  send("gtell Sorry, but I need more mana before I can preach spells.")
end