local args = (matches[2] or ""):lower()

local function showAvailableStratums()
  local tblAvailable = {}

  for _, stratum in ipairs(StormlordStratums) do
    if hasStratumUnlocked(stratum) then
      table.insert(tblAvailable, {
        spell = stratum.spell,
        rank = stratum.level == 125 and "Lord" or "Hero",
        sublevel = stratum.sublevel,
        desc = stratum.desc,
      })
    end
  end

  if #tblAvailable == 0 then
    printMessage(
      "Available Stratums",
      "\nNone currently available. Stratum unlocks at Hero 675."
    )
    return
  end

  printMessage("Available Stratums", "\nStratums available to your current level:")

  cecho("\n<yellow>Stormlord Stratums<reset>\n")

  local spellColWidth = 16
  local rankColWidth = 6
  local sublevelColWidth = 8

  cecho(
    string.format(
      "%-" .. spellColWidth .. "s %-" .. rankColWidth .. "s %-" .. sublevelColWidth .. "s %s\n",
      "Stratum",
      "Rank",
      "Sublevel",
      "Effect"
    )
  )

  for _, row in ipairs(tblAvailable) do
    cecho(
      string.format(
        "%-" .. spellColWidth .. "s %-" .. rankColWidth .. "s %-" .. sublevelColWidth .. "s %s\n",
        row.spell,
        row.rank,
        row.sublevel,
        row.desc
      )
    )
  end
end

local function splitStratumArgs(input)
  if not input then return nil, nil end

  input = input
    :gsub("['\"]", "")
    :gsub("^%s+", "")
    :gsub("%s+$", "")

  if input == "" then
    return nil, nil
  end

  local oneStratum = matchStratum(input)

  if oneStratum then
    return oneStratum.spell, nil
  end

  local words = {}

  for word in input:gmatch("%S+") do
    table.insert(words, word)
  end

  for splitPoint = 1, #words - 1 do
    local firstWords = {}
    local secondWords = {}

    for i = 1, splitPoint do
      table.insert(firstWords, words[i])
    end

    for i = splitPoint + 1, #words do
      table.insert(secondWords, words[i])
    end

    local arg1 = table.concat(firstWords, " ")
    local arg2 = table.concat(secondWords, " ")

    local stratumOne = matchStratum(arg1)
    local stratumTwo = matchStratum(arg2)

    if stratumOne and stratumTwo then
      return stratumOne.spell, stratumTwo.spell
    end
  end

  return nil, "Could not match one or two stratums."
end

if args == "" then
  showCmdSyntax("Stratum\n\tSyntax: stratum <stratum> <stratum>", {
    {"stratum <stratum>", "Sets one Stormlord stratum to autocast"},
    {"stratum <stratum> <stratum>", "Sets two Stormlord stratums to autocast after Lord 25"},
    {"stratum show", "Shows stratums available to your level"},
    {"stratum clear", "Clears automatic stratum casting"},
  })

  local stratumOne = getPreferredStratumOne()

  if isStratumAutomationOff() or not stratumOne then
    printMessage("Stratum One", "No stratum currently set")
  else
    printMessage("Stratum One", "Stratum currently set to: <yellow>" .. stratumOne)
  end

  if isStratumAutomationOff() or not stratumOne then
    printMessage("Stratum Two", "No stratum currently set")
  elseif GlobalVar.StratumTwo then
    printMessage("Stratum Two", "Stratum currently set to: <yellow>" .. GlobalVar.StratumTwo)
  else
    printMessage("Stratum Two", "No stratum currently set")
  end

  return
end

if StatTable.Class ~= "Stormlord" then
  printMessage("Stratum", "Only Stormlords can cast stratums")
  return
end

if args == "show" then
  showAvailableStratums()
  return
end

if args == "clear" then
  GlobalVar.StratumOne = "off"
  GlobalVar.StratumTwo = nil

  printMessage("Stratum", "Stratums cleared")
  return
end

local stratumOneSpell, stratumTwoSpellOrError = splitStratumArgs(args)

if not stratumOneSpell then
  printMessage("Stratum error", stratumTwoSpellOrError or "Please specify one or two stratums")
  return
end

local stratumTwoSpell = stratumTwoSpellOrError

local stratumOne = matchStratum(stratumOneSpell)
local stratumTwo = stratumTwoSpell and matchStratum(stratumTwoSpell) or nil

if not stratumOne then
  printMessage("Stratum error", "Invalid stratum: <yellow>" .. stratumOneSpell)
  return
end

if stratumTwoSpell and not stratumTwo then
  printMessage("Stratum error", "Invalid stratum: <yellow>" .. stratumTwoSpell)
  return
end

if not hasStratumUnlocked(stratumOne) then
  printMessage("Stratum error", "You have not unlocked: <yellow>" .. stratumOne.spell)
  return
end

if stratumTwo and not hasStratumUnlocked(stratumTwo) then
  printMessage("Stratum error", "You have not unlocked: <yellow>" .. stratumTwo.spell)
  return
end

if stratumTwo and stratumOne.key == stratumTwo.key then
  printMessage("Stratum error", "You selected the same stratum twice: <yellow>" .. stratumOne.spell)
  return
end

if stratumTwo and not hasStrataControl() then
  printMessage("Stratum", "Only Stormlords with strata control can use two stratums. Second stratum ignored.")
  stratumTwo = nil
end

GlobalVar.StratumOne = stratumOne.spell
GlobalVar.StratumTwo = stratumTwo and stratumTwo.spell or nil

printMessage("Stratum One", "Stratum set to: <yellow>" .. GlobalVar.StratumOne)

if GlobalVar.StratumTwo then
  printMessage("Stratum Two", "Stratum set to: <yellow>" .. GlobalVar.StratumTwo)
else
  printMessage("Stratum Two", "Stratum cleared")
end
