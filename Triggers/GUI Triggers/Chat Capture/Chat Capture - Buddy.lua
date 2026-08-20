if GlobalVar.IgnoreCurrentLine then return end

-- normal trigger logic here

selectString(line,1)
copy()
appendBuffer("BuddyChat")


if not GlobalVar.EchoToMainConsole then
  deselect()
  deleteLine()
end
