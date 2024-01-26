-- Script: Psi Weapon Triggers
-- Attribute: isActive

-- Script Code:

-- PSIWeaponLookup Table
-- Add groupmate's psi weapons in the table below.

-- Format:
-- ["CharName"] = {w1name = "full weapon's name", w1keyword = "keyword", w2name = "full weapon's name", w2keyword = "keyword"},
-- Note for Heroes: just use w1name / w1 keyword

local PSIWeaponLookup = {
  ["Xanur"] = {w1name = "Xanur's Masamune", w1keyword = "xanur.wield", w2name = "Xanur's Murasame", w2keyword = "xanur.off"},
  ["Asha"] = {w1name = " Pain", w1keyword = "pain", w2name = " Fear", w2keyword = "fear"},
  ["Rawil"] = {w1name = "a holy noodle of R'amen", w1keyword = "noodle", w2name = "a spear shaped bucatini", w2keyword = "bucatini"},
  ["Flood"] = {w1name = "TICKLE FIGHT", w1keyword = "hitt"},
  ["Sludge"] = {w1name = "Sludge's fiery wield", w1keyword = "sludge"},
  ["Chronos"] = {w1name = "Trained Attack Sprite", w1keyword = "sprite"},
  ["Kylise"] = {w1name = "a saber of pure light", w1keyword = "ky"},
  ["Photon"] = {w1name = "A winged angel", w1keyword = "wing"},
  ["Glitch"] = {w1name = "Glitch", w1keyword = "glitch"},
  ["Meista"] = {w1name = "Kiss of the Dragkhar", w1keyword = "meista"},
  ["Volarys"] = {w1name = "Excelsior V", w1keyword = "excelsior", w2name = "Exantus V", w2keyword = "exantus"},
  ["Claap"] = {w1name = "CLICK CLICK", w1keyword = "calpchak"},
  ["Ramahdon"] = {w1name = "TICKLE FIGHT", w1keyword = "hitt"},
  ["Fango"] = {w1name = "Green Destiny", w1keyword = "destiny"},
  ["Aginor"] = {w1name = "Kiss of the Dragkhar", w1keyword = "aginoroffh", w2name = "Myrddraal's Blade", w2keyword = "aginorwield"},
  ["Tysthet"] = {w1name = "Malicious Whispers", w1keyword = "malicious"},
  ["Forseti"] = {w1name = "Fleshrender", w1keyword = "forseti", w2name = "Fleshslicer", w2keyword = "forseti"},
  ["Cheddar"] = {w1name = "CHEDDAR", w1keyword = "calpchak32", w2name = "CHEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEZE", w2keyword = "calpchak2c"},
  ["Ramahdon"] = {w1name = "I AM BEYONCE, ALWAYS", w1keyword = "hitt stick", w2name = "TICKLE FIGHT", w2keyword = "hitt stick"},
  --["Ninehundred"] = {w1name = "The \"Gotcha!\" Blade", w1keyword = "got"},
  ["Ninehundred"] = {w1name = "Gotcha!", w1keyword = "got"},
  ["Celeste"] = {w1name = "a shiny sword", w1keyword = "15387031339"},
  --["Blaset"] = {w1name = "Blaset's Blaset-ing Sword", w1keyword = "mandel"},
  ["Blaset"] = {w1name = "Tourach's Sword", w1keyword = "mandel"},
  ["Thirdeye"] = {w1name = "Bacon Buster", w1keyword = "bacon"},
  ["Zygarth"] = {w1name = "Zygarth's silver sword", w1keyword = "zygarth", w2name = "Zygarth's offhand silver sword", w2name = "zygarth"},
  }
  
  PSITrigger = PSITrigger or {}
  PSITrigger.TriedLookUp = PSITrigger.TriedLookUp or {}
  
  --safeEventHandler("PSITrigger.TriedLookUpResetID", "OnPreachUp", [[PSITrigger.TriedLookUp = {}]], false)
  
  
  -- ^(.*) clatters to the ground!$
  -- ^You get (.*) from corpse of
  -- ^(.*) falls to the ground, lifeless.
  
  -- TODO add this triggeR: You need to wield a lighter weapon in your offhand.
  
  function PSITrigger.Create(charname, weaponname, weaponkeyword)
  
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
  
        if PSIWeaponLookup[char] then -- If we have weapon details for this Psi, create a trigger
          local w1name, w1keyword = PSIWeaponLookup[char].w1name or nil, PSIWeaponLookup[char].w1keyword or nil
          local w2name, w2keyword = PSIWeaponLookup[char].w2name or nil, PSIWeaponLookup[char].w2keyword or nil
  
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
  


