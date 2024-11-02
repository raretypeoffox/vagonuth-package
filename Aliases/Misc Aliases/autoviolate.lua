-- Alias: autoviolate
-- Attribute: isActive

-- Pattern: ^(?i)(autoviolate)(?: (.*))?$

-- Script Code:

args = matches[3] or ""
args = string.lower(args)

if (args == "") then
  print("AutoViolate - automatically violates a stack of items")
  print("Synax: autoviolate <item>")
  print("--------------------------------------------------")
  local cmd_name = "AutoViolate\n\tSyntax: autoviolate <item>"
  local syntax_tbl = {
    {"autoviolate <item>", "automatically violates a stack of items"},
    {"autoviolate stop", "stops autoviolation"},
    {"",""},
    {"to auto bag these items","set up your loot bags name in StaticVars.LootBagName"},
  }
  showCmdSyntax(cmd_name, syntax_tbl)
elseif args == "stop" then
  GlobalVar.AutoViolate = false
else
  GlobalVar.AutoViolate = true
  GlobalVar.AutoViolateItem = args
  send("cast violation " .. GlobalVar.AutoViolateItem)
end