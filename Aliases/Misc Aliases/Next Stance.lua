-- Alias: Next Stance
-- Attribute: isActive

-- Pattern: ^(?i)(nextdance|nextstance)(?: (\w+)? ?(\d+)?)?$

-- Script Code:
-- Get the stance name and optional timer from the captured matches.
local stanceName = matches[3]  -- required argument (e.g. "dervish")
local manualStanceTimer = matches[4]  -- optional argument (a number between 0 and 20)

-- If no stance name was provided, show syntax help.
if not stanceName or stanceName == "" then
  showCmdSyntax("NextStance/NextDance\n\tSyntax: nextstance <stance> [<timer>]",
    {{"nextstance <stance> [<timer>]", "Overrides autostance to manually change to the next dance."},
     {"","Optionally set timer (0-20)."}})
  return
end

-- Ensure the command is only for Bladedancers.
if StatTable.Class ~= "Bladedancer" then
  printMessage("NextStance error", "This command is only for bladedancers.")
  return
end

stanceName = string.lower(stanceName)

-- If a timer was provided, validate it.
if manualStanceTimer then
  manualStanceTimer = tonumber(manualStanceTimer)
  if not manualStanceTimer or manualStanceTimer < 0 or manualStanceTimer > 20 then
    printMessage("NextStance error", "Invalid timer value. Must be a number between 0 and 20.")
    return
  end
end

-- Set the global variables for the next stance.
GlobalVar.NextStance = stanceName
if manualStanceTimer then
  GlobalVar.NextStanceTimer = manualStanceTimer
else
  GlobalVar.NextStanceTimer = nil
end

-- If no stance timers are active, immediately try switching.
if not (StatTable.InspireTimer or StatTable.BladedanceTimer or StatTable.DervishTimer or StatTable.VeilTimer or StatTable.UnendTimer) then
  TryAction("stance " .. GlobalVar.NextStance, 5)
  local timerMsg = manualStanceTimer and (" with timer " .. manualStanceTimer) or ""
  printMessage("NextStance", "No stance active, activating " .. GlobalVar.NextStance .. timerMsg .. " now.")
  GlobalVar.NextStance = nil
  GlobalVar.NextStanceTimer = nil
  return
end

printMessage("NextStance", "Next stance will be " .. GlobalVar.NextStance .. (manualStanceTimer and (" with timer " .. manualStanceTimer) or ""))
