
if string.find(line,"Your attack flow is enhanced for identical cutting weapons of weight") ~= nil then
  return
end

raiseEvent("OnCombat")

