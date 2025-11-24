-- Script: Battle.OnLook
-- Attribute: isActive
-- Battle.OnLook() called on the following events:
-- gmcp.Room.Players
-- gmcp.Room.AddPlayer
-- gmcp.Room.RemovePlayer

-- Script Code:
Battle = Battle or {}
Battle.GroupiesUnderAttack = Battle.GroupiesUnderAttack or {}
Battle.EnemiesAttacking   = Battle.EnemiesAttacking   or {}
Battle.EnemiesChakra      = Battle.EnemiesChakra      or {}
Battle.MobCount           = Battle.MobCount           or 0
Battle.Stomper            = Battle.Stomper            or false

-- =============== Utilities ===============
local function Trim(str) return (str:gsub("^%s*(.-)%s*$", "%1")) end
local function StripParens(str) return (str:gsub("%b()", "")) end -- remove all (...) chunks
local function IsNumberedMob(name) return tonumber(name) ~= nil end
local function CommandSep() return getCommandSeparator and getCommandSeparator() or ";" end
local function Try(cmd, timeout) return TryAction and TryAction(cmd, timeout or 5) end
local function TryNext(tag, fn, args, timeout) return TryFunction and TryFunction(tag, fn, args, timeout or 5) end

-- Convert array -> set (exact-case)
local function MakeSet(t)
  local s = {}
  for _,v in ipairs(t) do s[v] = true end
  return s
end

-- =============== Data (exact-case) ===============
local ImmoMobList = {
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
  "A mole meekly makes its way through the shifting earth.",

  "This youth from this hamlet is terrified of you... but honor-bound to attack.",
  "This young female Trog is startled at your presence!",
  "This Troglodyte youth looks like he's off for the day, just enjoying himself.",
  "A Kuzzivo Youth looks like he wants to run away from you!",

  -- Conundrum
  "A united ent and giant army is fighting to preserve Midgaardia!",
  "Jacklyn leads refugees from Hospice refugee camp elsewhere.",
}
local ImmoMobSet = MakeSet(ImmoMobList)

local DeceptArea = {
  -- "{ LORD } Pliny Nothing",
}
local DeceptAreaSet = MakeSet(DeceptArea)

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

  ["{ LORD } CC-Ctib Kzinti Spire of War"] = {},

  ["{ LORD } Crowe   World of Stone"] = {
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

  ["{ LORD } Pliny Nothing"] = {
    "A cultist drifting to nowhere in particular is here.",
    "A cultist enjoying the relaxing void is here.",
    "A cultist enjoying the soothing void is here.",
    "A cultist with a shiny gem embedded in her forehead is here.",
    "A new devotee, believing firmly in the tranquility of nothing is here.",
    "A nihilistic cultist drifts in vast expanse of nothing.",
    "A nihilistic cultist sits entranced, staring into a gap in the void.",
    "A senior cultist floats here, a gemstone embedded in his forehead.",
    "A well-versed cultist spreading her Mantra is here.",
    "A young devotee seeks out the next convert while weaving through the void.",
    "Full of rage and discontent, the elder cultist is here.",
    "The nihilistic cultist is soothed by the expanse of nothingness."
  },
}

-- convert DeceptList zone arrays -> sets (exact-case)
for zone, arr in pairs(DeceptList) do
  DeceptList[zone] = MakeSet(arr)
end

local function ZoneNeedsDecept(zone, desc)
  if not zone or not desc then return false end
  if DeceptAreaSet[zone] then return true end
  local zset = DeceptList[zone]
  return zset and zset[desc] == true
end

local CasterSpecSet = MakeSet({
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
})

-- =============== Parsing ===============
-- Always returns a description suitable for matching your lists.
-- If fighting, it returns the description with "is here, fighting <X>." removed.
local function ParseCombatLine(fullname)
  local s = Trim(StripParens(fullname or ""))

  local i = s:find("is here, fighting", 1, true)
  if i then
    -- Keep exact-case description by removing the fighting tail.
    local desc = Trim((s:gsub("is here, fighting [^.]+%.?", "")))
    local target = s:match("is here, fighting (.+)%.?%s*$")
    return {
      isFighting   = true,
      mobDesc      = desc,
      targetPlayer = (GMCP_name and target) and GMCP_name(target) or target
    }
  else
    return {
      isFighting   = false,
      mobDesc      = s,
      targetPlayer = nil
    }
  end
end

local function BuildMobContext(p)
  if not (p and IsNumberedMob(p.name)) then return nil end

  local parsed = ParseCombatLine(p.fullname or "")
  local player = parsed.targetPlayer
  if player == "You" then player = StatTable.CharName end

  return {
    mob         = p,                -- raw gmcp mob object
    mobNum      = p.name,           -- convenient alias
    spec        = p.spec,
    isMob       = true,             -- numbered -> mob
    mobDesc     = parsed.mobDesc,   -- exact-case, parentheses removed
    isFighting  = parsed.isFighting,
    target      = player,
  }
end

-- =============== Predicates ===============
function Battle.IsCaster(mobOrSpec)
  local spec = (type(mobOrSpec) == "table") and mobOrSpec.spec or mobOrSpec
  return spec and CasterSpecSet[spec] == true or false
end
local function IsImmoMob(desc) return desc and ImmoMobSet[desc] == true end

-- =============== Spec dispatcher (exact behavior kept) ===============
local SpecHandlers = {}

SpecHandlers["spec_breath_fire"] = function()
  if StatTable.Race == "Ignatur" then
    if not StatTable.RacialInnervate and not StatTable.RacialInnervateFatigue then
      Try("racial innervate", 30)
    end
  end
end

