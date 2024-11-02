-- Script: Psi Weapon Triggers
-- Attribute: isActive

-- Script Code:
PSITrigger = PSITrigger or {}
PSITrigger.TriedLookUp = PSITrigger.TriedLookUp or {}
PSITrigger.OnlinePath = "https://raw.githubusercontent.com/raretypeoffox/vagonuth-package/main"
PSITrigger.DownloadPath = getMudletHomeDir()
PSITrigger.Filename = "/PsiTriggers.lua"

PSITrigger.PsiTriggers = {}
PSITrigger.GravitasMobs = PSITrigger.GravitasMobs or {} -- used for gravitas trigger

-- Psi Triggers README
-- Psi Triggers by default are downloaded from https://raw.githubusercontent.com/raretypeoffox/vagonuth-package/main/PsiTriggers.lua
-- This keeps your Psi Trigger list up to date without you having to manually manage it.
-- To add your own Psi Triggers or if the online list is out of date, add the triggers to the table below (PSIWeaponLookUp)
-- The triggers in the table below will overwrite the online trigger.

-- PSIWeaponLookup Table
-- Add groupmate's psi weapons in the table below.
-- Format:
-- ["CharName"] = {w1name = "full weapon's name", w1keyword = "keyword", w2name = "full weapon's name", w2keyword = "keyword"},
-- Note for Heroes: just use w1name / w1 keyword
local PSIWeaponLookup = {
  ["Xanur"] = {w1name = "Xanur's Masamune", w1keyword = "xanur.wield", w2name = "Xanur's Murasame", w2keyword = "xanur.off"},
  ["Forseti"] = {w1name = "Fleshslicer", w1keyword = "forseti", w2name="Fleshrender", w2keyword = "forseti"},
  ["NinehundreD"] = {w1name = "*-<PAIN>-*", w1keyword = "pain", w2name="*-<AGONY>-*", ws2keyword = "agony"},
  ["Vulkan"] = {w1name = "A Winged Angel", w1keyword = "lordkdr", w2name = "A Winged Devil", w2keyword = "lordkrd"},
  ["Eanruig"] = {w1name = "Chondrite Longsword", w1keyword = "eanruigw", w2name = "Chondrite Shortsword", w2keyword = "eanruigo"},
  }
  

function PSITrigger.Create(charname, weaponname, weaponkeyword)
  -- ^(.*) clatters to the ground!$
  -- ^You get (.*) from corpse of
  -- ^(.*) falls to the ground, lifeless.
  
  -- TODO add this trigger: You need to wield a lighter weapon in your offhand.
  local TriggerID = charname .. weaponname
  print("CreatePsiTrigger called: ", charname, weaponname, weaponkeyword)

  if charname == StatTable.CharName then
    safeTempTrigger(TriggerID .. "A", weaponname .. " clatters to the ground!", function() send("get '" .. weaponkeyword .. "'"); send("wear '" .. weaponkeyword .. "'") end, "begin")
    safeTempTrigger(TriggerID .. "B", "You get " .. weaponname .. " from corpse of ", function() send("wear '" .. weaponkeyword .. "'") end, "begin")
    safeTempTrigger(TriggerID .. "C", weaponname .. " falls to the ground, lifeless.", function() send("get '" .. weaponkeyword .. "'"); send("wear '" .. weaponkeyword .. "'") end, "begin")
    safeTempTrigger(TriggerID .. "D", "gives you several items.", function() send("wear '" .. weaponkeyword .. "'") end, "substring")
    safeTempTrigger(TriggerID .. "E", "You must be wielding two weapons to use this spell!", function() send("wear '" .. weaponkeyword .. "'") end, "begin")
    safeTempTrigger(TriggerID .. "F", "gives you " .. weaponname .. ".", function() send("wear '" .. weaponkeyword .. "'") end, "substring")
    
  else
    safeTempTrigger(TriggerID .. "A", weaponname .. " clatters to the ground!", function() send("get '" .. weaponkeyword .. "'"); send("give '" .. weaponkeyword .. "'" .. " " .. charname) end, "begin")
    safeTempTrigger(TriggerID .. "B", "You get " .. weaponname .. " from corpse of ", function() send("give '" .. weaponkeyword .. "'" .. " " .. charname) end, "begin")
    safeTempTrigger(TriggerID .. "C", weaponname .. " falls to the ground, lifeless.", function() send("get '" .. weaponkeyword .. "'"); send("give '" .. weaponkeyword .. "'" .. " " .. charname) end, "begin")
  end

end

-- Called by GMCP GroupUpdate when there's a new Psi in the gorup
function PSITrigger.Update()
  if not GlobalVar or not GlobalVar.GroupMates then return false end

  for char, chartbl in pairs(GlobalVar.GroupMates) do
    if chartbl.class == "Psi" then
      -- Iterates over every Psi in the group that's not me

      -- Record that we've looked up this Psi already
      PSITrigger.TriedLookUp[char] = true

      if PSITrigger.PsiTriggers[char] then -- If we have weapon details for this Psi, create a trigger
        local w1name, w1keyword = PSITrigger.PsiTriggers[char].w1name or nil, PSITrigger.PsiTriggers[char].w1keyword or nil
        local w2name, w2keyword = PSITrigger.PsiTriggers[char].w2name or nil, PSITrigger.PsiTriggers[char].w2keyword or nil

        if w1name and w1keyword then
          PSITrigger.Create(char, w1name, w1keyword)
        end
        
        if w2name and w2keyword then
          PSITrigger.Create(char, w2name, w2keyword)
        end
        
      end
    end
  end -- end for loop
end


function PSITrigger.Load()
  local PsiTriggersFromFile = {}
  if io.exists(PSITrigger.DownloadPath .. PSITrigger.Filename) then
    table.load(PSITrigger.DownloadPath .. PSITrigger.Filename, PsiTriggersFromFile)
    PSITrigger.PsiTriggers = deepcopy(PsiTriggersFromFile)
  end
  for char_name, psitrigger in pairs(PSIWeaponLookup) do
    PSITrigger.PsiTriggers[char_name] = psitrigger
  end
end

function PSITrigger.DownloadFile()
    if not io.exists(PSITrigger.DownloadPath) then lfs.mkdir(PSITrigger.DownloadPath) end
    PSITrigger.Downloading=true
    downloadFile(PSITrigger.DownloadPath .. PSITrigger.Filename, PSITrigger.OnlinePath .. PSITrigger.Filename)
end

function PSITrigger.onFileDownloaded(event, ...)
  if event == "sysDownloadDone" and PSITrigger.Downloading then
      local file = arg[1]
      if string.ends(file,PSITrigger.Filename) then
          PSITrigger.Downloading=false
          PSITrigger.Load()
      end
  end
end

PSITrigger.Load()
PSITrigger.downloadFileHandler = safeEventHandler("PSIFileDownloadFileHandler", 'sysDownloadDone', "PSITrigger.onFileDownloaded")
safeTempTimer("PsiFileDownloadTimer", 2, [[PsiFile.DownloadFile()]])




