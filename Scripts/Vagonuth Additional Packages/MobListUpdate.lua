-- Script: MobListUpdate
-- Attribute: isActive
-- MobListUpdate() called on the following events:
-- gmcp.Room.Players

-- Script Code:
-- MobList[zone][mob_fullname].keyword
-- MobList[zone][mob_fullname].autotarget
-- MobList[zone][mob_fullname].friendly
-- MobList[zone][mob_fullname].race

MobListExclusions = {
"Norhand clutches his prayerbook close to his robe.",
"Rikar wearily scans the room, ever ready.",
"During an idle moment, Airen consults her ever-ready spellbook.",

"Thokas occasionally flips through the pages of his spellbook.",
"Scanning the surrounding area for trouble, Besaur waits nearby.",
"A thin wisp of green smoke rises from Tanin's fingers.",

"An agile looking cleric, Maraver, stands close by ready to heal.",
"Nalfar tests the weight of his weapon, shuffling it from hand to hand.",
"Ayne quietly casts a spell to charge the air, puffing up her hair.",


"With a touch of ancient wisdom in his eyes, Hordak builds protection spells.",
"With a grim smile, Teli idly waits to jump into the fray.",
"Eiridan calmly stands here, building a spell of defense.",

"Stinkin' Human"
}


MobList = MobList or {}

MobListSetZone = MobListSetZone or ""
MobListSetKeyword = MobListSetKeyword or ""
MobListCoroutine = MobListCoroutine or nil 



function SaveMobList()
  local location = getMudletHomeDir() .. "/MobList.lua"
  table.save(location, MobList)
end

function LoadMobList()
  local location = getMudletHomeDir() .. "/MobList.lua"
  if io.exists(location) then
    table.load(location, MobList)
  end
end

if #MobList == 0 then LoadMobList() end

function MobListAdd(mobname, mobrace, mobspec)
    if not MobList[gmcp.Room.Info.zone] then
      MobList[gmcp.Room.Info.zone] = {}
    end

    assert(not MobList[gmcp.Room.Info.zone][mobname], "MobListAdd(): " .. mobname .. " already on list, returning")
  
    MobList[gmcp.Room.Info.zone][mobname] = {}
    MobList[gmcp.Room.Info.zone][mobname].name = "keyword"
    MobList[gmcp.Room.Info.zone][mobname].race = mobrace
    MobList[gmcp.Room.Info.zone][mobname].spec = mobspec

end


function MobListUpdate()
  local Players = gmcp.Room.Players
  
  if not MobList[gmcp.Room.Info.zone] then
    MobList[gmcp.Room.Info.zone] = {}
  end

  for k,_ in pairs(Players) do
  
    -- Mobs have numbered "names" vs PCs who have real names, can eliminate PCs by removing non-numbered names
    if (tonumber(Players[k].name) ~= nil) then 
        local i, j = 0, 0
        s = Players[k].fullname
        --print("MobListUpdate(): \t", s)
        -- Strip brackets, first for single words, second for double words (eg White Aura), likely a better way to do this
        s = string.gsub(s,"%((%a+)%)","")
        s = string.gsub(s,"%((%a+ %a+)%)","")
        -- Strip leading and trailing white space
        s = string.gsub(s, '^%s*(.-)%s*$', '%1')
        -- Find the start/end of the pattern: "is here, fighting"
        i, j = string.find(s,"is here, fighting")
        m, n = string.find(s,"is resting here.")
        
        -- If Mob isn't fighting, isn't resting and isn't on the exclusion list
        if (i == nil and m == nil and not ArrayHasSubstring(MobListExclusions, s)) then
        
          if not TableHasIndex(MobList[gmcp.Room.Info.zone],s) then
            MobListAdd(s, Players[k].race, Players[k].spec)
            SaveMobList()
          else
            -- Used during the transition to tracking race &amp; specs
            MobList[gmcp.Room.Info.zone][s].race = Players[k].race
            MobList[gmcp.Room.Info.zone][s].spec = Players[k].spec
            SaveMobList()
          end
        end
    end
  end
end

-- for debugging
function ShowMobList()
  -- k = area name, v = area table
  for k,v in pairs(MobList) do
    -- i = mob name, j = mob table
    for i,j in pairs(v) do
      print(k, j.name, j.race, j.spec)
    end
  end
end


function SetMobListZone(zone)

  if not MobList[zone] then
    print("Error SetMobListZone(): not a zone currently in MobList")
    return false    
  end
  
  MobListSetZone = zone
  print("SetMobListZone(): zone set successfully to " .. zone)
  return true
end

function SetMobList()
  if not MobList[MobListSetZone] then
    print("Error SetMobList(): set a zone first")
    return false    
  end

  for i, j in pairs(MobList[MobListSetZone]) do
    if j.name == "keyword" then
      echo("Next Mob: " .. i .. "\n")
      coroutine.yield()
      MobList[MobListSetZone][i].name = MobListSetKeyword 
      echo(i .. " set to " .. MobListSetKeyword .. "\n")
    end
  end
  SaveMobList()
  print("Done! All mobs set for this zone")
end

function MobListDisplay(zone)
  cecho("<white>Displaying all mobs found in zone\n")
  cecho("<white>---------------------------------------------------------------------------------------\n")
  for i,j in pairs(MobList[zone]) do
      cecho(string.format("<white>%-20s- %s\n",j.name,i))
  end
  cecho("<white>---------------------------------------------------------------------------------------\n")
end

function MobListDisplaySpec(zone)
  cecho("<white>Displaying all mobs with specs in zone\n")
  cecho("<white>---------------------------------------------------------------------------------------\n")
  for i,j in pairs(MobList[zone]) do
    if j.spec ~= "unknown spec" then
      cecho(string.format("<white>%-25s- %s\n",j.spec,i))
    end
  end
  cecho("<white>---------------------------------------------------------------------------------------\n")
end


-- Used to one time transition to new data structure
--function MobListTrans()
--  local TestTable = {}
--  for x, y in pairs(MobList) do
--    TestTable[x] = {}
    
--    for a, b in pairs(y) do
--      TestTable[x][a] = {}
--      TestTable[x][a].name = b
--      TestTable[x][a].race = "race"
--      TestTable[x][a].spec = "spec"
--      --print(x,a,b)
--    end
--  end
--  print("---")
--  display(TestTable)
  --MobList = deepcopy(TestTable)
--end

-- Used if I ever want to expand the MobList table to add a newvar
function MobListAddToTableStruct()
  for x, y in pairs(MobList) do
    for a, _ in pairs(y) do
      MobList[x][a].newvar = "newvar"
    end
  end
end
