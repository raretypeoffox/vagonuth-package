-- Script: CPC_Main_Script
-- Attribute: isActive

-- Script Code:
cpc = cpc or {}
-- 0.0.0 is localbuild version, will get replaced by github actions when tagging
cpc.version = "v0.3.4"
cpc.onlinePath = "https://github.com/takilara/cpc/releases/latest/download/"
cpc.onlineVersionFile = "https://raw.githubusercontent.com/takilara/cpc/main/versions.lua"
cpc.debug = cpc.debug or false
cpc.localEcho = cpc.localEcho or true
cpc.thisProfileName = getProfileName():lower()
cpc.downloadPath = getMudletHomeDir().."/cpc downloads/"
cpc.downloading = false
cpc.loadedAs = "unknown"



function cpc:log(text)
  if cpc.debug==true then
    debugc("CPC:"..text)
  end
end

function cpc:syntax(text)
  cecho("<orange>"..text)
end

function cpc:echo(text)
  if cpc.localEcho==true then
    cecho("<cyan>"..text)
    print()
  end
end

function cpc:showVersion()
  local vline = cpc:checkVersion()
  cecho(string.format("<cyan>%-50s: %s %s\n","Cross Profile Communication",cpc.version,vline))
end



function cpc:showHelp()
  cecho("<cyan>Cross Profile Communication:\n")
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#HELP"),"Show Helpfile(s)"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#VERSION"),"Show version(s)"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#CPC UPDATE"),"Upgrade the package"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#ALL <arguments>"),"Send command to all profiles"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#DO <arguments>"),"Send command to all other profiles"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format("   %s","#DO party report"),"Ex: tell all other profiles to execute 'party report'"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#BID <profile> <arguments>"),"Send command to one character (immediate execution)"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format("   %s","#BID gandalf say hello"),"Ex: tell Gandalf to execute 'say hello'"))
  
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#ECHO <text>"),"Show something in all terminals"))
  cecho(string.format("<cyan>%-30s- %s\n",string.format(" %s","#TELL <profile>"),"Show something in one particular terminal"))
  cecho("<cyan>---------------------------------------------------------------------------------------\n")
  print()
end

function cpc:handleCommand(cmd,args)
  
  cpc:log("CPC: Handle command")
  cpc:log("cmd:'"..cmd.."'")
  cpc:log("args:'"..args.."'")
  cmd = string.lower(cmd)
  
  if (cmd=="help") then
    cpc:showHelp()
  elseif (cmd=="version") then
    cpc:showVersion()
  elseif (cmd=="all") then
    if args ~= "" then
      -- Send event to all profiles, including self
      raiseGlobalEvent("cpc_all",args)
      raiseEvent("cpc_all",args)
    else
      cpc:syntax("#ALL must be called with an argument, e.g. '#ALL say hi'")
    end
  elseif (cmd=="do") then
    -- Only send event to other profiles, otherwise same as #ALL
    if args ~= "" then
      raiseGlobalEvent("cpc_all",args)
    else
      cpc:syntax("#DO must be called with an argument, e.g. '#DO say hi''")
    end
  elseif (cmd=="echo") then
    if args ~= "" then
      -- Send event to all profiles, including self
      raiseGlobalEvent("cpc_echo",args)
      raiseEvent("cpc_echo",args)
    else
      cpc:syntax("#ECHO must be called with an argument, e.g. '#ECHO Under attack!'")
    end  
  elseif (cmd=="tell") then
    if args ~= "" then
      -- Send event to all profiles, including self
      raiseGlobalEvent("cpc_tell",args)
      raiseEvent("cpc_tell",args)
    else
      cpc:syntax("#TELL must be called with arguments, e.g. '#TELL Gandalf Help me!'")
    end  
  elseif (cmd=="bid") then
    raiseGlobalEvent("cpc_bid",args)
    raiseEvent("cpc_bid",args)
  elseif (cmd=="cpc") and (args:lower()=="update") then
    cpc:downloadLatestVersion()
  else
    cecho("<orange>Command '".. string.upper(cmd) .. " ".. string.upper(args) .. "' not supported!\n")
  end
end

function cpc:onCmdAll(event,arg,profile)
  cpc:log("onCmdAll()")
  --cpc:log("Event: " .. event)
  cpc:log("Arg  : " .. arg)
  -- If the event is not raised with raiseGlobalEvent() profile will be 'nil'
  --echo("Profile: " .. (profile or "Local") .. "\n")
  
  cpc:echo((profile or "Local") .. " asked everyone to '" .. arg.."'")
  expandAlias(arg) 
end

function cpc:onBidEvent(event,arg,profile)
  local words = {}
  words[1], words[2] = arg:match("(%w+)(.+)")
  local targetProfile = words[1]:lower()
  local cmd = words[2]
  -- strip leading and trailing whitespace
  cmd = string.gsub(cmd, '^%s*(.-)%s*$', '%1')
  
  --cpc:log("Tell " .. words[1] .. " to execute '" .. cmd.."'")
  cpc:log("Tell <" .. targetProfile .. "> to execute '" .. cmd.."'")
  
  if profile == nil then
    profile = "Local"
  end
  if cpc.thisProfileName == targetProfile then
    cpc:echo("<cyan>" .. profile .. " bad me execute '" .. cmd .. "'")
    expandAlias(cmd)
  end
end

function cpc:onEchoEvent(event,args,profile)
  --print("echo")
  cecho("<cyan>"..args)
  print()
end

