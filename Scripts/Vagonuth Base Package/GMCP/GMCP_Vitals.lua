-- Script: GMCP_Vitals
-- Attribute: isActive
-- GMCP_Vitals() called on the following events:
-- gmcp.Char.Vitals
-- gmcp.Char.Status

-- Script Code:
-------------------------------------------------
--         GMCP Update for Status and Vitals   --
-------------------------------------------------

-- AffectsLookup Table
-- Adding new affects to StatTable, e.g, StatTable.Sanctuary, is as easy as adding another entry to AffectsLookup
-- e.g., ["Spell: sanctuary"] = "Sanctuary",
-- you can find the correct spell name by typing "lua gmcp.Char.Status.affects" in game

StatTable = StatTable or {}
StatTable.BladetranceLevel = StatTable.BladetranceLevel or 0

local AffectDurationDescriptions = {
  ["seems to be wavering"] = "Wavering",
  ["for a tiny amount of time"] = "Tiny Time",
  ["for a small amount of time"] = "Small Time",
  ["for a while"] = "A While",
  ["for a long time"] = "Long Time",
  ["for a very long time"] = "Very Long",
  ["for seemingly forever"] = "Forever",
}

local AffectDurationRank = {
  ["Wavering"] = 1,
  ["Tiny Time"] = 2,
  ["Small Time"] = 3,
  ["A While"] = 4,
  ["Long Time"] = 5,
  ["Very Long"] = 6,
  ["Forever"] = 7,
  ["continuous"] = 8,
}

