local args = (matches[2] or ""):lower()

if args == "on" then
  if StatTable.Race == "High Elf" then
    printMessage("AutoFrenzy", "High Elves cannot receive Frenzy. Eligible Paladins maintain Fervor automatically.")
    return
  end

  GlobalVar.AutoFrenzy = true
elseif args == "off" then
  GlobalVar.AutoFrenzy = false

  if type(BuffManager) == "table" and type(BuffManager.RemoveAction) == "function" then
    BuffManager.RemoveAction("cast frenzy")
  end
else
  showCmdSyntax("AutoFrenzy\n\tSyntax: autofrenzy (on|off)", {{"autofrenzy (on|off)", "automatically acquires and maintains Frenzy where available"},})
  return
end

-- Apply an explicit mid-run enable immediately. GameLoopAutoFrenzy retains
-- the normal eligibility checks and queues the cast until combat and lag end.
if GlobalVar.AutoFrenzy and type(GameLoopAutoFrenzy) == 'function' then
  GameLoopAutoFrenzy(StatTable.Class, StatTable.Race)
end

printMessage("AutoFrenzy", "Set to " .. (GlobalVar.AutoFrenzy and "ON" or "OFF"))


