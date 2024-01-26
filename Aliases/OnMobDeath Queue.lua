-- Alias: OnMobDeath Queue
-- Attribute: isActive

-- Pattern: ^(?i)queue ?(.*)

-- Script Code:
matches[2] = string.lower(matches[2])

if (matches[2] == "clear") then
  OnMobDeathQueueClear()
  MobDeath.LastCommand = ""
elseif (matches[2] == "show") then
  display(MobDeath.Queue)
elseif (matches[2] ~= "") then
  OnMobDeathQueue(string.gsub(matches[2], "|", getCommandSeparator()))
else
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
end