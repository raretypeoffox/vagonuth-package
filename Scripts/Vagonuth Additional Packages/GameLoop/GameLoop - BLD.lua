-- Script: GameLoop - BLD
-- Attribute: isActive

-- Script Code:
--------------------------------------------------------------------------------
-- Dance Pattern Definitions (MODIFIABLE BY USER)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
-- Applies a dance pattern template defined by a configuration table.
-- The configuration table can include a PrimaryDance, SecondaryDance (optional),
-- TertiaryDance (optional), and a RestartDance fallback.
--
-- The template should be a table with the following structure:
--
-- {
--   PrimaryDance = {
--     NextDance = "Inspire",         -- key for DanceName lookup
--     BladetranceBinary = false,     -- true to enter/deepen, false to break
--     DanceList = {"Veil", "Unend"}, -- Dances to swap from into our NextDance
--     StanceTimer = {1, 3},          -- table for DanceList above, can also be a single value for all
--   },
--   SecondaryDance = {                -- optional
--     NextDance = "Veil",             
--     BladetranceBinary = true,       
--     DanceList = {"Inspire", "Bladedance", "Dervish"},
--     StanceTimer = 1,                
--   },
--   TertiaryDance = {                 -- optional
--     NextDance = ""
--     BladetranceBinary = true/false
--     DanceList = {""},
--     StanceTimer = 1,
--   },
--   -- If we're not dancing (eg we wake up from regen), which dance should we pop into?
--   RestartDance = {"Inspire", "Veil", "Unend", "Bladedance", "Dervish"}
-- }
--

local dancePatterns = {
  default = {
    PrimaryDance = {
      NextDance = "Inspire",
      BladetranceBinary = false,
      DanceList = {"Veil", "Unend"},
      StanceTimer = {1, 3},
    },
    SecondaryDance = {
      NextDance = "Veil",
      BladetranceBinary = true,
      DanceList = {"Inspire", "Bladedance", "Dervish"},
      StanceTimer = 1,
    },
    RestartDance = {"Inspire", "Veil", "Unend", "Bladedance", "Dervish"},
  },
  melee = {
    PrimaryDance = {
      NextDance = "Bladedance",
      BladetranceBinary = false,
      DanceList = {"Dervish", "Inspire", "Veil", "Unend"},
      StanceTimer = {4, 4, 4, 5},
    },
    SecondaryDance = {
      NextDance = "Dervish",
      BladetranceBinary = false,
      DanceList = {"Bladedance"},
      StanceTimer = 4,
    },
    RestartDance = {"Bladedance", "Dervish", "Veil", "Unend", "Inspire"},
  },
  tank = {
    PrimaryDance = {
      NextDance = "Veil",
      BladetranceBinary = true,
      DanceList = {"Dervish", "Inspire", "Bladedance", "Unend"},
      StanceTimer = {1, 1, 1, 3},
    },
    SecondaryDance = {
      NextDance = "Unend",
      BladetranceBinary = false,
      DanceList = {"Veil"},
      StanceTimer = 1,
    },
    RestartDance = {"Veil", "Unend", "Inspire", "Bladedance", "Dervish"},
  },
  inspire = {
      PrimaryDance = {
      NextDance = "Inspire",
      BladetranceBinary = false,
      DanceList = {"Veil", "Bladedance", "Dervish", "Unend"},
      StanceTimer = {4, 4, 4, 5},
    },
    SecondaryDance = {
      NextDance = "Veil",
      BladetranceBinary = true,
      DanceList = {"Inspire"},
      StanceTimer = 1,
    },
    RestartDance = {"Inspire", "Veil", "Unend", "Bladedance", "Dervish"},
  },
  fast_inspire = {
    PrimaryDance = {
      NextDance = "Inspire",
      BladetranceBinary = false,
      DanceList = {"Veil", "Unend"},
      StanceTimer = {7, 5},
    },
    SecondaryDance = {
      NextDance = "Veil",
      BladetranceBinary = true,
      DanceList = {"Bladedance", "Dervish"},
      StanceTimer = 7,
    },
    TertiaryDance = {
      NextDance = "Dervish",
      BladetranceBinary = false,
      DanceList = {"Inspire"},
      StanceTimer = 7,
    },
    RestartDance = {"Inspire", "Veil", "Dervish", "Bladedance", "Unend"},
  },
  prac = {
    PrimaryDance = {
      NextDance = "Unend",
      BladetranceBinary = false,
      DanceList = {"Bladedance", "Veil"},
      StanceTimer = {7, 5},
    },
    SecondaryDance = {
      NextDance = "Bladedance",
      BladetranceBinary = false,
      DanceList = {"Inspire", "Dervish"},
      StanceTimer = 7,
    },
    TertiaryDance = {
      NextDance = "Dervish",
      BladetranceBinary = false,
      DanceList = {"Unend"},
      StanceTimer = 7,
    },
    RestartDance = {"Inspire", "Veil", "Dervish", "Bladedance", "Unend"},
  },
  hero = {
    -- For hero, we only need one stage:
    PrimaryDance = {
      NextDance = "Bladedance",         -- Start with Bladedance...
      BladetranceBinary = false,          -- ...and then if unavailable, try Dervish.
      DanceList = {"Bladedance", "Dervish"},
      StanceTimer = 2,                    -- Same threshold for both.
    },
    RestartDance = {"Bladedance", "Dervish"},
  },
}

