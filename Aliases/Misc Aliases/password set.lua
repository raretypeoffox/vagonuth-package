-- Alias: password set
-- Attribute: isActive

-- Pattern: ^pwd ?(\w+)?$

-- Script Code:
if matches[2] == nil or matches[2] == "" then
  print("[wd <password> -- sets password to autologin with (use password 'clear' to remove)")
elseif matches[2] == "clear" then
  GlobalVar.Password = nil
  SaveProfileVars()
else
  GlobalVar.Password = matches[2]
  SaveProfileVars()
end