SpecHandlers["spec_breath_lightning"] = function()
  if StatTable.Race == "Golem" then
    if not StatTable.RacialGalvanize and not StatTable.RacialGalvanizeFatigue then
      Try("racial galvanize", 30)
    end
  end
end

SpecHandlers["spec_stomp_em"] = function()
  if Grouped and Grouped() and not (GlobalVar and GlobalVar.Silent) then
    Try("emote warns the party about |BR|STOMPERS|N| in the room!", 30)
  end
  if StatTable.Class == "Psionicist" then
    Battle.Stomper = true
  end
end

function Battle.Spec(spec)
  assert(spec, "Battle.Spec() error: spec not provided")
  Battle.Stomper = false
  local handler = SpecHandlers[spec]
  if handler then handler() end
end

-- =============== Checks (ctx-based) ===============
-- replace your current DeceptCheck with this internally-gated version
local function DeceptCheck(ctx)
  if not (IsClass and IsClass({"Psionicist", "Mindbender", "Black Circle Initiate"})) then
    return
  end

  if GlobalVar and GlobalVar.AutoTarget then return end
  if Battle.Combat then return end
  if not (ctx and ctx.isMob and ctx.mobDesc) then return end

  local zone = gmcp and gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.zone
  if ZoneNeedsDecept(zone, ctx.mobDesc) then
    local cs = getCommandSeparator and getCommandSeparator() or ";"
    TryAction("quicken 9" .. cs ..
              "cast deception " .. ctx.mobNum .. cs ..
              "cast deception " .. ctx.mobNum .. cs ..
              "quicken off", 15)
  end
end


local function PsyphonCheck(ctx)
  if not (IsClass and IsClass({"Mindbender"})) then return end
  if StatTable.PsyphonExhaust or not Battle.Combat or (StatTable.Level or 0) < 50 then return end
  if not (ctx and ctx.isMob and ctx.isFighting) then return end
  if not Battle.IsCaster(ctx.mob) then return end

  local cs = CommandSep()
  TryNext("PsyphonCast", Battle.NextAct, { "quicken 9" .. cs .. "cast psyphon " .. ctx.mob.name .. cs .. "quicken off", 5 }, 5)
end

local function ScrambleCheck(ctx)
  if (StatTable.Race ~= "Illithid") then return end
  if StatTable.RacialScrambleFatigue or not Battle.Combat then return end
  if not (ctx and ctx.isMob and ctx.isFighting) then return end
  if not Battle.IsCaster(ctx.mob) then return end

  TryNext("ScrambleAct", Battle.NextAct, { "racial scramble " .. ctx.mob.name, 5 }, 5)
end

local function ImmoCheck(ctx)
  if not (IsClass and IsClass({"Sorcerer"})) then return end
  if not ctx or not ctx.isMob then return end
  if (StatTable.Level or 0) < 125 and (StatTable.SubLevel or 0) < 101 then return end
  if StatTable.Immolation and StatTable.AstralPrison then return end
  if StatTable.Calm and not Battle.Combat then return end
  if not IsImmoMob(ctx.mobDesc) then return end

  local cmd
  if not StatTable.Immolation then
    cmd = "cast immolation " .. ctx.mobNum
  elseif not StatTable.AstralPrison and StatTable.Level == 125 then
    cmd = "cast 'astral prison' " .. ctx.mobNum
  end
  if not cmd then return end

  local mod  = (Battle.GetSpellCostMod and Battle.GetSpellCostMod("arcane")) or 1
  local mana = StatTable.current_mana or 0
  local cs   = CommandSep()

  if mana > (70000 * mod) then
    cmd = "quicken 9" .. cs .. cmd .. cs .. "quicken off"
  elseif mana > (50000 * mod) then
    cmd = "quicken 5" .. cs .. cmd .. cs .. "quicken off"
  end

  Try(cmd, 5)
end

private_DevourCheck = private_DevourCheck or nil
local function DevourCheck(ctx)
  if StatTable.Race ~= "Dragon" then return end
  if not ctx or not ctx.isMob then return end
  if StatTable.RacialDevourFatigue then return end
  if not IsImmoMob(ctx.mobDesc) then return end

  Try("racial devour " .. ctx.mobNum, 5)
end

local function ChakraPeek(ctx)
  if not (IsClass and IsClass({"Monk", "Shadowfist"})) then return end
  if (StatTable.Level or 0) ~= 125 then return end
  if SafeArea and SafeArea() then return end
  if not (ctx and ctx.isMob and ctx.isFighting) then return end

  Try("look " .. ctx.mobNum .. " chakra", 60)
end

-- =============== Orchestrator ===============
function Battle.OnLook()
  local Players = (gmcp and gmcp.Room and gmcp.Room.Players) or {}
  local mobcount = 0

  Battle.GroupiesUnderAttack = {}
  Battle.EnemiesAttacking   = {}
  Battle.EnemiesChakra      = {}

  for _, p in pairs(Players) do
    local ctx = BuildMobContext(p)
    if ctx then
      -- react to known spec if provided
      if p.spec and p.spec ~= "unknown spec" then
        Battle.Spec(p.spec)
      end

      DeceptCheck(ctx)
      PsyphonCheck(ctx)     
      ScrambleCheck(ctx)    
      ImmoCheck(ctx)        
      DevourCheck(ctx)      
      ChakraPeek(ctx)       

      -- bookkeeping if mob is fighting a groupmate
      if ctx.isFighting and ctx.target and IsGroupMate and IsGroupMate(ctx.target) then
        Battle.GroupiesUnderAttack[ctx.target] = (Battle.GroupiesUnderAttack[ctx.target] or 0) + 1
        Battle.EnemiesAttacking[p.name] = { ctx.mobDesc or "(unknown)", ctx.target }
        mobcount = mobcount + 1
      end
    end
  end

  Battle.MobCount = mobcount
end
