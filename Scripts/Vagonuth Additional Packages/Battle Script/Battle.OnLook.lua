-- Script: Battle.OnLook
-- Attribute: isActive
-- Battle.OnLook() called on the following events:
-- gmcp.Room.Players
-- gmcp.Room.AddPlayer
-- gmcp.Room.RemovePlayer

-- Script Code:
Battle = Battle or {}
Battle.GroupiesUnderAttack = Battle.GroupiesUnderAttack or {}
Battle.EnemiesAttacking = Battle.EnemiesAttacking or {}
Battle.EnemiesChakra = Battle.EnemiesChakra or {}
Battle.MobCount = Battle.MobCount or 0

function Battle.OnLook()
  local Players = gmcp.Room.Players
  local mobcount = 0
  
  Battle.GroupiesUnderAttack = {}
  Battle.EnemiesAttacking = {}
  Battle.EnemiesChakra = {}
  
  -- Sort all Players into Battle.EnemiesAttacking and Battle.GroupiesUnderAttack
  for k,v in pairs(Players) do
  
    -- Mobs have numbered "names" vs PCs who have real names, can eliminate PCs by removing non-numbered names
    if (tonumber(Players[k].name) ~= nil) then 
        local i, j = 0, 0
        s = Players[k].fullname
        
        if (Players[k].spec ~= "unknown spec") then Battle.Spec(Players[k].spec) end
        

        -- Strip brackets, first for single words, second for double words (eg White Aura), likely a better way to do this
        s = string.gsub(s,"%((%a+)%)","")
        s = string.gsub(s,"%((%a+ %a+)%)","")
        -- Strip leading and trailing white space
        s = string.gsub(s, '^%s*(.-)%s*$', '%1')
        -- Find the start/end of the pattern: "is here, fighting"
        i, j = string.find(s,"is here, fighting")
        
        if IsClass({"Psionicist", "Mindbender"}) then Battle.DeceptCheck(s, Players[k].name) end
        if IsClass({"Mindbender"}) then Battle.PsyphonCheck(Players[k]) end
        if IsClass({"Sorcerer"}) then Battle.ImmoCheck(s, Players[k].name) end
        if StatTable.Race == "Dragon" then Battle.DevourCheck(s, Players[k].name) end
        if IsClass({"Monk", "Shadowfist"}) and StatTable.Level == 125 and not SafeArea() then TryAction("look " .. Players[k].name  .. " chakra", 60) end
      
        -- If Mob isn't fighting (ie didn't match the pattern above) then find would've set i to nil
        if (i ~= nil) then -- only adds mobs we're fighting  
        
          --print(string.gsub(s,"is here, fighting [^.]+%.?","")) -- stripes is here fighting
          
          
          -- Seperate into mob name and player names
          mob = string.lower(string.sub(s,1,(i-2)))
          player = GMCP_name(string.sub(s,(j+2),string.len(s)-1))
          if player == "You" then player = StatTable.CharName end

          if IsGroupMate(player) then
            if Battle.GroupiesUnderAttack[player] == nil then
              Battle.GroupiesUnderAttack[player] = 1
            else
              Battle.GroupiesUnderAttack[player] = Battle.GroupiesUnderAttack[player] + 1
            end
            Battle.EnemiesAttacking[Players[k].name] = {mob, player}
            mobcount = mobcount + 1
          end
        end
    end
  end
  Battle.MobCount = mobcount
  --if (mobcount>0) then
  --  TableShow(Battle.GroupiesUnderAttack)
 --   TableShow(Battle.EnemiesAttacking)
 --   print("Battle.MobCount = " .. Battle.MobCount)
 -- end
  
end

-- Weak Mobs used for Immo, also Devour
ImmoMobList = {
  "This Githyanki coughs, blood bubbling up through his open mouth.",
  "A dying Githzerai crawls, dragging his useless legs behind him.",
  "Unsure on his feet, this young Githzerai tries to stay out of the way.",
  "A small fiend crawls through the blood.",
  "A former Lord of Midgaardia serves the Fae.",
  "Red particles swirl together in a fierce cluster.",
  "A dark cloud of diminishing hate struggles to keep itself together.",
  "This demon is emaciated with elongated limbs.",
  "A mound of topaz starts to move listlessly.",
  "Back from the dead, this Githzerai stumbles to his feet.",
  "The shadows reveal a Githyanki hidden behind the outhouse.",
  
  "This youth from this hamlet is terrified of you... but honor-bound to attack.",
  "This young female Trog is startled at your presence!",
  "This Troglodyte youth looks like he's off for the day, just enjoying himself.",
  "A Kuzzivo Youth looks like he wants to run away from you!",
  
  -- Conundrum
  "A united ent and giant army is fighting to preserve Midgaardia!",
  "Jacklyn leads refugees from Hospice refugee camp elsewhere.",
  
  
  
}


function Battle.ImmoCheck(mobname, mobnum)
  if StatTable.Level < 125 and StatTable.SubLevel < 101 then return end
  if not ArrayHasValue(ImmoMobList, mobname) then return end
  if StatTable.Calm and not Battle.Combat then return end

  -- quicken logic ok? add combat logic?
  --bug in quicken
  local quicken_level = 0

  if StatTable.current_mana > (70000 * Battle.GetSpellCostMod("arcane")) then
    quicken_level = 9
  elseif StatTable.current_mana > (50000 * Battle.GetSpellCostMod("arcane")) then
    quicken_level = 5
  end
  
  if quicken_level > 0 then TryAction("quicken " .. quicken_level, 5) end
  
  if not StatTable.Immolation then
    TryCast("cast immolation " .. mobnum, 5)
  elseif not StatTable.AstralPrison and StatTable.Level == 125 then
    TryCast("cast 'astral prison' " .. mobnum, 5)
  else
    return
  end
  if quicken_level > 0 then TryAction("quicken off",5) end

