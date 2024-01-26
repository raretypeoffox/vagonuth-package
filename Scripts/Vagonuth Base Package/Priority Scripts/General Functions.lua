-- Script: General Functions
-- Attribute: isActive

-- Script Code:
-- format_int(number), where number is an integer, returns a formatted string
function format_int(number)
  -- Handle non-numeric inputs
  if type(number) ~= "number" then
    return "format_int(): invalid input"
  end

  local str = tostring(number)
  local minus, int, fraction = str:match('([-]?)(%d+)([.]?%d*)') -- first tries to match optional negative sign, then captures whole number, then captures optional decimal

  -- Insert commas for thousands, millions, etc.
  local formatted = ""
  local length = #int
  for i = 1, length do
    formatted = formatted .. int:sub(i, i)
    if (length - i) % 3 == 0 and i ~= length then
      formatted = formatted .. ","
    end
  end

  return minus .. formatted .. fraction
end

-- Returns str with the first letter capitalized
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- Returns char_name in GMCP format (for matching data)
-- could be done directly in a function with: string.lower(StatTable.CharName):gsub("^%l", string.upper)
function GMCP_name(char_name)
  return firstToUpper(string.lower(char_name))
end

function splitstring(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function texttocolour(colour, args)
        local str = ""
        local colours = { "|"..colour.."|", "|"..colour.."|",  "|"..colour.."|", "|"..colour.."|", "|B"..colour.."|" }
        local pass = 1
 
        for char in args:gmatch"." do
                str = str .. colours[pass] .. char
                if pass == #colours then pass = 1 end
                pass = math.random (1,5)
        end
 
        return (str)
end

-- Returns first word in a string
function first_word_in_string(str)
  assert(str~=nil)
  local words = {}
  words[1], words[2] = str:match("(%w+)(%W+)")
  if words[1] == nil then words[1] = str end
  return words[1]
end

function pdebug(string)
  if (GlobalVar.Debug) then
    cecho("\n<white>DEBUG<ansi_white>: " .. string .. "\n")
  end
end



function reversedir(dir)
   if (dir == "north") then return "south"
   elseif(dir == "south") then return "north"
   elseif(dir == "west") then return "east"
   elseif(dir == "east") then return "west"
   elseif(dir == "up") then return "down"
   elseif(dir == "down") then return "up"
   else error("reversedir() error: bad input") end
end


-- References: 
-- https://www.lua.org/pil/23.1.html
-- https://stackoverflow.com/questions/10838961/lua-find-out-calling-function
function traceback()
    local current_func = debug.getinfo(2,"n")
    local calling_func = debug.getinfo(3,"n")
    if (calling_func.name) then print(current_func.name.. "() was called by ".. calling_func.name.. "()!") end
end

function traceback_detail()
  local level = 1
  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then break end
    if info.what == "C" then   -- is a C function?
      print(level, "C function")
    else   -- a Lua function
      if (info.name) then
        print(string.format("[%s] line %d: %s",
                            info.short_src, 
                            info.currentline, info.name))
      else
        print(string.format("[%s] line %d",
                  info.short_src, 
                  info.currentline))
      end
    end
    level = level + 1
  end
end

-- example: lua showCmdSyntax("Autokill",{{"Autokill <target>","Blah Blah"},{"Killstyle <style>","ooga booga"}})
function showCmdSyntax(cmd_name, syntax_tbl, showCmdColour)
  if type(cmd_name) ~= "string" or type(syntax_tbl) ~= "table" then
    error("showCmdSyntax: Invalid inputs (expected string, table)")
    return false
  end
  
  showCmdColour = showCmdColour or "white" -- https://wiki.mudlet.org/images/c/c3/ShowColors.png
  
  cecho("<"..showCmdColour..">"..cmd_name.."\n")
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
  for _, v in ipairs(syntax_tbl) do
    local dash = (v[1] and v[2]) and "- " or "  "
    local formatStr = string.format("<%s>%-31s%s\n", showCmdColour, v[1] and " " .. v[1] or "", dash .. (v[2] or ""))
    cecho(formatStr)
  end
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
end

function showTableThreeColwithHeader(cmd_name, syntax_tbl, showCmdColour)
  if type(cmd_name) ~= "string" or type(syntax_tbl) ~= "table" then
    error("showCmdSyntax: Invalid inputs (expected string, table)")
    return false
  end
  
  showCmdColour = showCmdColour or "white" -- https://wiki.mudlet.org/images/c/c3/ShowColors.png
  
  cecho("<"..showCmdColour..">"..cmd_name.."\n")
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
  cecho(string.format("<%s>%-30s%-30s%s\n", showCmdColour, syntax_tbl[1][1], syntax_tbl[1][2], syntax_tbl[1][3]))
  table.remove(syntax_tbl,1)
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
  for _, v in ipairs(syntax_tbl) do
    local formatStr = string.format("<%s>%-30s%-30s%s\n", showCmdColour, v[1], v[2], v[3])
    cecho(formatStr)
  end
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
end

function printMessage(title, message, colour)
  colour = colour or "white"
  
  local formatStr = string.format("<%s>%s<ansi_%s>: %s\n", colour, title, colour, message)
  cecho(formatStr)
end

function printGameMessage(title, message, colour, colour_message)
  colour = colour or "white"
  colour_message = colour_message or ("ansi_" .. colour)
  
  local formatStr = string.format("<%s>%s<%s>: %s\n", colour, title, colour_message, message)
  cecho(StaticVars.GameMsgsChatOutput, formatStr)
end

-- Send less important game messages here so players can turn them off
function printGameMessageVerbose(...)
  if not GlobalVar.Verbose then return end
  printGameMessage(...)
  
end

-- Only calls a functon if it exists
-- usage: safeCall(function_name, arg1, arg2, etc)
function safeCall(func, ...)
    if type(func) == "function" then
        return func(...)  -- Call the function and return its result, if any
    end
end


function RemoveColourCodes(name)
    -- Remove sequences that start with \27 followed by [ and then has one or more digits, a semicolon, again one or more digits and ends with an 'm'
    local stripped = string.gsub(name, "\27%[%d+;%d+m", "")
    
    stripped = string.gsub(stripped, "%[%d+;%d+m", "")

    -- Remove sequences that start with \27
    stripped = string.gsub(stripped, "\27", "")

    -- Remove squares that have |xX| colour stripAnsiCodes
    stripped = string.gsub(stripped,"|%w+|","")

    return stripped
end

function Connected()
  local _, _, ret = getConnectionInfo()
  return ret
end