local AffectsLookup = {
  ["Spell: sneak"] = "Sneak",
  ["Spell: shadow form"] = "Sneak",
  ["Spell: move hidden"] = "MoveHidden",
  ["Spell: invis"] = "Invis",
  ["Spell: improved invis"] = "Invis",
  ["Spell: mass invis"] = "Invis",
  ["Spell: detect invis"] = "DetectInvis",
  ["Spell: infravision"] = "Infravision",
  ["Spell: detect evil"] = "DetectEvil",
  ["Spell: detect hidden"] = "DetectHidden",
  ["Spell: detect magic"] = "DetectMagic",
  ["Spell: water breathing"] = "WaterBreathing",
  ["Spell: fly"] = "Fly",
  ["Spell: sanctuary"] = "Sanctuary",
  ["Spell: iron monk"] = "Sanctuary",
  ["Spell: fortitudes"] = "Fortitude",
  ["Spell: foci"] = "Foci",
  ["Spell: invincibility"] = "Invincibility",
  ["Spell: barkskin"] = "Barkskin",
  ["Spell: steel skeleton"] = "SteelSkeleton",
  ["Spell: iron skin"] = "IronSkin",
  ["Spell: frenzy"] = "Frenzy",
  ["Spell: awen"] = "Awen",
  ["Spell: aegis"] = "Awen",
  ["Spell: holy aura"] = "HolyAura",
  ["Spell: concentrate"] = "Concentrate",
  ["Spell: werrebocler"] = "Werrebocler",
  ["Spell: endurance"] = "Endurance",
  ["Spell: acumen"] = "Acumen",
  ["Spell: savvy"] = "Savvy",
  ["Spell: mystical barrier"] = "Mystical",
  ["Spell: alertness"] = "Alertness",
  ["Spell: intervention"] = "Intervention",
  ["Spell: blind devotion"] = "BlindDevotion",
  ["Spell: consummation"] = "Consummation",
  ["Spell: solitude"] = "Solitude",
  ["Spell: protection good"] = "ProtectionGood",
  ["Spell: protection evil"] = "ProtectionEvil",
  ["Spell: detect haven"] = "DetectHaven",
  
  ["Exhausted Spell: solitude"] = "SolitudeTimer",
  ["Exhausted Spell: intervention"] = "InterventionExhaust",
  
  -- sld
  ["Exhausted Spell: square"] = "SquareExhaust",
  ["Exhausted Spell: echelon"] = "EchelonExhaust",
  ["Exhausted Spell: phalanx"] = "PhalanxExhaust",
  ["Exhausted Spell: column"] = "ColumnExhaust",
  ["Spell: square"] = "StanceSquare",
  ["Spell: echelon"] = "StanceEchelon",
  ["Spell: phalanx"] = "StancePhalanx",
  ["Spell: column"] = "StanceColumn",
  
  -- mag
  ["Spell: attenuation"] = "Attenuation",
  ["Spell: attenuation aura"] = "AttenuationAura", 
  ["Spell: planar modulation"] = "PlanarModulation",
  ["Spell: planar modulation aura"] = "PlanarModulationAura", 
  ["Spell: arcana harvesting"] = "ArcanaHarvesting",
  ["Spell: arcana harvesting aura"] = "ArcanaHarvestingAura",
  ["Spell: antimagic feedback"] = "AntimagicFeedback",
  ["Spell: antimagic feedback aura"] = "AntimagicFeedbackAura",  
  ["Spell: brittle"] = "Brittle",
  ["Spell: brittle aura"] = "BrittleAura",
  ["Spell: sympathetic resonance"] = "SympatheticResonance",
  ["Spell: sympathetic resonance aura"] = "SympatheticResonanceAura", 
  
  -- wzd  
  ["Spell: ether link"] = "EtherLink",
  ["Spell: ether warp"] = "EtherWarp",
  --["Spell: ether crash"] = "EtherCrash",
  ["Exhausted Spell: ether link"] = "EtherLinkExhaust",
  ["Exhausted Spell: ether warp"] = "EtherWarpExhaust",
  --["Exhausted Spell: ether crash"] = "EtherCrashExhaust",
  
  -- stm
  ["Spell: spring rain"] = "SpringRain",
  ["Spell: blizzard"] = "Blizzard",
  ["Spell: gale stratum"] = "GaleStratum",
  
  -- exhausts
  ["Exhausted Spell: water breathing"] = "WaterBreathingExhaust",
  ["Exhausted Spell: giant strength"] = "GiantStrengthExhaust",
  ["Exhausted Spell: fireball"] = "FireballExhaust",
  ["Exhausted Spell: chill touch"] = "ChillTouchExhaust",
  ["Exhausted Spell: acid blast"] = "AcidBlastExhaust",
  ["Exhausted Spell: burning hands"] = "BurningHandsExhaust",
  ["Exhausted Spell: lightning bolt"] = "LightningBoltExhaust",
  ["Exhausted Spell: cure light"] = "CureLightExhaust",
  ["Exhausted Spell: cure serious"] = "CureSeriousExhaust",
  ["Exhausted Spell: cure critical"] = "CureCriticalExhaust",
  
  -- bci
  ["Spell: nightcloak"] = "Nightcloak",
  ["Spell: sense weakness"] = "SenseWeakness",
  ["Exhausted Spell: sense weakness"] = "SenseWeaknessExhaust",
  ["Spell: kahbyss insight"] = "KahbyssInsight",
  ["Exhausted Spell: kahbyss insight"] = "KahbyssInsightExhaust",
  ["Exhausted Spell: quickcast"] = "QuickcastExhaust",
  
  -- bladedancer
  ["Spell: bladedance"] = "BladedanceTimer",
  ["Spell: dervish dance"] = "DervishTimer",  
  ["Spell: inspiring dance"] = "InspireTimer",
  ["Spell: unending dance"] = "UnendTimer",
  ["Spell: veil of blades"] = "VeilTimer",
  ["Spell: bladetrance"] = "Bladetrance",
  ["Exhausted Spell: bladetrance"] = "BladetranceExhaust",
  ["Exhausted Spell: bladedance"] = "BladedanceExhaust",
  ["Exhausted Spell: dervish dance"] = "DervishExhaust",
  ["Exhausted Spell: inspiring dance"] = "InspireExhaust",
  ["Exhausted Spell: unending dance"] = "UnendExhaust",
  ["Exhausted Spell: veil of blades"] = "VeilExhaust",
  ["Spell: iron veil"] = "IronVeil",
  ["Spell: furious rampage"] = "Rampage",
  ["Spell: thousand cuts"] = "ThousandCuts",
  
  -- cleric
  ["Spell: artificer blessing"] = "ArtificerBlessing",
  ["Spell: artificer blessing aura"] = "ArtificerBlessingAura", 
  ["Spell: discordia"] = "Discordia",
  ["Spell: discordia aura"] = "DiscordiaAura",
  ["Spell: divine adjutant"] = "DivineAdjutant",
  ["Spell: divine adjutant aura"] = "DivineAdjutantAura",
  ["Spell: divine grace"] = "DivineGrace",
  ["Spell: glorious conquest"] = "GloriousConquest",
  ["Spell: grim harvest"] = "GrimHarvest",
  ["Spell: grim harvest aura"] = "GrimHarvestAura",
  ["Spell: hallowed nimbus"] = "HallowedNimbus",
  ["Spell: hallowed nimbus aura"] = "HallowedNimbusAura",
  ["Spell: protective vigil"] = "ProtectiveVigil",
  ["Spell: aura protection"] = "ProtectiveVigilAura",
  ["Spell: sylvan benediction"] = "SylvanBenediction",
  ["Spell: sylvan benediction aura"] = "SylvanBenedictionAura",
  ["Spell: unholy rampage"] = "UnholyRampage",  
  ["Spell: rampage aura"] = "UnholyRampageAura", -- check name, rampage aura?
  
  -- Druid
  ["Spell: sidereal reflections"] = "SiderealReflections",
    
  ["Spell: saving grace"] = "SavingGrace",
  ["Spell: death shroud"] = "DeathShroud",
  ["Spell: defiled flesh"]= "DefiledFlesh",
  ["Spell: vile philosophy"] = "VilePhilosophy",
  ["Spell: summon necrit"] = "SummonNecrit",
  ["Spell: immolation"] = "Immolation",
  ["Spell: astral prison"] = "AstralPrison",
  ["Exhausted Spell: tainted genius"] = "TaintedExhaust",
  ["Exhausted Spell: unholy bargain"] = "UnholyBargainExhaust",
  ["Exhausted Spell: brimstone"] = "BrimstoneExhaust",
  ["Exhausted Spell: emotive drain"] = "EmotiveDrainExhaust",
  
  ["Spell: regeneration"]  = "Regeneration",
  ["Spell: protective stance"] = "StanceProtective",
  ["Exhausted Spell: protective stance"] = "StanceProtectiveExhaust",
  ["Spell: surefoot stance"] = "StanceSurefoot",
  ["Exhausted Spell: surefoot stance"] = "StanceSurefootExhaust",  
  ["Spell: relentless stance"] = "StanceRelentless",
  ["Exhausted Spell: relentless stance"] = "StanceRelentlessExhaust",
  ["Exhausted Spell: soul stance"] = "StanceSoulExhaust",
  ["Spell: rally"] = "Rally",
  ["Spell: tear"] = "Tear",
  ["Exhausted Spell: tear"] = "TearExhaust",

  
  -- pal
  ["Spell: fervor"] = "Fervor",
  ["Spell: prayer"] = "Prayer",
  ["Spell: holy zeal"] = "HolyZeal",
  ["Spell: joined boon"] = "JoinedBoon",
  ["Spell: heroic boon"] = "HeroicBoon",
  ["Spell: shared boon"] = "SharedBoon",
  ["Spell: valorous boon"] = "ValorousBoon",
  ["Spell: final boon"] = "FinalBoon",
  -- todo add other pal auras
  ["Spell: malice aura"] = "MaliceAura",
  
  -- Bod
  ["Spell: payback"] = "Payback",
  
  -- monk / shf
  ["Spell: bear stance"] = "BearStance",
  ["Spell: emu stance"] = "EmuStance",
  ["Spell: tiger stance"] = "TigerStance",
  ["Exhausted Spell: bear stance"] = "BearStanceExhaust",
  ["Exhausted Spell: emu stance"] = "EmuStanceExhaust",
  ["Exhausted Spell: tiger stance"] = "TigerStanceExhaust",
  ["Exhausted Spell: vampire fang"] = "VampireFangExhaust",
  ["Exhausted Spell: spectral fang"] = "SpectralFangExhaust",
  ["Spell: vampire fang"] = "VampireFang",
  ["Spell: spectral fang"] = "SpectralFang",
  ["Spell: dagger hand"] = "DaggerHand",
  ["Spell: stone fist"] = "StoneFist",
  ["Spell: flow like water"] = "FlowLikeWater",
  ["Exhausted Spell: flow like water"] = "FlowLikeWaterExhaust",
  ["Spell: burning fury"] = "BurningFury",
  ["Exhausted Spell: burning fury"] = "BurningFuryExhaust",

  
  
  
  -- Psi's / Mnd's
  ["Spell: kinetic chain"] = "KineticChain",
  ["Exhausted Spell: kinetic chain"] = "KineticChainExhaust",
  ["Spell: gravitas"] = "Gravitas",
  ["Exhausted Spell: gravitas"] = "GravitasExhaust",
  ["Spell: fury of the mind"] = "FuryOfTheMind",
  ["Spell: minds eye"] = "MindsEye",
  ["Spell: orbit"] = "Orbit",
  ["Spell: empathic resonance"] = "EmpathicResonance",
  ["Spell: hive mind"] = "HiveMind",
  ["Exhausted Spell: psyphon"] = "PsyphonExhaust",
  ["Spell: stunning weapon"] = "StunningWeapon",
  ["Spell: distracting weapon"] = "DistractingWeapon",
  ["Spell: disabling weapon"] = "DisablingWeapon",
  ["Spell: restricting weapon"] = "RestrictingWeapon",
  ["Spell: felling weapon"] = "FellingWeapon",
  ["Spell: conscious weapon"] = "ConsciousWeapon",
  ["Spell: intelligent weapon"] = "IntelligentWeapon",
  ["Exhausted Spell: stunning weapon"] = "StunningWeaponExhaust",
  ["Exhausted Spell: distracting weapon"] = "DistractingWeaponExhaust",
  ["Exhausted Spell: disabling weapon"] = "DisablingWeaponExhaust",
  ["Exhausted Spell: restricting weapon"] = "RestrictingWeaponExhaust",
  ["Exhausted Spell: felling weapon"] = "FellingWeaponExhaust",
  ["Exhausted Spell: conscious weapon"] = "ConsciousWeaponExhaust",
  ["Exhausted Spell: intelligent weapon"] = "IntelligentWeaponExhaust",

  
  -- fyr
  ["Spell: wildmind"] = "Wildmind",
  ["Spell: daring fury"] = "DaringFury",
  ["Spell: destructive fury"] = "DestructiveFury",
  ["Spell: explosive fury"] = "ExplosiveFury",
  ["Spell: focused fury"] = "FocusedFury",
  ["Spell: maniacal fury"] = "ManiacalFury",
  ["Spell: psychotic fury"] = "PsychoticFury",
  ["Spell: scathing fury"] = "ScathingFury",
  ["Spell: vengeful fury"] = "VengefulFury",
  
  
  
  
  -- migraine exhausts
  ["Exhausted Spell: water breathing"] = "WaterBreathingExhaust",
  ["Exhausted Spell: giant strength"] = "GiantStrengthExhaust",
  ["Exhausted Spell: fly"] = "FlyExhaust",
  ["Exhausted Spell: cure light"] = "CureLightExhaust",
  
  -- racials
  ["Spell: racial revival"] = "RacialRevival",
  ["Racial revival fatigue"] = "RacialRevivalFatigue",
  ["Spell: racial fire aura"] = "RacialFireaura",
  ["Racial fireaura fatigue"] = "RacialFireauraFatigue",
  ["Racial innervate fatigue"] = "RacialInnervateFatigue",
  ["Spell: racial galvanize"] = "RacialGalvanize",
  ["Racial galvanize fatigue"] = "RacialGalvanizeFatigue",
  ["Spell: racial frenzy"] = "RacialFrenzy",
  ["Racial frenzy fatigue"] = "RacialFrenzyFatigue",
  ["Racial expunge fatigue"] = "RacialExpungeFatigue",
  ["Racial breath fatigue"] = "RacialBreathFatigue",
  ["Racial roar fatigue"] = "RacialRoarFatigue",
  ["Spell: racial devour"] = "RacialDevour",
  ["Racial devour fatigue"] = "RacialDevourFatigue",
  ["Spell: racial heraldry"] = "RacialHeraldry",
  ["Racial heraldry fatigue"] = "RacialHeraldryFatigue",
  ["Racial scramble fatigue"] = "RacialScrambleFatigue",
  ["Spell: mind flay"] = "RacialMindFlay",
  ["Spell: mental aptitude"] = "RacialMentalAptitude",
  ["Racial convoke fatigue"] = "RacialConvokeFatigue",
  ["Racial planeshift fatigue"] = "RacialPlaneshiftFatigue",
  ["Spell: racial discorporate"] = "RacialDiscorporate",
  ["Exhausted Spell: racial discorporate"] = "RacialDiscorporateFatigue",
  ["Spell: racial gallop"] = "RacialGallop",
  ["Racial gallop fatigue"] = "RacialGallopFatigue",

  

  
  
    --bkd
  ["Spell: racial prowl"] = "RacialProwl",
  ["Racial prowl fatigue"] = "RacialProwlFatigue",
  ["Racial terror fatigue"] = "RacialTerrorFatigue",
  
  --bud
  ["Racial waterblast fatigue"] = "RacialWaterblastFatigue",
  ["Racial engulf fatigue"] = "RacialEngulfFatigue",
  
  --grd
  ["Spell: racial secrete"] = "RacialSecrete",
  ["Racial secrete fatigue"] = "RacialSecreteFatigue",
  ["Spell: racial constrict"] = "RacialConstrict",
  ["Racial constrict fatigue"] = "RacialConstrictFatigue",
  ["Racial miasma fatigue"] = "RacialMiasmaFatigue",
  
  --whd
  ["Spell: racial icemirror"] = "RacialIcemirror",
  ["Racial icemirror fatigue"] = "RacialIcemirrorFatigue",
  ["Spell: racial frigid"] = "RacialFrigid",
  ["Racial frigid fatigue"] = "RacialFrigidFatigue",
  
  -- check racial corpse eating?
  
  -- misc
  ["Spell: dark embrace"] = "DarkEmbrace",
  ["Spell: commune"] = "Commune",

  
  
  
  -- debuffs
  ["Spell: calm"] = "Calm",
  ["Spell: awe"] = "Calm",
  ["Spell: fear"] = "Fear",
  ["Spell: poison"] = "Poison",
  ["Spell: curse"] = "Curse",
  ["Spell: demonfire"] = "Demonfire",
  ["Spell: virus"] = "Virus",
  ["Spell: biotoxin"] = "Biotoxin",
  ["Spell: venom"] = "Venom",
  ["Spell: toxin"] = "Toxin",
  ["Spell: doom toxin"] = "DoomToxin",
  ["Spell: flash"] = "Flash",
  ["Spell: weaken"] = "Weaken",
  ["Spell: blindness"] = "Blindness",
  ["Spell: overconfidence"] = "Overconfidence",
  ["Spell: scramble"] = "Scramble",
  ["Spell: panic"] = "Panic",
  ["Spell: heartbane"] = "Heartbane",
  ["Spell: unrest"] = "Unrest",
  ["Spell: faerie fire"] = "FaerieFire",
  ["Spell: plague"] = "Plague",
  ["Spell: shun"] = "Shun",
  
  ["Spell: hand of god"] = "HandOfGod",
  
}

