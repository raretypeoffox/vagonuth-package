local GLOW_DETAILS = {
  blue = { description = "adds lifesteal to melee attacks", requirement = "lowmort level 10" },
  red = { description = "damages unfriendly creatures", requirement = "lowmort level 30" },
  green = { description = "increases healing taken", requirement = "hero level 1" },
  black = { description = "increases maximum health", requirement = "lord level 300" },
}

local GLOW_ORDER = { "blue", "red", "green", "black" }

local function GlowIsAvailable(colour)
  local level = tonumber(StatTable.Level) or 0
  local sublevel = tonumber(StatTable.SubLevel) or 0

  if level == 250 then return true end
  if colour == "blue" then
    return (level >= 10 and level < 51) or level == 51 or level == 125
  elseif colour == "red" then
    return (level >= 30 and level < 51) or level == 51 or level == 125
  elseif colour == "green" then
    return level == 51 or level == 125
  elseif colour == "black" then
    return level == 125 and sublevel >= 300
  end

  return false
end

local function ShowGlowHelp()
  local syntax = {}
  for _, colour in ipairs(GLOW_ORDER) do
    if GlowIsAvailable(colour) then
      local detail = GLOW_DETAILS[colour]
      local description = detail.description
      if StatTable.Level == 250 then
        description = description .. " (Legend access depends on lore)"
      end
      table.insert(syntax, { "glow " .. colour, description })
    end
  end

  if #syntax == 0 then
    table.insert(syntax, { "glow <colour>", "no glows are available at your current level" })
  end

  showCmdSyntax("Necromancer Glow\n\tSyntax: glow <colour>", syntax)
  local currentGlow = StatTable.Necromancer and StatTable.Necromancer.Glow or nil
  printMessage("Glow", "Currently active: " .. (currentGlow or "None"))
end

if StatTable.Class ~= "Necromancer" and tonumber(StatTable.Level) ~= 250 then
  printMessage("Glow", "This alias is only available to Necromancers.")
  return
end

local colour = (matches[2] or ""):lower()
colour = colour:gsub("^%s+", ""):gsub("%s+$", "")

if colour == "" then
  ShowGlowHelp()
  return
end

local detail = GLOW_DETAILS[colour]
if not detail then
  printMessage("Glow", "Unknown glow: " .. colour)
  ShowGlowHelp()
  return
end

if not GlowIsAvailable(colour) then
  printMessage("Glow", firstToUpper(colour) .. " glow requires " .. detail.requirement .. ".")
  return
end

local currentGlow = StatTable.Necromancer and StatTable.Necromancer.Glow or nil
if currentGlow and currentGlow:lower() == colour then
  printMessage("Glow", firstToUpper(colour) .. " glow is already active.")
  return
end

local lag = gmcp and gmcp.Char and gmcp.Char.Vitals and tonumber(gmcp.Char.Vitals.lag) or 0
if lag > 0 then
  printMessage("Glow", "Cannot change glow while lagged (" .. lag .. " seconds).")
  return
end

local command = "cast '" .. colour .. " glow'"
if not TryCast(command, 2) then
  printMessage("Glow", "Another spell was sent recently; try again when ready.")
end
