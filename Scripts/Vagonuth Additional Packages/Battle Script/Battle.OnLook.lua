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
Battle.MobCount = Battle.MobCount or 0

function Battle.OnLook()
  local Players = gmcp.Room.Players
  local mobcount = 0
  
  Battle.GroupiesUnderAttack = {}
  Battle.EnemiesAttacking = {}
  
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
        
        if StatTable.Class == "Psionicist" or StatTable.Class == "Mindbender" then Battle.DeceptCheck(s, Players[k].name) end
        
        -- If Mob isn't fighting (ie didn't match the pattern above) then find would've set i to nil
        if (i ~= nil) then -- only adds mobs we're fighting
   
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

local DeceptList = {
-- fire elemental description: TODO determine which ones refer to Large and Huge Elementals
"Impossibly large flames burn with a deadly rage.",
"An elemental of white hot flame strides through the forge.",
"Burning violently a being of elemental fury moves towards you.",
"Flames flow violently in an attempt to consume you.",
"Jets of flame explode suddenly engulfing everything here.",
"Winds of fire try to destroy the man and anything else entering here.",

--earth elemental descriptions: TODO determine which are telepaths, territorial and huge
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
"Large Fire Elemental",
"Huge Fire Elemental",

}

function Battle.DeceptCheck(mobname, mobnum)
  if Battle.Combat then return end

  if ArrayHasValue(DeceptList, mobname) then
    TryAction("cast deception " .. mobnum, 15)
  end
end

