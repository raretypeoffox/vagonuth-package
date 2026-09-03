if matches[2] == GlobalVar.AutoViolateItem then
  GlobalVar.AutoViolate = false
  send("quicken off")
  send("sleep")
end