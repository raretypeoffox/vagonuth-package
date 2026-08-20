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

  local words = {}

  for word in input:gmatch("%S+") do
    table.insert(words, word)
  end

  local function parseFrom(firstWord, enhancers)
    if firstWord > #words then
      return enhancers
    end

    if #enhancers >= 3 then return nil end

    for lastWord = #words, firstWord, -1 do
      local candidate = table.concat(words, " ", firstWord, lastWord)
      local enhancer = matchKineticEnhancer(candidate, true)

      if enhancer then
        table.insert(enhancers, enhancer)
        local result = parseFrom(lastWord + 1, enhancers)
        if result then return result end
        table.remove(enhancers)
      end
    end

    return nil
  end

  local enhancers = parseFrom(1, {})
  if enhancers then return enhancers, nil end

  return nil, "Could not match one, two, or three kinetic enhancer spells."
end


if args == "" then
  showCmdSyntax("Kinetic Enhancers\n\tSyntax: kin <spell> [spell] [spell]", {
    {"kin <spell>", "Sets one Psi kinetic enhancer spell to autocast"},
    {"kin <spell> <spell>", "Sets two Psi kinetic enhancer spells to autocast"},
    {"kin <spell> <spell> <spell>", "Sets three spells at Lord 800+"},
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

  if GlobalVar.KineticEnhancerThree then
    printMessage(
      "Kinetic Enhancer Three",
      "Spell currently set to: <yellow>" .. GlobalVar.KineticEnhancerThree
    )
  else
    printMessage("Kinetic Enhancer Three", "No spell currently set")
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
  GlobalVar.KineticEnhancerThree = nil

  printMessage("Kinetic Enhancers", "Spells cleared")
  return
end


local enhancers, parseError = splitKineticEnhancerArgs(args)

if not enhancers then
  printMessage(
    "Kinetic Enhancer error",
    parseError or "Please specify one, two, or three spells"
  )
  return
end

local selected = {}

for _, enhancer in ipairs(enhancers) do
  if not hasKineticEnhancerUnlocked(enhancer) then
    printMessage(
      "Kinetic Enhancer error",
      "You have not unlocked: <yellow>" .. enhancer.spell
    )
    return
  end

  if selected[enhancer.key] then
    printMessage(
      "Kinetic Enhancer error",
      "You selected the same spell more than once: <yellow>" .. enhancer.spell
    )
    return
  end

  selected[enhancer.key] = true
end

local maxEnhancers = getMaxKineticEnhancers()
if #enhancers > maxEnhancers then
  printMessage(
    "Kinetic Enhancer",
    "You can currently use " .. maxEnhancers .. " kinetic enhancer(s). Extra spells ignored."
  )

  while #enhancers > maxEnhancers do
    table.remove(enhancers)
  end
end

GlobalVar.KineticEnhancerOne = enhancers[1] and enhancers[1].spell or nil
GlobalVar.KineticEnhancerTwo = enhancers[2] and enhancers[2].spell or nil
GlobalVar.KineticEnhancerThree = enhancers[3] and enhancers[3].spell or nil


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


if GlobalVar.KineticEnhancerThree then
  printMessage(
    "Kinetic Enhancer Three",
    "Spell set to: <yellow>" .. GlobalVar.KineticEnhancerThree
  )
else
  printMessage("Kinetic Enhancer Three", "Spell cleared")
end
