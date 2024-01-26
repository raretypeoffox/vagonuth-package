-- Alias: autolotto alias
-- Attribute: isActive

-- Pattern: ^(?i)autolotto(?: (init|start|bag|pinfo|clear|update|uselist)? ?(.*?))?$

-- Script Code:
cmd = (matches[2] and string.lower(matches[2]) or "")
args = matches[3] or ""

if cmd == "start" then
  AutoLotto.Start()
elseif cmd == "init" then
  AutoLotto.Init()
elseif cmd == "pinfo" then
  if Battle.Combat then
    printMessage("AutoLotto", "run autolotto pinfo when out of combat")
    return
  end
  enableTrigger("On PInfo")
  send("pinfo show", false)
elseif cmd == "bag" then
  if args == nil or args == "" then
    printMessage("AutoLotto", "format is autolotto bag <keyword> <bagname>")
    return
  else
    local words = {}
    words[1], words[2] = args:match("(%w+) (.*)")
    if words[1] == nil then words[1] = args end
    
    if words[2] == nil then 
      printMessage("AutoLotto", "format is autolotto bag <keyword> <bagname>")
      return
    end
    
    AutoLotto.SetBag(words[1], words[2])
    
  end
elseif cmd == "clear" then
  AutoLotto.CleanUp()
elseif cmd == "update" then
  AutoLotto.PopulateBag(AutoLotto.BagID)
elseif cmd == "uselist" then
  safeKillEventHandler("ProcessLotto")
  AutoLotto.ProcessLotto()
else
  showCmdSyntax("AutoLotto\n\tSyntax: autolotto <cmd> <optional arg>", {
    {"autolotto bag <keyword> <name>", "set the bag keyword and name, must be in your inventory"},
    {"autolotto pinfo", "run this first, saves your pinfo list"},
    {"autolotto init", "initializes autolotto, review the pinfo list"},
    {"autolotto start", "starts autolotto once initialized"},
    {"",""},
    {"Troubleshooting", ""},
    {"",""},
    {"autolotto clear", "used to end lotto early (eg if something breaks)"},
    {"autolotto update", "used to repopulate loot list after putting loot late into bag"},
    {"autolotto uselist", "if leader lotto's early, do autolotto start / autolotto uselist"},

    })
end