function GMCP_Vitals()    
    StatTable.CharName = GMCP_name(gmcp.Char.Status.character_name)
    StatTable.Race, StatTable.Class = gmcp.Char.Status.race, gmcp.Char.Status.class
    StatTable.Level, StatTable.SubLevel = tonumber(gmcp.Char.Status.level), tonumber(gmcp.Char.Status.sublevel)
    StatTable.HitRoll, StatTable.DamRoll = tonumber(gmcp.Char.Status.hitroll) or 0, tonumber(gmcp.Char.Status.damroll) or 0
    StatTable.ArmorClass = tonumber(gmcp.Char.Status.ac) or 0
    StatTable.Items, StatTable.MaxItems = tonumber(gmcp.Char.Vitals.items) or 1, tonumber(string.sub(gmcp.Char.Vitals.string, -3)) or 1
    StatTable.Weight, StatTable.MaxWeight = tonumber(gmcp.Char.Vitals.wgt), tonumber(gmcp.Char.Vitals.maxwgt)
    StatTable.Alignment = tonumber(gmcp.Char.Status.alignment) or 0
    StatTable.Position = gmcp.Char.Vitals.position
    StatTable.Quicken = tonumber(gmcp.Char.Vitals.quicken) or 0
    StatTable.Augment = tonumber(gmcp.Char.Vitals.augment) or 0
    StatTable.Surge = tonumber(gmcp.Char.Vitals.surge) or 0
     
    StatTable.current_health, StatTable.max_health = tonumber(gmcp.Char.Vitals.hp), tonumber(gmcp.Char.Vitals.maxhp)
    StatTable.current_mana = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 1 or tonumber(gmcp.Char.Vitals.mp)
    StatTable.max_mana = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 1 or tonumber(gmcp.Char.Vitals.maxmp)
    StatTable.current_moves, StatTable.max_moves = tonumber(gmcp.Char.Vitals.mv), tonumber(gmcp.Char.Vitals.maxmv)
    StatTable.current_tnl,StatTable.max_tnl = tonumber(gmcp.Char.Vitals.tnl), tonumber(gmcp.Char.Vitals.maxtnl)
    StatTable.current_mon,StatTable.max_mon = 0, 0
    StatTable.current_mon,StatTable.max_mon = tonumber(gmcp.Char.Vitals.monhp), tonumber(gmcp.Char.Vitals.maxmonhp)
    
    StatTable.Enemy = gmcp.Char.Status.opponent_name
    StatTable.EnemyHP, StatTable.EnemyMaxHP = tonumber(gmcp.Char.Status.opponent_health), tonumber(gmcp.Char.Status.opponent_health_max)
    
    StatTable.InnerQi = tonumber(gmcp.Char.Vitals.innerqi) or 0
    StatTable.OuterQi = tonumber(gmcp.Char.Vitals.outerqi) or 0
     
    for _, affect in pairs(AffectsLookup) do
      StatTable[affect] = nil
    end
    
    -- Affects that cannot be looked up with GetDuration(v) should be listed seperately below
    StatTable.Tainted = nil
    StatTable.Oath = nil
    StatTable.Renown = nil
    StatTable.EtherCrash = nil
    StatTable.EtherCrashDuration = nil
    StatTable.EtherCrashExhaust = nil
    StatTable.RacialInnervate = nil
    StatTable.RacialInnervateRegen = nil
    
    -- Iterate over gmcp.Char.Status.affects and set StatTable variables using the lookup table
    if StatTable.Level >= 25 and not (gmcp.Char.Status.affects == "" or gmcp.Char.Status.affects == nil) then  
        for k,v in pairs(gmcp.Char.Status.affects) do
        
            -- Check if the affect name exists in the lookup table
            local fieldName = AffectsLookup[k]
            
            
            -- MAKE SURE TO ADD THE BELOW TO THE ABOVE AS WELL TO ENSURE THEY ARE CLEARED
            if fieldName then
                StatTable[fieldName] = GetDuration(v)
            elseif(k == "Spell: tainted genius") then StatTable.Tainted = 1
            elseif(k == "Spell: oath") then StatTable.Oath = splitstring(v, " ")[2]
            elseif(k == "Spell: renown") then StatTable.Renown = splitstring(v, " ")[2]
            elseif(k == "Spell: ether crash") then
              -- In the affects time, Ether Crash is set to 1 if it's turned on and 2 if its been exhausted
              StatTable.EtherCrash = tonumber(string.match(v, 'by%s*(%d+)'))
              if StatTable.EtherCrash == 1 then
                StatTable.EtherCrashDuration = GetDuration(v)
              else
                StatTable.EtherCrashExhaust = GetDuration(v)
              end
            elseif(k == "Exhausted Spell: ether crash") then
              if not StatTable.EtherCrashExhaust then StatTable.EtherCrashExhaust = GetDuration(v) end
            elseif(k == "Spell: racial innervate") then
                StatTable.RacialInnervate = tonumber(string.match(v, '(%d[,.%d]*)%s*hours'))
                StatTable.RacialInnervateRegen = tonumber(string.match(v, '%d[%d.,]*'))
            end
        end
    end

    -- Holy sight includes these five spells.
    StatTable.HolySight = GetLowestAffectDuration({
      StatTable.DetectInvis,
      StatTable.Infravision,
      StatTable.DetectEvil,
      StatTable.DetectHidden,
      StatTable.DetectMagic,
      n = 5,
    })

    if(GlobalVar.GUI) then UpdateGUI() end 

