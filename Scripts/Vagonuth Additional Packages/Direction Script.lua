-- Script: Direction Script
-- Attribute: isActive

-- Script Code:
GlobalVar.LastDirs = GlobalVar.LastDirs or {}
GlobalVar.LastPop = GlobalVar.LastPop or nil
GlobalVar.DirCount = GlobalVar.DirCount or 0

local MAXDIRS = 30

function AddDir(dir)
  if not GlobalVar.LastDirs then GlobalVar.LastDirs = {} end
  
  if #GlobalVar.LastDirs >= MAXDIRS then
    GlobalVar.LastPop = GlobalVar.LastDirs[1]
    table.remove(GlobalVar.LastDirs, 1)
  end
  
  table.insert(GlobalVar.LastDirs, dir:sub(1,1))
  GlobalVar.DirCount = GlobalVar.DirCount + 1
end

function RemoveDir(dir)
  if not GlobalVar.LastDirs then GlobalVar.LastDirs = {}; return end

  dir = dir:sub(1,1)
  
  if GlobalVar.LastDirs[#GlobalVar.LastDirs] == dir then
    table.remove(GlobalVar.LastDirs)
  end
  
  if #GlobalVar.LastDirs == (MAXDIRS -1) and GlobalVar.LastPop then table.insert(GlobalVar.LastDirs, 1, GlobalVar.LastPop) end
  
  return
end

function ClearDirs()
  GlobalVar.LastDirs = {}
  GlobalVar.DirCount = 0
  return 
end

function FormatDirs()
  local ret_str = ""
  
  if not GlobalVar.LastDirs then return ret_str end
  
  ret_str = ret_str .. "<white>"

  for n,dir in ipairs(GlobalVar.LastDirs) do
    if n == #GlobalVar.LastDirs then 
      ret_str = ret_str .. "<yellow>" .. dir .. "\n"
    else
      ret_str = ret_str .. dir .. ","
    end
  end

  return ret_str

end

function FormatDirsAlt(tbl)
    if not tbl or type(tbl) ~= "table" then
        return ""
    end

    local result = "<white>"
    local count = 1 -- Start with 1 since we count the first occurrence
    local n = #tbl

    for i = 1, n do
        local currentElement = tbl[i]
        local nextElement = tbl[i + 1]

        if currentElement == nextElement then
            count = count + 1
        else
            if count > 1 then
                result = result .. count
            end
            
            if i ~= #tbl then 
              result = result .. currentElement .. ","
            else
              result = result .. "<yellow>" .. currentElement .. "\n"
            end
            count = 1
        end
    end

    return result
end


function ShowDirs()

  local string_format = FormatDirsAlt(GlobalVar.LastDirs)
  cecho(string_format)
  cecho("\nTotal Dirs:\t" .. GlobalVar.DirCount .. "\n")

end

safeEventHandler("OnPlaneResetDirs", "OnPlane", function() ClearDirs() end)