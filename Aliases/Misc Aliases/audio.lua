local action = matches[2] and string.lower(matches[2]) or "status"

if action == "status" then
  print(VagoAudio:Status())
  print("audio (status|mudlet|windows|test) -- select or test the sound player")
elseif action == "test" then
  print(VagoAudio:Status())
  VagoAudio:Test()
else
  local ok, message = VagoAudio:SetBackend(action)
  print(message)
  if ok and action == "windows" then
    print("This fallback bypasses Mudlet's Qt audio path. Type 'audio test' to verify all four sounds.")
    print("Its volume is controlled by the Windows volume mixer under Windows PowerShell.")
  end
end
