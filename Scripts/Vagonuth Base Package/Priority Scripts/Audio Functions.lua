-- Load this after "Safe Mudlet Functions" in Mudlet's script tree.

VagoAudio = VagoAudio or {}

VagoAudio.Cues = {
  beep = { mudletFile = "beep.wav", windowsFile = "beep_native.wav" },
  quickbeep = { mudletFile = "quickbeep.wav", windowsFile = "quickbeep_native.wav" },
  victory = { mudletFile = "victorybeep.mp3", windowsFile = "victorybeep_native.wav", volume = 75 },
  tingle = { mudletFile = "tingle.mp3", windowsFile = "tingle_native.wav", volume = 75 },
}

VagoAudio.Warned = VagoAudio.Warned or false

function VagoAudio:MediaPath()
  return getMudletHomeDir() .. "/Vagonuth-Package/"
end

function VagoAudio:WarnOnce(message)
  if self.Warned then return end
  self.Warned = true

  if type(printGameMessage) == "function" then
    printGameMessage("Audio fallback", message, "yellow", "white")
  else
    print("Audio fallback: " .. message)
  end
end

function VagoAudio:PlayWithMudlet(cueName)
  local cue = self.Cues[cueName]
  if not cue then return false end

  local settings = { name = self:MediaPath() .. cue.mudletFile }
  if cue.volume then settings.volume = cue.volume end
  return playSoundFile(settings)
end

function VagoAudio:FileExists(path)
  if io and type(io.exists) == "function" then return io.exists(path) end
  if lfs and type(lfs.attributes) == "function" then return lfs.attributes(path) ~= nil end
  return false
end

function VagoAudio:PlayWithWindows(cueName)
  local cue = self.Cues[cueName]
  if not cue then return false end

  local soundPath = self:MediaPath() .. cue.windowsFile
  if not self:FileExists(soundPath) then
    self:WarnOnce(cue.windowsFile .. " is missing; using Mudlet audio instead.")
    return false
  end

  local command = "& { param($path) (New-Object System.Media.SoundPlayer($path)).PlaySync() }"
  local fallbackPlayed = false
  local ok, player = pcall(
    spawn,
    function(output)
      if not fallbackPlayed and tostring(output or ""):match("%S") then
        fallbackPlayed = true
        VagoAudio:WarnOnce("Windows could not play " .. cueName .. "; using Mudlet audio instead.")
        if not (GlobalVar and GlobalVar.Silent) then VagoAudio:PlayWithMudlet(cueName) end
      end
    end,
    "powershell.exe",
    "-NoLogo",
    "-NoProfile",
    "-NonInteractive",
    "-ExecutionPolicy", "Bypass",
    "-WindowStyle", "Hidden",
    "-Command", command,
    soundPath
  )

  if ok and player then return true end
  self:WarnOnce("Windows PowerShell could not be started; using Mudlet audio instead.")
  return false
end

function VagoAudio:Play(cueName)
  if GlobalVar and GlobalVar.Silent then return false end
  if not self.Cues[cueName] then return false end

  if GlobalVar and GlobalVar.AudioBackend == "windows" and getOS() == "windows" then
    if self:PlayWithWindows(cueName) then return true end
  end

  return self:PlayWithMudlet(cueName)
end

function VagoAudio:SetBackend(backend)
  if backend ~= "mudlet" and backend ~= "windows" then
    return false, "Audio backend must be 'mudlet' or 'windows'."
  end
  if backend == "windows" and getOS() ~= "windows" then
    return false, "The Windows audio backend is only available on Windows."
  end

  GlobalVar.AudioBackend = backend
  self.Warned = false
  if type(SaveProfileVars) == "function" then SaveProfileVars() end
  return true, "Audio backend set to " .. backend .. "."
end

function VagoAudio:Status()
  local backend = GlobalVar and GlobalVar.AudioBackend or "mudlet"
  if backend == "windows" then
    return "Audio backend: windows"
  end
  return "Audio backend: mudlet"
end

function VagoAudio:Test()
  if GlobalVar and GlobalVar.Silent then
    print("Audio test skipped because silent mode is on.")
    return false
  end

  print("Testing quick beep, beep, victory, and tingle. The complete test takes about 12 seconds.")
  self:Play("quickbeep")
  safeTempTimer("VagoAudioTestBeep", 0.75, function() VagoAudio:Play("beep") end, false)
  safeTempTimer("VagoAudioTestVictory", 2, function() VagoAudio:Play("victory") end, false)
  safeTempTimer("VagoAudioTestTingle", 7, function() VagoAudio:Play("tingle") end, false)
  return true
end

function beep()
  return VagoAudio:Play("beep")
end

function QuickBeep()
  return VagoAudio:Play("quickbeep")
end

function QuickBeepVerbose()
  if not GlobalVar.Verbose then return end
  QuickBeep()
end

function VictoryBeep()
  return VagoAudio:Play("victory")
end

function TingleBeep()
  return VagoAudio:Play("tingle")
end
