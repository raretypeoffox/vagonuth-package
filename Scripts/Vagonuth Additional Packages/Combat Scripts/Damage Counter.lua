-- Script: Damage Counter
-- Attribute: isActive

-- Script Code:
DamageCounter = DamageCounter or {}
DamageCounter.Players = DamageCounter.Players or {}

function DamageCounter.PlayerExists(ch)
  assert(ch,"DamageCounter.PlayerExists(): ch is nil")
  ch = GMCP_name(ch)
  if (DamageCounter.Players[ch]==nil) then
    DamageCounter.Players[ch] = {}
    DamageCounter.Players[ch].dmg = 0
    DamageCounter.Players[ch].bashdmg = 0
    DamageCounter.Players[ch].bashrounds = 0
    DamageCounter.Players[ch].rounds = 0
    DamageCounter.Players[ch].highest = 0
    DamageCounter.Players[ch].terminal = 0
    DamageCounter.Players[ch].brandishes = 0    
    return false
  else
    return true
  end
end

function DamageCounter.AddDmg(ch, dmgdesc, bash)
  ch = GMCP_name(ch)
  bash = bash or false
  if ch == "Someone" then return end
  
  DamageCounter.PlayerExists(ch)
  
  if (dmgdesc == "terminal") then
    DamageCounter.Players[ch].terminal = tonumber(DamageCounter.Players[ch].terminal) + 1
    return
  end
  
  amt = tonumber(DamageCounter.dmgtonum(dmgdesc))
  
  if not (amt>=0) then return end
  assert(amt>=0, "Non-attack related line was picked up by trigger, ignoring.")
  
  -- Only count a round if we record damage (ie non-terminal) so that our avg dmg is calc'd correctly
  -- This solution may miss out on rounds that have no damage.
  DamageCounter.Players[ch].rounds = DamageCounter.Players[ch].rounds + 1
  
  
  DamageCounter.Players[ch].dmg = DamageCounter.Players[ch].dmg + amt
  if bash then 
    DamageCounter.Players[ch].bashdmg = DamageCounter.Players[ch].bashdmg + amt 
    DamageCounter.Players[ch].bashrounds = DamageCounter.Players[ch].bashrounds + 1
  end

  if (DamageCounter.Players[ch].highest < amt) then DamageCounter.Players[ch].highest = amt end
--print("Total Damage from " .. ch .. ": " .. DamageCounter.Players[ch].dmg .. " (Highest: " .. DamageCounter.Players[ch].highest .. ")")
  return
end

function DamageCounter.AddBrandish(ch)
  ch = GMCP_name(ch)
  if ch == "Someone" then return end
  
  DamageCounter.PlayerExists(ch)
  
  if not DamageCounter.Players[ch].brandishes then DamageCounter.Players[ch].brandishes = 0 end
  
  DamageCounter.Players[ch].brandishes = DamageCounter.Players[ch].brandishes + 1
end

function DamageCounter.Reset()
  DamageCounter.Players = {}
end

-- Helper: parse and build a rank filter function
local function make_filter(op, n)
  if not op then         -- default: top 6
    op, n = "<", 7
  elseif type(op) == "number" then
    op, n = "<", op  -- allow Report(5) to mean "< 5"
  end

  local valid = { ["<"]=1, ["<="]=1, ["=="]=1, ["="]=1,
                  [">"]=1, [">="]=1, ["~="]=1 }
  assert(valid[op], "Invalid op: use one of <,<=,==,~=,>,>=")

  return function(rank)
    if     op == "<"  then return rank <  n
    elseif op == "<=" then return rank <= n
    elseif op == ">"  then return rank >  n
    elseif op == ">=" then return rank >= n
    elseif op == "==" or op == "=" then return rank == n
    elseif op == "~=" then return rank ~= n
    end
  end
end

-- Helper: return a list of {damage, name} sorted descending
local function sorted_players()
  local t = {}
  for name, st in pairs(DamageCounter.Players) do
    table.insert(t, { st.dmg, name })
  end
  table.sort(t, rcompare)
  return t
