-- Alias: sabletarget
-- Attribute: isActive

-- Pattern: ^(?i)sabletarget(?: (.*))?$

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "" then
  showCmdSyntax("SableTarget\n\tSyntax: sabletarget <character>", {
    {"sabletarget <character>", "Will pass sable arrows looted to <character>"},
    {"sabletarget clear", "No longer tries to pass sable arrows"},
  })
  if SableTarget then
    cecho("\nCurrent SableTarget: <yellow>" .. SableTarget)
  end
elseif args == "clear" then
  SableTarget = nil
else
  print("SableTarget: set to " .. args)
  SableTarget = args
end
  