--------------------------------------------------------------------------------
-- Helper Functions (DO NOT CHANGE)
--------------------------------------------------------------------------------

-- Mapping keys to their corresponding dance names. Do not change
local DanceName = {
  Inspire = "inspiring dance",
  Veil    = "veil of blades",
  Unend   = "unending dance",
  Dervish = "dervish dance",
  Bladedance = "bladedance",
}

local function autoStancePrerequisites()
  if not GlobalVar.AutoStance then return false end
  if not gmcp.Char.Status.opponent_health and tonumber(gmcp.Char.Status.opponent_health) < 30 then return false end
  if tonumber(gmcp.Char.Vitals.lag) > 0 then return false end
  return true
end

-- Break out of bladetrance if mana is low.
local function breakTranceIfNeeded()
  if StatTable.BladetranceLevel > 0 and StatTable.current_mana < 2000 then
    TryAction("bladetrance break", 10)
    return true
  end
  return false
end

-- Enter bladetrance (and deepen it if possible) when mana is sufficient.
local function enterTranceIfManaOk()
  local manapct = StatTable.current_mana / StatTable.max_mana
  if manapct > 0.5 then
    TryAction("bladetrance enter", 10)
    if StatTable.current_mana > 10000 then
      TryAction("bladetrance deepen;bladetrance deepen", 10)
    elseif StatTable.current_mana > 5000 then
      TryAction("bladetrance deepen", 10)
    end
  end
end

-- General function to try a stance by name.
local function tryStance(stanceName)
  TryAction("stance " .. stanceName, 10)
end

-- Checks if any of the specified timers equal stanceTimer.
-- If one does, it emits an emote using the uppercase dance name.
-- Returns true if an emote was triggered, false otherwise.
local function checkTimersForEmote(stanceTimer, timerKeys)
  for _, key in ipairs(timerKeys) do
    local timerField = key .. "Timer"  -- e.g. "Inspire" becomes "InspireTimer"
    if StatTable[timerField] and StatTable[timerField] == stanceTimer then
      local danceNameUpper = string.upper(DanceName[key])
      TryAction("emote |N| |BW|" .. danceNameUpper .. " @ |BY|" .. stanceTimer, 60)
      return true
    end
  end
  return false
end

-- Handle a manually set next stance. Returns true if handled.
local function handleNextStance()
  local stanceTimer = GlobalVar.NextStanceTimer or 1
  if GlobalVar.NextStance and (
       (StatTable.InspireTimer and StatTable.InspireTimer <= stanceTimer) or
       (StatTable.BladedanceTimer and StatTable.BladedanceTimer <= stanceTimer) or
       (StatTable.DervishTimer and StatTable.DervishTimer <= stanceTimer) or
       (StatTable.VeilTimer and StatTable.VeilTimer <= stanceTimer) or
       (StatTable.UnendTimer and StatTable.UnendTimer <= stanceTimer)
     ) then
    TryAction("stance " .. GlobalVar.NextStance, 10)
    GlobalVar.NextStance = nil
    GlobalVar.NextStanceTimer = nil
    return true
  end
  return false