end
    
function GetDuration(affect)
    if affect == nil then return nil end
    if type(affect) == "number" then return affect end

    local text = tostring(affect):lower()
    text = text:gsub("^%s+", ""):gsub("%s+$", "")

    if text == "continuous" or text == "continous" then return "continuous" end

    local description = AffectDurationDescriptions[text]
    if description then return description end

    if text:find("for an unknown time", 1, true) then return 1 end

    local hours = text:match("for%s+([%d,]+)%s+hours?") or text:match("([%d,]+)%s+hours?")
    if hours then
      local cleanHours = hours:gsub(",", "")
      return tonumber(cleanHours)
    end

    return nil
end

function GetLowestAffectDuration(affects)
    if not affects then return nil end

    local lowestNumber = nil
    local lowestDescription = nil
    local lowestDescriptionRank = nil

    local affectCount = affects.n or #affects

    for i = 1, affectCount do
      local affect = affects[i]
      if not affect then return nil end

      local duration = tonumber(affect)
      if duration then
        if not lowestNumber or duration < lowestNumber then
          lowestNumber = duration
        end
      else
        local rank = AffectDurationRank[affect]
        if rank and (not lowestDescriptionRank or rank < lowestDescriptionRank) then
          lowestDescription = affect
          lowestDescriptionRank = rank
        end
      end
    end

    return lowestNumber or lowestDescription or "continuous"
end
