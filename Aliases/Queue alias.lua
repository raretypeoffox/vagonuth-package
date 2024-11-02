-- Alias: Queue alias
-- Attribute: isActive

-- Pattern: ^(?i)queue(?: (show|clear)? ?(.*?))?$

-- Script Code:
cmd = matches[2] or ""
args = matches[3] or ""



if cmd == "" then
  if args == "" then 
    local cmd_name = "OnMobDeath Queue\n\tSyntax: queue (<command>|show|clear)"
    local syntax_tbl = {
      {"queue <command>", "Queues a command to be performed after a mob dies"},
      {nil, "Only one command is performed per kill."},
      {nil, "Queue multiple commands at once using the | character"},
      {nil, "e.g., queue score|group"},
      {"",nil},
      {"queue show", "Shows the list of commands in the queue"},
      {"queue clear", "Clears the entire queue"}
    }
    showCmdSyntax(cmd_name, syntax_tbl)
    return
  else
    OnMobDeathQueue(string.gsub(args, "|", getCommandSeparator()))
  end
end

if cmd == "show" then
  display(MobDeath.Queue)
elseif cmd == "clear" then
  OnMobDeathQueueClear()
  MobDeath.LastCommand = ""  
end