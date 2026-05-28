-- Alias: Kinetic Enhancer Alias
-- Attribute: isActive

-- Pattern: ^(?i)kin(?:\s+(.+))?\s*$

-- Script Code:
local args = (matches[2] or ""):lower()


local function showAvailableKineticEnhancers()
  local tblAvailable = {}

  for _, enhancer in ipairs(KineticEnhancers) do
    if hasKineticEnhancerUnlocked(enhancer) then
      table.insert(tblAvailable, {
        spell = enhancer.spell,
        desc = enhancer.desc,
      })
    end
  end

  if #tblAvailable == 0 then
    printMessage(
      "Available Kinetic Enhancers",
      "\nNone currently available. First spell unlocks at Hero 500: <yellow>stunning weapon"
    )
    return
  end

  printMessage("Available Kinetic Enhancers", "\nSpells available to your current level:")

  cecho("\n<yellow>Kinetic Enhancers<reset>\n")

  local spellColWidth = 24

  for _, row in ipairs(tblAvailable) do
    cecho(
      string.format(
        "%-" .. spellColWidth .. "s %s\n",
        row.spell,
        row.desc
      )
    )
  end
end


local function splitKineticEnhancerArgs(input)
  if not input then return nil, nil end

  input = input
    :gsub("['\"]", "")
    :gsub("^%s+", "")
    :gsub("%s+$", "")

  if input == "" then
    return nil, nil
  end

  -- First, try treating the whole input as one enhancer.
  local oneEnhancer = matchKineticEnhancer(input)

  if oneEnhancer then
    return oneEnhancer.spell, nil
  end

  -- Then try every possible split point.
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

    local enhancerOne = matchKineticEnhancer(arg1)
    local enhancerTwo = matchKineticEnhancer(arg2)

    if enhancerOne and enhancerTwo then
      return enhancerOne.spell, enhancerTwo.spell
    end
  end

  return nil, "Could not match one or two kinetic enhancer spells."
end


if args == "" then
  showCmdSyntax("Kinetic Enhancers\n\tSyntax: kin <spell> <spell>", {
    {"kin <spell>", "Sets one Psi kinetic enhancer spell to autocast"},
    {"kin <spell> <spell>", "Sets two Psi kinetic enhancer spells to autocast"},
    {"kin show", "Shows kinetic enhancer spells available to your level"},
    {"kin clear", "Clears the kinetic enhancer spells previously set"},
  })

  if GlobalVar.KineticEnhancerOne then
    printMessage(
      "Kinetic Enhancer One",
      "Spell currently set to: <yellow>" .. GlobalVar.KineticEnhancerOne
    )
  else
    printMessage("Kinetic Enhancer One", "No spell currently set")
  end

  if GlobalVar.KineticEnhancerTwo then
    printMessage(
      "Kinetic Enhancer Two",
      "Spell currently set to: <yellow>" .. GlobalVar.KineticEnhancerTwo
    )
  else
    printMessage("Kinetic Enhancer Two", "No spell currently set")
  end

  return
end


if StatTable.Class ~= "Psionicist" then
  printMessage("Kinetic Enhancer", "Only Psionicists can cast kinetic enhancers")
  return
end


if args == "show" then
  showAvailableKineticEnhancers()
  return
end


if args == "clear" then
  GlobalVar.KineticEnhancerOne = nil
  GlobalVar.KineticEnhancerTwo = nil

  printMessage("Kinetic Enhancers", "Spells cleared")
  return
end


local enhancerOneSpell, enhancerTwoSpellOrError = splitKineticEnhancerArgs(args)

if not enhancerOneSpell then
  printMessage(
    "Kinetic Enhancer error",
    enhancerTwoSpellOrError or "Please specify one or two spells"
  )
  return
end

local enhancerTwoSpell = enhancerTwoSpellOrError

local enhancerOne = matchKineticEnhancer(enhancerOneSpell)
local enhancerTwo = enhancerTwoSpell and matchKineticEnhancer(enhancerTwoSpell) or nil


if not enhancerOne then
  printMessage("Kinetic Enhancer error", "Invalid spell: <yellow>" .. enhancerOneSpell)
  return
end

if enhancerTwoSpell and not enhancerTwo then
  printMessage("Kinetic Enhancer error", "Invalid spell: <yellow>" .. enhancerTwoSpell)
  return
end


if not hasKineticEnhancerUnlocked(enhancerOne) then
  printMessage(
    "Kinetic Enhancer error",
    "You have not unlocked: <yellow>" .. enhancerOne.spell
  )
  return
end

if enhancerTwo and not hasKineticEnhancerUnlocked(enhancerTwo) then
  printMessage(
    "Kinetic Enhancer error",
    "You have not unlocked: <yellow>" .. enhancerTwo.spell
  )
  return
end


if enhancerTwo and enhancerOne.key == enhancerTwo.key then
  printMessage(
    "Kinetic Enhancer error",
    "You selected the same spell twice: <yellow>" .. enhancerOne.spell
  )
  return
end


if StatTable.Level == 51 and enhancerTwo then
  printMessage(
    "Kinetic Enhancer",
    "Heroes can only use one kinetic enhancer. Second spell ignored."
  )
  enhancerTwo = nil
end


GlobalVar.KineticEnhancerOne = enhancerOne.spell
GlobalVar.KineticEnhancerTwo = enhancerTwo and enhancerTwo.spell or nil


printMessage(
  "Kinetic Enhancer One",
  "Spell set to: <yellow>" .. GlobalVar.KineticEnhancerOne
)

if GlobalVar.KineticEnhancerTwo then
  printMessage(
    "Kinetic Enhancer Two",
    "Spell set to: <yellow>" .. GlobalVar.KineticEnhancerTwo
  )
else
  printMessage("Kinetic Enhancer Two", "Spell cleared")
end