end

-- Function that attempts to start dancing using an ordered list of dance keys.
local function StartDancingAgain(priorityList)
  for _, key in ipairs(priorityList) do
    if not StatTable[key .. "Exhaust"] then
      tryStance(DanceName[key])
      return true  -- Dance started, exit the function.
    end
  end
  return false  -- No dance was available.
end

--------------------------------------------------------------------------------
-- SwitchToDanceIf
--
-- Checks a set of dance timers against threshold values, and if any of the
-- specified timers are below their thresholds, switches the stance to a
-- designated dance. Optionally, it can also manage bladetrance (enter or break)
-- based on the provided flag.
--
-- This function supports two modes for threshold specification:
-- 1. Single Number Mode: If a single number is provided for thresholds, that
--    number is applied as the threshold for all dances in the DanceList.
-- 2. Table Mode: If a table of numbers is provided, each dance in DanceList uses
--    the corresponding threshold value from the table.
--
-- Parameters:
--   NextDance (string)
--     The key for the dance to switch to if the condition is met.
--     This key is used to look up the full stance name in the DanceName table.
--
--   BladetranceBinary (boolean)
--     If true, the function will attempt to enter bladetrance (and deepen it)
--     when switching stances; if false, and bladetrance is active, it will
--     instead break it.
--
--   DanceList (table)
--     A table (array) of dance keys (strings) whose corresponding timers
--     should be checked. For each key, the function constructs the timer field
--     name by appending "Timer" (e.g., "Inspire" becomes "InspireTimer").
--
--   StanceTimerOrList (number or table)
--     Either a single number to be used as the threshold for all timers in
--     DanceList, or a table of numbers providing a distinct threshold for each
--     dance key in DanceList.
--
-- Returns:
--   boolean
--     Returns true if at least one timer in DanceList is below its threshold,
--     and the stance was switched accordingly. Returns false otherwise.
--
-- Usage Examples:
--
--   -- Use the same threshold for all dances:
--   SwitchToDanceIf("Veil", true, {"Inspire", "Bladedance", "Dervish"}, stanceTimer)
--
--   -- Use different thresholds for each dance:
--   SwitchToDanceIf("Inspire", false, {"Veil", "Unend"}, {stanceTimer, stanceTimer + 2})
--------------------------------------------------------------------------------
local function SwitchToDanceIf(NextDance, BladetranceBinary, DanceList, StanceTimerOrList)
  local StanceTimerList = {}
  if type(StanceTimerOrList) == "table" then
    StanceTimerList = StanceTimerOrList
  else
    for i = 1, #DanceList do
      StanceTimerList[i] = StanceTimerOrList
    end
  end

  local conditionMet = false
  for i, key in ipairs(DanceList) do
    local threshold = StanceTimerList[i]
    local timerField = key .. "Timer"  -- e.g., "Inspire" becomes "InspireTimer"
    if StatTable[timerField] and StatTable[timerField] <= threshold then
      conditionMet = true
      break
    end
  end

  if conditionMet then
    tryStance(DanceName[NextDance])
    if BladetranceBinary then
      enterTranceIfManaOk()
    elseif StatTable.Bladetrance then
      TryAction("bladetrance break", 10)
    end
    return true
  end

  return false
end

