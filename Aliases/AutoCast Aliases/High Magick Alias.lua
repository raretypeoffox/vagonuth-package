-- Alias: High Magick Alias
-- Attribute: isActive

-- Pattern: ^(?i)(highmagick|hm)(?: (.*))?$

-- Script Code:
local args = (matches[3] or ""):lower()

if args == "" then
    showCmdSyntax("Highmagick\n\tSyntax: hm <spell>", {
    {"hm <spell>", "Sets the Mage high magick spell to be autocast"},
    {"hm clear", "Clears the high magick spell previously set"},
    })
    if GlobalVar.HighMagickSpell then
      printMessage("High Magick", "Spell currently set to: <yellow>" .. GlobalVar.HighMagickSpell)
    end
elseif StatTable.Class ~= "Mage" then
  printMessage("High Magick", "Only mages can cast High Magick spells", "yellow", "ansi_white")
elseif args == "clear" then
  printMessage("High Magick", "Spell cleared")
  GlobalVar.HighMagickSpell = nil
else
  local setspell = setHighMagick(args)
  if setspell then
    GlobalVar.HighMagickSpell = setspell
    printMessage("High Magick", "High Magick spell set to: <yellow>" .. GlobalVar.HighMagickSpell)
  else
    printMessage("High Magick", "Unknown spell name")
  end
end