function cpc:onFileDownloaded(event, ...)
  --print("onFileDownloaded")
  if event == "sysDownloadDone" and cpc.downloading then
    --print("check what type of file")
    local file = arg[1]
    --display(file)
    --display(arg)
    if string.ends(file,"/versions.lua") then
      --print("Versions file downloaded from github")
      cpc.downloading=false
      cpc:checkVersion()
    elseif string.ends(file,"/cpc.xml") then
      --print("DEPRECATED: New version of CPC downloaded...")
      cpc.downloading=false
      --cpc:update_version()
    elseif string.ends(file,"/cpc.mpackage") then
      --print("New version of CPC downloaded...")
      cpc.downloading=false
      cpc:update_version()
    end
    
  end
end

function cpc:onModuleOrPackageLoaded(event,...)
  --print("module loaded")
  --print("check if module or package")
  --display(event)
  --display(arg)
  if (event=="sysInstallPackage") and (arg[1]=="Cross Profile Communication") then
    cpc.loadedAs="package"
  elseif (event=="sysInstallModule") and (arg[1]=="cpc") then
    cpc.loadedAs="module"
  end
  
end

function cpc:onTellEvent(event,arg,profile)
 local words = {}
  words[1], words[2] = arg:match("(%w+)(.+)")
  local targetProfile = words[1]:lower()
  local text = words[2]
  -- strip leading and trailing whitespace
  text = string.gsub(text, '^%s*(.-)%s*$', '%1')
  
  --cpc:log("Tell " .. words[1] .. " to execute '" .. cmd.."'")
  cpc:log("Tell <" .. targetProfile .. "> to echo '" .. text.."'")
  
  if profile == nil then
    profile = "Local"
  end
  if cpc.thisProfileName == targetProfile then
    cecho("<cyan>" .. text)
    print()
  end
end

function cpc:downloadVersionFile()
  --print("Download the versions file")
  if not io.exists(cpc.downloadPath) then lfs.mkdir(cpc.downloadPath) end
  local filename = "versions.lua"
  cpc.downloading=true
  downloadFile(cpc.downloadPath .. filename, cpc.onlineVersionFile)
end

function cpc:checkVersion()
  local path = cpc.downloadPath .. "versions.lua"
  local versions = {}
  
  table.load(path, versions)
  --display(versions)
  local pos = table.index_of(versions, cpc.version) or 0
  local line = ""
  if pos ~= #versions then
    --print(string.format("CPC is currently <red>%d<reset> versions behind.",#versions - pos))
    --print("To update now, please type: <yellow>#CPC update<reset>")
    line = "<orange>(".. #versions - pos .. " behind online - ".. versions[#versions] ..")\n \t #CPC UPDATE to upgrade"
  else
    line =""
  end
  return line
end

function cpc:downloadLatestVersion()
  print("download new version of cpc")
  if not io.exists(cpc.downloadPath) then lfs.mkdir(cpc.downloadPath) end
  local filename = "cpc.mpackage"
  cpc.downloading=true
  downloadFile(cpc.downloadPath .. filename, cpc.onlinePath .. filename)
end

function cpc:update_version()
  print("Update the version")
  --local path = profilePath .. "/map downloads/generic_mapper.xml"
  --uninstallPackage("cpc")   -- remove local instance (module)
  --uninstallModule("cpc") -- remove local instance (module)
  cpc:killAllExistingEventHandlers()
  
  uninstallPackage("Cross Profile Communication")
  
  installPackage(cpc.downloadPath .. "cpc.mpackage")
  --installModule
end

function cpc:killAllExistingEventHandlers()
  if cpc.allEventHandler~=nil then
    killAnonymousEventHandler(cpc.allEventHandler)
  end
  if cpc.bidEventHandler~=nil then
    killAnonymousEventHandler(cpc.bidEventHandler)
  end
  if cpc.echoEventHandler~=nil then
    killAnonymousEventHandler(cpc.echoEventHandler)
  end
  if cpc.tellEventHandler~=nil then
    killAnonymousEventHandler(cpc.tellEventHandler)
  end
  if cpc.downloadFileHandler~=nil then
    killAnonymousEventHandler(cpc.downloadFileHandler)
  end
  if cpc.cpcPackageLoadedHandler~=nil then
    killAnonymousEventHandler(cpc.cpcPackageLoadedHandler)
  end
  if cpc.cpcModuleLoadedHandler~=nil then
    killAnonymousEventHandler(cpc.cpcModuleLoadedHandler)
  end
end


-- CPC Event handlers
cpc.allEventHandler = cpc.allEventHandler or nil
cpc.bidEventHandler = cpc.bidEventHandler or nil
cpc.echoEventHandler = cpc.echoEventHandler or nil
cpc.tellEventHandler = cpc.tellEventHandler or nil
cpc.downloadFileHandler = cpc.downloadFileHandler or nil
cpc.cpcPackageLoadedHandler = cpc.cpcPackageLoadedHandler or nil
cpc.cpcModuleLoadedHandler = cpc.cpcModuleLoadedHandler or nil

cpc:killAllExistingEventHandlers()
-- remove existing event handlers before creating new ones




-- setup event handlers
cpc.allEventHandler = registerAnonymousEventHandler("cpc_all","cpc:onCmdAll")
cpc.bidEventHandler = registerAnonymousEventHandler("cpc_bid","cpc:onBidEvent")
cpc.echoEventHandler = registerAnonymousEventHandler("cpc_echo","cpc:onEchoEvent")
cpc.tellEventHandler = registerAnonymousEventHandler("cpc_tell","cpc:onTellEvent")
cpc.downloadFileHandler = registerAnonymousEventHandler("sysDownloadDone","cpc:onFileDownloaded")
cpc.cpcModuleLoadedHandler = registerAnonymousEventHandler("sysInstallModule","cpc:onModuleOrPackageLoaded")
cpc.cpcPackageLoadedHandler = registerAnonymousEventHandler("sysInstallPackage","cpc:onModuleOrPackageLoaded")

cpc:downloadVersionFile()