--------------------------------------------------------------------------------
-- Dance Pattern Validation
--------------------------------------------------------------------------------
local function validateDancePattern(pattern)
  local valid = true
  local errors = {}

  -- Define valid dance names using the keys in our DanceName table.
  local validNames = {
    Inspire    = true,
    Veil       = true,
    Unend      = true,
    Dervish    = true,
    Bladedance = true,
  }

  -- Helper: validate a single stage (Primary, Secondary, or Tertiary).
  local function checkStage(stage, stageName)
    if not stage then 
      return
    end

    -- 1. Check that NextDance is a valid name.
    if type(stage.NextDance) ~= "string" or not validNames[stage.NextDance] then
      valid = false
      table.insert(errors, stageName .. ": NextDance must be one of the valid names.")
    end

    -- 2. Check that BladetranceBinary is a boolean.
    if type(stage.BladetranceBinary) ~= "boolean" then
      valid = false
      table.insert(errors, stageName .. ": BladetranceBinary must be a boolean.")
    end

    -- 3. Check that DanceList is a table and that each element is valid.
    if type(stage.DanceList) ~= "table" then
      valid = false
      table.insert(errors, stageName .. ": DanceList must be a table.")
    else
      for i, name in ipairs(stage.DanceList) do
        if type(name) ~= "string" or not validNames[name] then
          valid = false
          table.insert(errors, stageName .. ": DanceList element at index " .. i .. " is invalid.")
        end
      end
    end

    -- 4. Check that StanceTimer is valid:
    if type(stage.StanceTimer) == "number" then
      if stage.StanceTimer < 0 or stage.StanceTimer > 20 then
        valid = false
        table.insert(errors, stageName .. ": StanceTimer must be between 0 and 20.")
      end
    elseif type(stage.StanceTimer) == "table" then
      if not stage.DanceList or #stage.StanceTimer ~= #stage.DanceList then
        valid = false
        table.insert(errors, stageName .. ": When StanceTimer is a table, its length must match the length of DanceList.")
      else
        for i, timer in ipairs(stage.StanceTimer) do
          if type(timer) ~= "number" or timer < 0 or timer > 20 then
            valid = false
            table.insert(errors, stageName .. ": StanceTimer element at index " .. i .. " must be a number between 0 and 20.")
          end
        end
      end
    else
      valid = false
      table.insert(errors, stageName .. ": StanceTimer must be a number or a table of numbers.")
    end
  end

  -- Validate each stage.
  checkStage(pattern.PrimaryDance, "PrimaryDance")
  checkStage(pattern.SecondaryDance, "SecondaryDance")
  checkStage(pattern.TertiaryDance, "TertiaryDance")

  -- 5. Check that across Primary, Secondary, and Tertiary, every valid dance is represented at least once.
  local combinedSet = {}
  for _, stage in ipairs({pattern.PrimaryDance, pattern.SecondaryDance, pattern.TertiaryDance}) do
    if stage and stage.DanceList then
      for _, name in ipairs(stage.DanceList) do
        combinedSet[name] = true
      end
    end
  end

  for danceName, _ in pairs(validNames) do
    if not combinedSet[danceName] then
      valid = false
      table.insert(errors, "The dance '" .. danceName .. "' is not represented in any DanceList. Add it to your dance list.")
    end
  end

  -- 6. Check that RestartDance is a table and contains all five valid dances.
  if type(pattern.RestartDance) ~= "table" then
    valid = false
    table.insert(errors, "RestartDance must be a table.")
  else
    local restartSet = {}
    for _, name in ipairs(pattern.RestartDance) do
      restartSet[name] = true
    end
    for danceName, _ in pairs(validNames) do
      if not restartSet[danceName] then
        valid = false
        table.insert(errors, "RestartDance does not contain '" .. danceName .. "'.")
      end
    end
  end

  return valid, errors
end

--------------------------------------------------------------------------------
-- Alias Functions
--------------------------------------------------------------------------------

-- Helper function to build a comma-separated list of available dance patterns (excluding "hero").
function getAvailablePatternsString()
  local available = {}
  for key, _ in pairs(dancePatterns) do
    if key ~= "hero" then  -- Exclude hero from the printed list.
      table.insert(available, key)
    end
  end
  table.sort(available)
  return table.concat(available, ", ")
end

