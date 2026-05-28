-- Alias: Pantheon Alias
-- Attribute: isActive

-- Pattern: ^(?i)(panth|pantheon)(?: (.*))?$

-- Script Code:
local args = (matches[3] or ""):lower()

local function showAvailablePantheonSpells()
  local tblAvailable = {}

  for _, pantheonSpell in ipairs(PantheonSpells) do
    if hasPantheonSpellUnlocked(pantheonSpell) then
      table.insert(tblAvailable, {
        spell = pantheonSpell.spell,
        rank = pantheonSpell.level == 125 and "Lord" or "Hero",
        sublevel = pantheonSpell.sublevel,
      })
    end
  end

  if #tblAvailable == 0 then
    printMessage(
      "Available Pantheon Spells",
      "\nNone currently available. First pantheon spell unlocks at Hero 100: <yellow>glorious conquest"
    )
    return
  end

  printMessage("Available Pantheon Spells", "\nSpells available to your current level:")

  cecho("\n<yellow>Pantheon Spells<reset>\n")

  local spellColWidth = 22
  local rankColWidth = 6

  cecho(
    string.format(
      "%-" .. spellColWidth .. "s %-" .. rankColWidth .. "s %s\n",
      "Spell",
      "Rank",
      "Sublevel"
    )
  )

  for _, row in ipairs(tblAvailable) do
    cecho(
      string.format(
        "%-" .. spellColWidth .. "s %-" .. rankColWidth .. "s %s\n",
        row.spell,
        row.rank,
        row.sublevel
      )
    )
  end
end

if args == "" then
    showCmdSyntax("Pantheon\n\tSyntax: panth <spell>", {
    {"panth <spell>", "Sets the Cleric pantheon spell to be autocast"},
    {"panth show", "Shows pantheon spells available to your level"},
    {"panth clear", "Clears the pantheon spell previously set"},
    })
    if GlobalVar.PantheonSpell then
      printMessage("Pantheon", "Spell currently set to: <yellow>" .. GlobalVar.PantheonSpell)
    end
elseif StatTable.Class ~= "Cleric" then
  printMessage("Pantheon", "Only clerics can cast pantheon spells", "yellow", "ansi_white")
elseif args == "show" then
  showAvailablePantheonSpells()
elseif args == "clear" then
  printMessage("Pantheon", "Spell cleared")
  GlobalVar.PantheonSpell = nil
else
  local pantheonSpell = matchPantheonSpell(args)

  if not pantheonSpell then
    printMessage("Pantheon", "Unknown spell name")
    return
  end

  if not hasPantheonSpellUnlocked(pantheonSpell) then
    printMessage("Pantheon", "You have not unlocked: <yellow>" .. pantheonSpell.spell)
    return
  end

  GlobalVar.PantheonSpell = pantheonSpell.spell
  printMessage("Pantheon", "Pantheon spell set to: <yellow>" .. GlobalVar.PantheonSpell)
end
