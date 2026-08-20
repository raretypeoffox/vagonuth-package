local cmd = matches[2] or ""

if cmd == "reset" then
  if type(BuffManager) == "table" and type(BuffManager.ClearBlockedActions) == "function" then
    BuffManager.ClearBlockedActions()
  else
    printGameMessage("BuffManager", "BuffManager is not loaded")
  end
  return
end

if cmd == "blocked" then
  if type(BuffManager) == "table" and type(BuffManager.ShowBlockedActions) == "function" then
    BuffManager.ShowBlockedActions()
  else
    printGameMessage("BuffManager", "BuffManager is not loaded")
  end
  return
end

if cmd == "blocklast" then
  if type(BuffManager) == "table" and type(BuffManager.BlockLastManagedAction) == "function" then
    BuffManager.BlockLastManagedAction("manual")
  else
    printGameMessage("BuffManager", "BuffManager is not loaded")
  end
  return
end

showCmdSyntax("BuffManager\n\tSyntax: buffmanager <command>", {
  {"buffmanager blocklast", "Blocks the most recent BuffManager action for the current character"},
  {"buffmanager blocked", "Shows blocked spells and skills for the current character"},
  {"buffmanager reset", "Clears blocked spells and skills for the current character"},
})
