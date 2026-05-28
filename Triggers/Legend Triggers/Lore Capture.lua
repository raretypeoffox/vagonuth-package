-- Trigger: Lore Capture 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have (\d+) lore points\.$

-- Script Code:
Legend = Legend or {}

local function normalizeLoreName(name)
  if not name then return nil end
  name = name:lower()
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  name = name:gsub("%s+", " ")
  if name == "" then return nil end
  return name
end

function Legend.HasLore(name)
  local lore = normalizeLoreName(name)
  return lore ~= nil and Legend.Lore ~= nil and Legend.Lore.KnownLookup ~= nil and Legend.Lore.KnownLookup[lore] == true
end

local function finishLoreCapture()
  if not Legend.Lore or not Legend.Lore.IsCapturing then return end

  Legend.Lore.IsCapturing = false
  Legend.Lore.LastUpdated = os.time()
  StatTable.LegendLore = Legend.Lore

  safeKillTrigger("LegendLoreCapture.Line")
  safeKillTimer("LegendLoreCapture.Timeout")

  raiseEvent("OnLegendLore")
end

local function addKnownLore(name)
  local lore = normalizeLoreName(name)
  if not lore then return end

  table.insert(Legend.Lore.Known, lore)
  Legend.Lore.KnownLookup[lore] = true
end

local function addLearnableLore(line)
  local lore, cost = line:match("^(.-)%s+(%d+)pts$")
  lore = normalizeLoreName(lore or line)
  if not lore or lore == "none" then return end

  local entry = {
    Name = lore,
    Cost = tonumber(cost)
  }

  table.insert(Legend.Lore.Learnable, entry)
  Legend.Lore.LearnableLookup[lore] = entry
end

Legend.Lore = {
  Points = tonumber(matches[2]) or 0,
  Known = {},
  KnownLookup = {},
  Learnable = {},
  LearnableLookup = {},
  IsCapturing = true
}

StatTable.LegendLore = Legend.Lore

local section = nil

safeTempTrigger("LegendLoreCapture.Line", "^(.*)$", function()
  local line = matches[2] or ""
  local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")

  if trimmed == "" then
    finishLoreCapture()
    return
  end

  if trimmed == "You have gained the following Lores:" then
    section = "known"
    return
  end

  if trimmed == "You may learn the following Lores:" then
    section = "learnable"
    return
  end

  if section == "known" then
    addKnownLore(trimmed)
  elseif section == "learnable" then
    addLearnableLore(trimmed)
  end
end, "regex")

safeTempTimer("LegendLoreCapture.Timeout", 10, finishLoreCapture)
