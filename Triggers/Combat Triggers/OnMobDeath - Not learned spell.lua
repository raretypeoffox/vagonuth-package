if type(BuffManager) == "table" and type(BuffManager.MarkSpellUnavailable) == "function" then
  local reason = string.find(matches[1] or "", "shadow form%.$") and "shadow form" or "not learned"
  BuffManager.MarkSpellUnavailable(matches[2], reason)
elseif MobDeath.LastCommand ~= "" then
  MobDeath.LastCommand = ""
end