-- Global function to set the dance pattern. Used by the alias
function setDancePattern(userInput)
  local userPattern = userInput or ""

  
  -- If no pattern provided or the captured argument is "dancepattern", show syntax and list available patterns.
  if userPattern == "" then
    showCmdSyntax("DancePattern\n\tSyntax: dancepattern <pattern>",
      {{"dancepattern <pattern>", "Sets the dance pattern. Valid patterns: " .. getAvailablePatternsString()}})
    
    cecho("Available dance patterns: <yellow>" .. getAvailablePatternsString() .. "\n")
    cecho("Current dance pattern: <yellow>" .. (GlobalVar.DancePattern and GlobalVar.DancePattern or "default") .. "\n")
    return
  end

  local patternInput = string.lower(userPattern)

  -- Validate that the pattern exists.
  if not dancePatterns[patternInput] then
    cecho("DancePattern Error: Dance pattern '" .. patternInput .. "' does not exist.\n")
    cecho("<yellow>Available dance patterns: " .. getAvailablePatternsString() .. "\n")
    return
  end

  local chosenPattern = dancePatterns[patternInput]

  -- Validate the chosen dance pattern.
  local valid, errList = validateDancePattern(chosenPattern)
  if not valid then
    cecho("DancePattern Error: Dance pattern '" .. patternInput .. "' failed validation:\n")
    for _, err in ipairs(errList) do
      cecho("<yellow>" .. err .. "\n")
    end
    return
  end

  -- Update GlobalVar.
  GlobalVar.DancePattern = patternInput
  cecho("<white>Dance pattern set to " .. GlobalVar.DancePattern .. "\n")
end


--------------------------------------------------------------------------------
-- Run the Dance Pattern
--------------------------------------------------------------------------------
-- The function checks each stage in order:
-- 1. PrimaryDance: if conditions met via SwitchToDanceIf, exit.
-- 2. SecondaryDance: if provided and conditions met, exit.
-- 3. TertiaryDance: if provided and conditions met, exit.
-- 4. Emote if any timer equals the stanceTimer (unless GlobalVar.Silent is true).
-- 5. Otherwise, attempt to restart dancing using RestartDance.
--------------------------------------------------------------------------------
local function runDanceTemplate(pattern)
  local stanceTimer = 1  -- default threshold; can be overridden in the config if needed

  if SwitchToDanceIf(pattern.PrimaryDance.NextDance,
                       pattern.PrimaryDance.BladetranceBinary,
                       pattern.PrimaryDance.DanceList,
                       pattern.PrimaryDance.StanceTimer) then
    return
  elseif pattern.SecondaryDance and SwitchToDanceIf(pattern.SecondaryDance.NextDance,
                                                     pattern.SecondaryDance.BladetranceBinary,
                                                     pattern.SecondaryDance.DanceList,
                                                     pattern.SecondaryDance.StanceTimer) then
    return
  elseif pattern.TertiaryDance and SwitchToDanceIf(pattern.TertiaryDance.NextDance,
                                                    pattern.TertiaryDance.BladetranceBinary,
                                                    pattern.TertiaryDance.DanceList,
                                                    pattern.TertiaryDance.StanceTimer) then
    return
  elseif not GlobalVar.Silent and checkTimersForEmote(stanceTimer, {"Inspire", "Bladedance", "Dervish", "Veil", "Unend"}) then
    return
  elseif not BldDancing() then
    StartDancingAgain(pattern.RestartDance)
  end
end



---------------------------------------
-- Main Game Loop Logic for Bladedancer
---------------------------------------
function GameLoopBLD()
  if not autoStancePrerequisites() then return end
  
  -- if we've manually set the next stance, handle it here
  if GlobalVar.NextStance then
    handleNextStance()
    return
  end  
  
  -- For level 125, do specific preliminary actions.
  if StatTable.Level == 125 then
    -- Optionally, check for grouping:
    -- if not Grouped() then return end

    if breakTranceIfNeeded() then return end
    
  end
  
  
      -- Determine which dance pattern configuration to use.
  local chosenPatternName
  if StatTable.Level == 125 then
    chosenPatternName = GlobalVar.DancePattern or "default"
  elseif StatTable.Level == 51 and StatTable.SubLevel > 101 then
    chosenPatternName = GlobalVar.DancePattern or "hero"
  end
  
  local chosenPattern = dancePatterns[chosenPatternName] or
                         ((StatTable.Level == 125) and dancePatterns.default or dancePatterns.hero)
  
  -- Now, run the chosen dance pattern.
  runDanceTemplate(chosenPattern)

end
