-- Alias: Pantheon Alias
-- Attribute: isActive

-- Pattern: ^(?i)(panth|pantheon)(?: (.*))?$

-- Script Code:
local args = (matches[3] or ""):lower()

if args == "" then
    showCmdSyntax("Pantheon\n\tSyntax: panth <spell>", {
    {"panth <spell>", "Sets the Cleric pantheon spell to be autocast"},
    {"panth clear", "Clears the pantheon spell previously set"},
    })
    if GlobalVar.PantheonSpell then
      printMessage("Pantheon", "Spell currently set to: <yellow>" .. GlobalVar.PantheonSpell)
    end
elseif StatTable.Class ~= "Cleric" then
  printMessage("Pantheon", "Only clerics can cast pantheon spells", "yellow", "ansi_white")
elseif arg == "clear" then
  printMessage("Pantheon", "Spell cleared")
  GlobalVar.PantheonSpell = nil
else
  GlobalVar.PantheonSpell = args
  printMessage("Pantheon", "Pantheon spell set to: <yellow>" .. GlobalVar.PantheonSpell)
end
