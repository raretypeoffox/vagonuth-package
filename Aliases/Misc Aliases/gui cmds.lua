local args = matches[2] and matches[2]:lower() or nil

if args == "echomain" then
  GlobalVar.EchoToMainConsole = not GlobalVar.EchoToMainConsole
  cecho(("Echo to main console is now %s\n")
    :format(GlobalVar.EchoToMainConsole and "<green>ON<reset>" or "<red>OFF<reset>"))
  SaveProfileVars()
elseif args == "right" or args == "rightcontainer" or args == "right off" or args == "rightcontainer off" or args == "right on" or args == "rightcontainer on" then
  if args:match(" off$") then
    GlobalVar.RightContainer = true
  elseif args:match(" on$") then
    GlobalVar.RightContainer = false
  end
  RightContainerToggle()
  cecho(("Right container is now %s\n")
    :format(GlobalVar.RightContainer and "<green>ON<reset>" or "<red>OFF<reset>"))
elseif args == "compact" or args == "compact off" or args == "compact on" then
  if args == "compact on" then
    GlobalVar.GUICompact = true
  elseif args == "compact off" then
    GlobalVar.GUICompact = false
  else
    GlobalVar.GUICompact = not GlobalVar.GUICompact
  end

  SaveProfileVars()
  if GlobalVar.GUI then LoadLayout() end

  cecho(("Compact GUI is now %s\n")
    :format(GlobalVar.GUICompact and "<green>ON<reset>" or "<red>OFF<reset>"))
else
  showCmdSyntax("GUI Commands\n\tSyntax: gui <option>", {
    {"gui echomain",  "Toggle echoing to the main console"},
    {"gui right [on|off]", "Toggle or set the right-side chat container"},
    {"gui compact [on|off]", "Toggle or set compact GUI spacing"},
  })
end
