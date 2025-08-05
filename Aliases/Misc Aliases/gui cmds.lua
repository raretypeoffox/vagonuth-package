-- Alias: gui cmds
-- Attribute: isActive

-- Pattern: ^(?i)gui(?: (.*))?$

-- Script Code:
local args = matches[2] and matches[2]:lower() or nil

if args == "echomain" then
  GlobalVar.EchoToMainConsole = not GlobalVar.EchoToMainConsole
  cecho(("Echo to main console is now %s\n")
    :format(GlobalVar.EchoToMainConsole and "<green>ON<reset>" or "<red>OFF<reset>"))
  SaveProfileVars()
else
  showCmdSyntax("GUI Commands\n\tSyntax: gui <option>", {
    {"gui echomain",  "Toggle echoing to the main console"},
  })
end
