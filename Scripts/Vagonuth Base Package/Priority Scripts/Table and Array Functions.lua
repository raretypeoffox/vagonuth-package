-- Script: Table and Array Functions
-- Attribute: isActive

-- Script Code:
 -- print out an array, for debugging
 -- Only works for an array (i.e. numerically indexed table)
 function ArrayShow(t)
  for i=1,#t do    
    print("total:"..#t, "i:"..i, "v:"..t[i]);
  end
end

-- Works on Tables and Arrays, including nested tables
function TableDump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. TableDump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function TableShow(t)
  print(TableDump(t))
end

function TableSize(t)
  if type(t) ~= "table" then error("TableSize() requires a table as an argument") end
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end


-- Returns true if value 'val' is in array 'tab', otherwise false
function ArrayHasValue(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
    return false
end

function compareTables(t1, t2)
  if type(t1) ~= "table" or type(t2) ~= "table" then
    return false
  end
  for k,v in pairs(t1) do
    if type(v) == "table" then
      if not compareTables(v, t2[k]) then
        return false
      end
    else
      if t2[k] ~= v then
        return false
      end
    end
  end
  for k,v in pairs(t2) do
    if type(v) == "table" then
      if not compareTables(v, t1[k]) then
        return false
      end
    else
      if t1[k] ~= v then
        return false
      end
    end
  end
  return true
end


-- Check if an array has a given substring within one of its members
-- Not designed for large arrays
function ArrayHasSubstring(array, substring)

  assert(#array<1000)
  
  for i=1,#array do    
    if (string.find(substring,array[i]) ~= nil) then
        return true
    end
  end
  
  return false
end


-- Use this function via ArrayRemove below
function _ArrayRemove(t, fnKeep)
    local j, n = 1, #t;

    for i=1,n do
        if (not fnKeep(t, i, j)) then
            -- Move i's kept value to j's position, if it's not already there.
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil;
            end
            j = j + 1; -- Increment position of where we'll place the next kept value.
        else
            t[i] = nil;
        end
    end

    return t;
end

-- ArrayRemove: removes all instances of "string" in numberically indexed table "t"
-- Only works for an array (i.e. numerically indexed table)
-- From Stack Overflow: https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating
function ArrayRemove(t, string)
  _ArrayRemove(t, function(t, i, j)
      -- Return true to keep the value, or false to discard it.
      local v = t[i];
      return (v == string);
      -- To remove multiple values, use return (v == "a" or v == "b" or v == "c"); etc 
  end)
end

-- https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
function deepcopy(o, seen)
  seen = seen or {}
  if not o  then return {} end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end


-- compare functions for sorting tables, e.g., table.sort(array,compare)
function compare(a,b)
  return a[1] < b[1]
end

function rcompare(a,b)
  return a[1] > b[1]
end