end

function Battle.DevourCheck(mobname, mobnum)
  if not ArrayHasValue(ImmoMobList, mobname) then return end
  if StatTable.RacialDevourFatigue then return end
    
  TryAction("racial devour " .. mobnum, 5)

end




local DeceptArea = {
  "{ LORD } Pliny Nothing",
  
}

local DeceptList = {
  ["{ LORD } Ducer   Fire Realm"] = {
    "Impossibly large flames burn with a deadly rage.",
    "An elemental of white hot flame strides through the forge.",
    "Burning violently a being of elemental fury moves towards you.",
    "Flames flow violently in an attempt to consume you.",
    "Jets of flame explode suddenly engulfing everything here.",
    "Winds of fire try to destroy the man and anything else entering here.",
    "Burning violently a being of elemental fury moves towards you.", -- can be large or huge
    "Impossibly large flames burn with a deadly rage.",
    "A burst of fire whirls around on burning wings.",
    "A knight does his best to defend himself as he staggers through the fire.",
    "A knight does her best to defend himself as he staggers through the fire.",
    "A knight quests for the secret of the purifying flame.",
  },
  
  ["{ LORD } Mimir   Cinderheim"] = {
    "A self-confident warrior scans for signs of danger.",
    "Soaring overhead, an imp scans for signs of life.",
  
  },
  
  ["{ LORD } CC-Ctib Savage Jungle"] = {
    "This kzinti is a deadly predator, and you'll never see him coming.",
    "Native to this plane, a strange breed of lizard man stalks about.",
  
  
  },
  
  ["{ LORD } CC-Ctib Kzinti Spire of War"] = {
  
  
  },


  --earth elemental descriptions: TODO determine which are telepaths, territorial and huge
  ["{ LORD } Crowe   World of Stone "] = {
    "This large Earth Elemental looks enraged.",
    "This earth elemental takes great joy in dispatching intruders.",
    "This Earth Elemental is so huge you can only surmise that it is royalty.",
    "The Lord of the Earth Elementals has had quite enough of you.",
    "Rare minerals have given this elemental the gift of telepathy.",
    "An elemental soldier saunters about, looking for trouble.",
    "A surging wave of stone crashes down upon you!",
    "A crystalline serpent slithers through the shifting Earth.",
    "A massive mound of earth tries to catch the lord's eye.",
    "A burly Earth Elemental scours the plane for impurities.",
  },

  ["{ LORD } Dev     Obsidian Arena; Floor"] = {
    "A Dark Fae soldier stalks the arena floor.", 
    "A dark Fae army archer stands here in a battle-ready stance.",
    "A dark fae armed with a longbow rides a massive mastador.",
    "A fae wizard in military uniform stands amid the soldiers.",
    "A fae wizard in military uniform stands behind the Duke.",
    "A guard leaps to attack you!",
    "A tall, powerfully built Fae bears a regal demeanor.",
    "A wiry Fae sits here, meditating. A blindfold is tied around his head.", 
    "An especially tall and proud Dark Fae Soldier stands before you.", 
    "Clad in robes bedecked with the icon of the moon, a She-Fae attends the Duke.",
    "It should come as no surprise that the Dark Fae army employs assassins.",
    "Lurking in the corner is a uniformed Fae with a crossbow.",
    "This soldier's uniform is bedecked with snake iconography.",
    "a Dark Fae archer is in the middle of a scattershot attempt.",
    "a Dark Fae beastmaster is in the middle of a held shot attempt.",
    "a Dark Fae beastmaster is in the middle of a scattershot attempt.",
    "a viper troop is out cold.",
    },

}

function Battle.DeceptCheck(mobname, mobnum)
  if Battle.Combat then return end -- return if already in combat
  local zone = gmcp.Room.Info.zone
  if ArrayHasValue(DeceptArea, zone) or (DeceptList[zone] and ArrayHasValue(DeceptList[zone], mobname)) then
    cs = getCommandSeparator()
    TryAction("quicken 9" .. cs .. "cast deception " .. mobnum .. cs .. "cast deception " .. mobnum .. cs .. "quicken off", 15)
  end
end

local PsyphonList = {
  "spec_battle_cleric",
  "spec_battle_mage",
  "spec_battle_sor",
  "spec_cast_adept",
  "spec_cast_cleric",
  "spec_cast_judge",
  "spec_cast_kinetic",
  "spec_cast_mage",
  "spec_cast_psion",
  "spec_cast_stormlord",
  "spec_cast_undead",
  "spec_cast_wizard",
  "spec_druid",
  "spec_mindbender",
  "spec_priest",
  "spec_sorceror",
}


function Battle.PsyphonCheck(mob)
  if StatTable.PsyphonExhaust or
     not Battle.Combat or
     StatTable.Level < 50 or
     not ArrayHasValue(PsyphonList, mob.spec) then return end
  
  i, _ = string.find(s,"is here, fighting")
  if (i == nil) then return end -- we're not fighting this mob
  

  TryFunction("PsyphonCast", Battle.NextAct, {"quicken 9" .. cs .. "cast psyphon " .. mob.name .. cs .. "quicken off", 5}, 5)
  
end