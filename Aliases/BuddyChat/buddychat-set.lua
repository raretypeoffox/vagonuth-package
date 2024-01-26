-- Alias: buddychat-set
-- Attribute: isActive

-- Pattern: ^(?i)bud-set ?(\w+)? ?(\w+)?$

-- Script Code:
if matches[2] == nil or matches[2] == "" or matches[3] == nil or matches[3] == "" then
  print("bud-set sets the character name and colour for your buddy chat messages")
  print("Usage: bud-set <main_char_name> <colour_letter>")
  print("")
  print("<main_char_name> is the main account name you wish to be known by")
  print("<colour_letter> is the colour you want to go by [single letter, see help colours]")
else

  local colour_code = string.upper(matches[3])
  
  if colour_code ~= "B" and colour_code ~= "C" and colour_code ~= "G" and colour_code ~= "R" and colour_code ~= "Y" and colour_code ~= "W" and colour_code ~= "P" then
    print("bud-set error: <colour_letter> must be one of B, C, G, R, Y, W or P - see help colours")
    
  else

    GlobalVar.BuddyChatName = matches[2]
    GlobalVar.BuddyChatColour =  matches[3]
    SaveProfileVars()
  end
end