end

-- Helper: return a list of {brandishes, name} sorted descending
local function sorted_brands()
  local t = {}
  for name, st in pairs(DamageCounter.Players) do
    if st.brandishes > 0 then
      table.insert(t, { st.brandishes, name })
    end
  end
  table.sort(t, rcompare)
  return t
end

-- Helper: format a line for send (with color codes)
local function format_send_line(rank, name, v)
  local avg = math.floor((v.dmg - v.bashdmg) / (v.rounds - v.bashrounds) + .05)
  local dmg = format_int(math.floor(v.dmg + .05))
  local msg = string.format(
    "%d. |BW|%s|N|: %s (avg: |BY|%s|N| / max: |BY|%s|N|)",
    rank,
    name,
    dmg,
    DamageCounter.numtodmg(avg),
    DamageCounter.numtodmg(v.highest)
  )
  return msg:gsub("=", "-")
end

-- Helper: format a line for echo (plain text with tabs)
local function format_echo_line(rank, name, v)
  local avg = math.floor((v.dmg - v.bashdmg) / (v.rounds - v.bashrounds) + .05)
  local dmg = format_int(math.floor(v.dmg + .05))
  -- adjust tabs based on name length and two-digit ranks
  local name_thresh = (rank >= 10) and 3 or 4
  local tab1 = (#name > name_thresh) and "\t" or "\t\t"
  local tab2 = (#dmg < 8)          and "\t\t" or "\t"
  return string.format(
    "%d. %s%s%s%s(avg: %s / highest: %s / terms: %d)",
    rank,
    name,
    tab1,
    dmg,
    tab2,
    DamageCounter.numtodmg(avg),
    DamageCounter.numtodmg(v.highest),
    v.terminal
  )
end

-- Helper: announce top brandishers via a callback
local function announce_brands(brands, announce_fn)
  if #brands == 0 then return end
  local msg = "Top Brandishers: "
  for i, e in ipairs(brands) do
    if i > 8 then break end
    msg = msg .. e[2] .. " (" .. e[1] .. "), "
  end
  msg = msg:sub(1, -3)
  announce_fn(msg)
end

-- Main gtell-based report
function DamageCounter.Report(op, n)
  local show = make_filter(op, n)
  for rank, entry in ipairs(sorted_players()) do
    local name = entry[2]
    local v    = DamageCounter.Players[name]
    if v.rounds >= 1 and show(rank) then
      send("gtell " .. format_send_line(rank, name, v), false)
    end
  end
  announce_brands(sorted_brands(), function(m) send("gtell "..m, false) end)
end

-- Echo (print) version
function DamageCounter.ReportEcho(op, n)
  print("Damage Report:")
  print("------------------")
  local show = make_filter(op, n)
  for rank, entry in ipairs(sorted_players()) do
    local name = entry[2]
    local v    = DamageCounter.Players[name]
    if v.rounds >= 1 and show(rank) then
      print(format_echo_line(rank, name, v))
    end
  end
  announce_brands(sorted_brands(), print)
end

function DamageCounter.dmgtonum(dmgdesc)
  if (dmgdesc == "nil") then return 0 end
  if (dmgdesc == "pathetic") then return 1.5 end
  if (dmgdesc == "weak") then return 3.5 end
  if (dmgdesc == "punishing") then return 7.5 end
  if (dmgdesc == "surprising") then return 9.5 end
  if (dmgdesc == "amazing") then return 12.5 end
  if (dmgdesc == "astonishing") then return 16.5 end
  if (dmgdesc == "mauling") then return 20.5 end
  if (dmgdesc == "MAULING") then return 24.5 end
  if (dmgdesc == "*MAULING*") then return 28.5 end
  if (dmgdesc == "**MAULING**") then return 32.5 end
  if (dmgdesc == "***MAULING***") then return 36.5 end
  if (dmgdesc == "decimating") then return 40.5 end
  if (dmgdesc == "DECIMATING") then return 44.5 end
  if (dmgdesc == "*DECIMATING*") then return 48 end
  if (dmgdesc == "**DECIMATING**") then return 52.5 end
  if (dmgdesc == "***DECIMATING***") then return 58 end
  if (dmgdesc == "devastating") then return 63 end
  if (dmgdesc == "DEVASTATING") then return 68 end
  if (dmgdesc == "*DEVASTATING*") then return 73 end
  if (dmgdesc == "**DEVASTATING**") then return 78 end
  if (dmgdesc == "***DEVASTATING***") then return 83 end
  if (dmgdesc == "pulverizing") then return 88 end
  if (dmgdesc == "PULVERIZING") then return 93 end
  if (dmgdesc == "*PULVERIZING*") then return 98 end
  if (dmgdesc == "**PULVERIZING**") then return 105.5 end
  if (dmgdesc == "***PULVERIZING***") then return 115.5 end
  if (dmgdesc == "maiming") then return 125.5 end
  if (dmgdesc == "MAIMING") then return 135.5 end
  if (dmgdesc == "*MAIMING*") then return 145.5 end
  if (dmgdesc == "**MAIMING**") then return 155.5 end
  if (dmgdesc == "***MAIMING***") then return 165.5 end
  if (dmgdesc == "eviscerating") then return 175.5 end
  if (dmgdesc == "EVISCERATING") then return 185.5 end
  if (dmgdesc == "*EVISCERATING*") then return 195.5 end
  if (dmgdesc == "**EVISCERATING**") then return 213 end
  if (dmgdesc == "***EVISCERATING***") then return 238 end
  if (dmgdesc == "mutilating") then return 263 end
  if (dmgdesc == "MUTILATING") then return 288 end
  if (dmgdesc == "*MUTILATING*") then return 313 end
  if (dmgdesc == "**MUTILATING**") then return 338 end
  if (dmgdesc == "***MUTILATING***") then return 363 end
  if (dmgdesc == "disemboweling") then return 388 end
  if (dmgdesc == "DISEMBOWELING") then return 413 end
  if (dmgdesc == "*DISEMBOWELING*") then return 438 end
  if (dmgdesc == "**DISEMBOWELING**") then return 463 end
  if (dmgdesc == "***DISEMBOWELING***") then return 488 end
  if (dmgdesc == "dismembering") then return 520.5 end
  if (dmgdesc == "DISMEMBERING") then return 562 end
  if (dmgdesc == "*DISMEMBERING*") then return 606 end
  if (dmgdesc == "**DISMEMBERING**") then return 675 end
  if (dmgdesc == "***DISMEMBERING***") then return 730 end
  if (dmgdesc == "massacring") then return 769 end
  if (dmgdesc == "MASSACRING") then return 810 end
  if (dmgdesc == "*MASSACRING*") then return 867 end
  if (dmgdesc == "**MASSACRING**") then return 907.5 end
  if (dmgdesc == "***MASSACRING***") then return 958 end
  if (dmgdesc == "mangling") then return 1050.5 end
  if (dmgdesc == "MANGLING") then return 1150.5 end
  if (dmgdesc == "*MANGLING*") then return 1250.5 end
  if (dmgdesc == "**MANGLING**") then return 1350.5 end
  if (dmgdesc == "***MANGLING***") then return 1450.5 end
  if (dmgdesc == "demolishing") then return 1550.5 end
  if (dmgdesc == "DEMOLISHING") then return 1650.5 end
  if (dmgdesc == "*DEMOLISHING*") then return 1750.5 end
  if (dmgdesc == "**DEMOLISHING**") then return 1850.5 end
  if (dmgdesc == "***DEMOLISHING***") then return 1950.5 end
  if (dmgdesc == "obliterating") then return 2100.5 end
  if (dmgdesc == "OBLITERATING") then return 2300.5 end
  if (dmgdesc == "*OBLITERATING*") then return 2500.5 end
  if (dmgdesc == "**OBLITERATING**") then return 2700.5 end
  if (dmgdesc == "***OBLITERATING***") then return 2900.5 end
  if (dmgdesc == "annihilating") then return 3100.5 end
  if (dmgdesc == "ANNIHILATING") then return 3300.5 end
  if (dmgdesc == "*ANNIHILATING*") then return 3500.5 end
  if (dmgdesc == "**ANNIHILATING**") then return 3700.5 end
  if (dmgdesc == "***ANNIHILATING***") then return 3950.5 end
  if (dmgdesc == ">***ANNIHILATING***<") then return 4300.5 end
  if (dmgdesc == ">>***ANNIHILATING***<<") then return 4754 end
  if (dmgdesc == ">>>***ANNIHILATING***<<<") then return 5704.5 end
  if (dmgdesc == ">>>>***ANNIHILATING***<<<<") then return 5902 end
  if (dmgdesc == "eradicating") then return 6200 end
  if (dmgdesc == "ERADICATING") then return 6500 end
  if (dmgdesc == "*ERADICATING*") then return 7000 end
  if (dmgdesc == "**ERADICATING**") then return 7500 end
  if (dmgdesc == "***ERADICATING***") then return 7800 end
  if (dmgdesc == ">***ERADICATING***<") then return 8200 end
  if (dmgdesc == ">>***ERADICATING***<<") then return 8500 end
  if (dmgdesc == ">>>***ERADICATING***<<<") then return 9000 end
  if (dmgdesc == ">>>>***ERADICATING***<<<<") then return 9500 end
  if (dmgdesc == "vaporizing") then return 10000 end
  if (dmgdesc == "VAPORIZING") then return 11000 end
  if (dmgdesc == "*VAPORIZING*") then return 12000 end
  if (dmgdesc == "**VAPORIZING**") then return 13000 end
  if (dmgdesc == "***VAPORIZING***") then return 14000 end
  if (dmgdesc == ">***VAPORIZING***<") then return 15000 end
  if (dmgdesc == ">>***VAPORIZING***<<") then return 16500 end
  if (dmgdesc == ">>>***VAPORIZING***<<<") then return 18000 end
  if (dmgdesc == ">>>>***VAPORIZING***<<<<") then return 19000 end
  if (dmgdesc == "destructive") then return 20000 end
  if (dmgdesc == "DESTRUCTIVE") then return 21000 end
  if (dmgdesc == "*DESTRUCTIVE*") then return 22000 end
  if (dmgdesc == "**DESTRUCTIVE**") then return 23000 end
  if (dmgdesc == "***DESTRUCTIVE***") then return 24000 end
  if (dmgdesc == "****DESTRUCTIVE****") then return 25000 end
  if (dmgdesc == ">****DESTRUCTIVE****<") then return 26000 end
  if (dmgdesc == ">>****DESTRUCTIVE****<<") then return 27000 end
  if (dmgdesc == ">>>****DESTRUCTIVE****<<<") then return 28000 end
  if (dmgdesc == ">>>>****DESTRUCTIVE****<<<<") then return 29000 end
  if (dmgdesc == "=>>>>***DESTRUCTIVE***<<<<=") then return 30000 end
  if (dmgdesc == "==>>>>**DESTRUCTIVE**<<<<==") then return 31000 end
  if (dmgdesc == "===>>>>*DESTRUCTIVE*<<<<===") then return 32000 end
  if (dmgdesc == "====>>>>DESTRUCTIVE<<<<====") then return 33000 end
  if (dmgdesc == "extreme") then return 34000 end
  if (dmgdesc == "EXTREME") then return 35000 end
  if (dmgdesc == "*EXTREME*") then return 36000 end
  if (dmgdesc == "**EXTREME**") then return 37000 end
  if (dmgdesc == "***EXTREME***") then return 38000 end
  if (dmgdesc == "****EXTREME****") then return 39000 end
  if (dmgdesc == ">****EXTREME****<") then return 40000 end
  if (dmgdesc == ">>****EXTREME****<<") then return 41000 end
  if (dmgdesc == ">>>****EXTREME****<<<") then return 42000 end
  if (dmgdesc == ">>>>****EXTREME****<<<<") then return 43000 end
  if (dmgdesc == "=>>>>***EXTREME***<<<<=") then return 44500 end
  if (dmgdesc == "==>>>>**EXTREME**<<<<==") then return 47000 end
  if (dmgdesc == "===>>>>*EXTREME*<<<<===") then return 48000 end
  if (dmgdesc == "====>>>>EXTREME<<<<====") then return 50000 end
  if (dmgdesc == "porcine") then return 51000 end
  if (dmgdesc == "PORCINE") then return 53000 end
  if (dmgdesc == "*PORCINE*") then return 55000 end
  if (dmgdesc == "**PORCINE**") then return 57000 end
  if (dmgdesc == "***PORCINE***") then return 59000 end
  if (dmgdesc == ">***PORCINE***<") then return 61000 end
  if (dmgdesc == ">>***PORCINE***<<") then return 65000 end
  if (dmgdesc == ">>>***PORCINE***<<<") then return 70000 end
  if (dmgdesc == ">>>>***PORCINE***<<<<") then return 75000 end
  if (dmgdesc == "Divine") then return 80000 end
  if (dmgdesc == "daunting") then return 100000 end
  return -1
end

function DamageCounter.numtodmg(dmgamt)
  assert(dmgamt>=0)
  assert(type(dmgamt)=="number")
  
  if (dmgamt == 0) then return "nil" 
  elseif (dmgamt <= 2) then return "pathetic" 
  elseif (dmgamt <= 4) then return "weak" 
  elseif (dmgamt <= 8) then return "punishing" 
  elseif (dmgamt <= 10) then return "surprising" 
  elseif (dmgamt <= 14) then return "amazing" 
  elseif (dmgamt <= 18) then return "astonishing" 
  elseif (dmgamt <= 22) then return "mauling" 
  elseif (dmgamt <= 26) then return "MAULING" 
  elseif (dmgamt <= 30) then return "*MAULING*" 
  elseif (dmgamt <= 34) then return "**MAULING**" 
  elseif (dmgamt <= 38) then return "***MAULING***" 
  elseif (dmgamt <= 42) then return "decimating" 
  elseif (dmgamt <= 46) then return "DECIMATING" 
  elseif (dmgamt <= 49) then return "*DECIMATING*" 
  elseif (dmgamt <= 55) then return "**DECIMATING**" 
  elseif (dmgamt <= 60) then return "***DECIMATING***" 
  elseif (dmgamt <= 65) then return "devastating" 
  elseif (dmgamt <= 70) then return "DEVASTATING" 
  elseif (dmgamt <= 75) then return "*DEVASTATING*" 
  elseif (dmgamt <= 80) then return "**DEVASTATING**" 
  elseif (dmgamt <= 85) then return "***DEVASTATING***" 
  elseif (dmgamt <= 90) then return "pulverizing" 
  elseif (dmgamt <= 95) then return "PULVERIZING" 
  elseif (dmgamt <= 100) then return "*PULVERIZING*" 
  elseif (dmgamt <= 110) then return "**PULVERIZING**" 
  elseif (dmgamt <= 120) then return "***PULVERIZING***" 
  elseif (dmgamt <= 130) then return "maiming" 
  elseif (dmgamt <= 140) then return "MAIMING" 
  elseif (dmgamt <= 150) then return "*MAIMING*" 
  elseif (dmgamt <= 160) then return "**MAIMING**" 
  elseif (dmgamt <= 170) then return "***MAIMING***" 
  elseif (dmgamt <= 180) then return "eviscerating" 
  elseif (dmgamt <= 190) then return "EVISCERATING" 
  elseif (dmgamt <= 200) then return "*EVISCERATING*" 
  elseif (dmgamt <= 225) then return "**EVISCERATING**" 
  elseif (dmgamt <= 250) then return "***EVISCERATING***" 
  elseif (dmgamt <= 275) then return "mutilating" 
  elseif (dmgamt <= 300) then return "MUTILATING" 
  elseif (dmgamt <= 325) then return "*MUTILATING*" 
  elseif (dmgamt <= 350) then return "**MUTILATING**" 
  elseif (dmgamt <= 375) then return "***MUTILATING***" 
  elseif (dmgamt <= 400) then return "disemboweling" 
  elseif (dmgamt <= 425) then return "DISEMBOWELING" 
  elseif (dmgamt <= 450) then return "*DISEMBOWELING*" 
  elseif (dmgamt <= 475) then return "**DISEMBOWELING**" 
  elseif (dmgamt <= 500) then return "***DISEMBOWELING***" 
  elseif (dmgamt <= 540) then return "dismembering" 
  elseif (dmgamt <= 574) then return "DISMEMBERING" 
  elseif (dmgamt <= 606) then return "*DISMEMBERING*" 
  elseif (dmgamt <= 675) then return "**DISMEMBERING**" 
  elseif (dmgamt <= 730) then return "***DISMEMBERING***" 
  elseif (dmgamt <= 769) then return "massacring" 
  elseif (dmgamt <= 810) then return "MASSACRING" 
  elseif (dmgamt <= 884) then return "*MASSACRING*" 
  elseif (dmgamt <= 915) then return "**MASSACRING**" 
  elseif (dmgamt <= 1000) then return "***MASSACRING***" 
  elseif (dmgamt <= 1100) then return "mangling" 
  elseif (dmgamt <= 1200) then return "MANGLING" 
  elseif (dmgamt <= 1300) then return "*MANGLING*" 
  elseif (dmgamt <= 1400) then return "**MANGLING**" 
  elseif (dmgamt <= 1500) then return "***MANGLING***" 
  elseif (dmgamt <= 1600) then return "demolishing" 
  elseif (dmgamt <= 1700) then return "DEMOLISHING" 
  elseif (dmgamt <= 1800) then return "*DEMOLISHING*" 
  elseif (dmgamt <= 1900) then return "**DEMOLISHING**" 
  elseif (dmgamt <= 2000) then return "***DEMOLISHING***" 
  elseif (dmgamt <= 2200) then return "obliterating" 
  elseif (dmgamt <= 2400) then return "OBLITERATING" 
  elseif (dmgamt <= 2600) then return "*OBLITERATING*" 
  elseif (dmgamt <= 2800) then return "**OBLITERATING**" 
  elseif (dmgamt <= 3000) then return "***OBLITERATING***" 
  elseif (dmgamt <= 3200) then return "annihilating" 
  elseif (dmgamt <= 3400) then return "ANNIHILATING" 
  elseif (dmgamt <= 3600) then return "*ANNIHILATING*" 
  elseif (dmgamt <= 3800) then return "**ANNIHILATING**" 
  elseif (dmgamt <= 4100) then return "***ANNIHILATING***" 
  elseif (dmgamt <= 4500) then return ">***ANNIHILATING***<" 
  elseif (dmgamt <= 5007) then return ">>***ANNIHILATING***<<" 
  elseif (dmgamt <= 5901) then return ">>>***ANNIHILATING***<<<" 
  elseif (dmgamt <= 5902) then return ">>>>***ANNIHILATING***<<<<" 
  elseif (dmgamt <= 6200) then return "eradicating" 
  elseif (dmgamt <= 6500) then return "ERADICATING" 
  elseif (dmgamt <= 7000) then return "*ERADICATING*" 
  elseif (dmgamt <= 7500) then return "**ERADICATING**" 
  elseif (dmgamt <= 7800) then return "***ERADICATING***" 
  elseif (dmgamt <= 8200) then return ">***ERADICATING***<" 
  elseif (dmgamt <= 8500) then return ">>***ERADICATING***<<" 
  elseif (dmgamt <= 9000) then return ">>>***ERADICATING***<<<" 
  elseif (dmgamt <= 9500) then return ">>>>***ERADICATING***<<<<" 
  elseif (dmgamt <= 10000) then return "vaporizing" 
  elseif (dmgamt <= 11000) then return "VAPORIZING" 
  elseif (dmgamt <= 12000) then return "*VAPORIZING*" 
  elseif (dmgamt <= 13000) then return "**VAPORIZING**" 
  elseif (dmgamt <= 14000) then return "***VAPORIZING***" 
  elseif (dmgamt <= 15000) then return ">***VAPORIZING***<" 
  elseif (dmgamt <= 16500) then return ">>***VAPORIZING***<<" 
  elseif (dmgamt <= 18000) then return ">>>***VAPORIZING***<<<" 
  elseif (dmgamt <= 19000) then return ">>>>***VAPORIZING***<<<<" 
  elseif (dmgamt <= 20000) then return "destructive" 
  elseif (dmgamt <= 21000) then return "DESTRUCTIVE" 
  elseif (dmgamt <= 22000) then return "*DESTRUCTIVE*" 
  elseif (dmgamt <= 23000) then return "**DESTRUCTIVE**" 
  elseif (dmgamt <= 24000) then return "***DESTRUCTIVE***" 
  elseif (dmgamt <= 25000) then return "****DESTRUCTIVE****" 
  elseif (dmgamt <= 26000) then return ">****DESTRUCTIVE****<" 
  elseif (dmgamt <= 27000) then return ">>****DESTRUCTIVE****<<" 
  elseif (dmgamt <= 28000) then return ">>>****DESTRUCTIVE****<<<" 
  elseif (dmgamt <= 29000) then return ">>>>****DESTRUCTIVE****<<<<" 
  elseif (dmgamt <= 30000) then return "=>>>>***DESTRUCTIVE***<<<<=" 
  elseif (dmgamt <= 31000) then return "<=>>>>**DESTRUCTIVE**<<<<<=" 
  elseif (dmgamt <= 32000) then return "<==>>>>*DESTRUCTIVE*<<<<<==" 
  elseif (dmgamt <= 33000) then return "<=<=>>>>DESTRUCTIVE<<<<<=<=" 
  elseif (dmgamt <= 34000) then return "extreme" 
  elseif (dmgamt <= 35000) then return "EXTREME" 
  elseif (dmgamt <= 36000) then return "*EXTREME*" 
  elseif (dmgamt <= 37000) then return "**EXTREME**" 
  elseif (dmgamt <= 38000) then return "***EXTREME***" 
  elseif (dmgamt <= 39000) then return "****EXTREME****" 
  elseif (dmgamt <= 40000) then return ">****EXTREME****<" 
  elseif (dmgamt <= 41000) then return ">>****EXTREME****<<" 
  elseif (dmgamt <= 42000) then return ">>>****EXTREME****<<<" 
  elseif (dmgamt <= 43000) then return ">>>>****EXTREME****<<<<" 
  elseif (dmgamt <= 44500) then return "=>>>>***EXTREME***<<<<=" 
  elseif (dmgamt <= 47000) then return "<=>>>>**EXTREME**<<<<<=" 
  elseif (dmgamt <= 48000) then return "<==>>>>*EXTREME*<<<<<==" 
  elseif (dmgamt <= 50000) then return "<=<=>>>>EXTREME<<<<<=<=" 
  elseif (dmgamt <= 51000) then return "porcine" 
  elseif (dmgamt <= 53000) then return "PORCINE" 
  elseif (dmgamt <= 55000) then return "*PORCINE*" 
  elseif (dmgamt <= 57000) then return "**PORCINE**" 
  elseif (dmgamt <= 59000) then return "***PORCINE***" 
  elseif (dmgamt <= 61000) then return ">***PORCINE***<" 
  elseif (dmgamt <= 65000) then return ">>***PORCINE***<<" 
  elseif (dmgamt <= 70000) then return ">>>***PORCINE***<<<" 
  elseif (dmgamt <= 75000) then return ">>>>***PORCINE***<<<<" 
  elseif (dmgamt <= 80000) then return "Divine" 
  elseif (dmgamt <= 100000) then return "daunting" 
  else return "BIG NUMBER!!" end
end
