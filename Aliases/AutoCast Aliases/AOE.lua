local args = matches[2] and string.lower(matches[2]) or ""

if GlobalVar.AutoAOE == nil then GlobalVar.AutoAOE = true end

if args == "" then
  showCmdSyntax("AOE\n\tSyntax: aoe (on|off)", {
    {"aoe on", "allow automated area-of-effect spells"},
    {"aoe off", "prevent automated area-of-effect spells for this session"},
  })
  print("")
  printGameMessage("AOE", "Automated AOE is " .. (GlobalVar.AutoAOE and "ON" or "OFF"))
  return
end

GlobalVar.AutoAOE = args == "on"

if type(AutoCastSpellSwap) == "function" then
  AutoCastSpellSwap()
end

printGameMessage("AOE", "Automated AOE turned " .. (GlobalVar.AutoAOE and "ON" or "OFF"))
