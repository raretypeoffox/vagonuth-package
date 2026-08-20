selectString(line, 1)
copy()

appendBuffer("GroupChat")

appendBuffer("console")


if not GlobalVar.EchoToMainConsole then
  deselect()
  deleteLine()
end
