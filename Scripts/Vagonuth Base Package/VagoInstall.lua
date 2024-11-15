-- Script: VagoInstall
-- Attribute: isActive

-- Script Code:

VagoPackage = VagoPackage or {}
VagoPackage.Version = "v1.1.0"
VagoPackage.OnlinePath = "https://github.com/raretypeoffox/vagonuth-package/releases/latest/download/"
VagoPackage.OnlineVersionFile = "https://raw.githubusercontent.com/raretypeoffox/vagonuth-package/main/versions.lua"
VagoPackage.ProfileName = getProfileName():lower()
VagoPackage.DownloadPath = getMudletHomeDir().."/vagonuth-package/"
VagoPackage.Downloading = false

function VagoPackage:DownloadVersionFile()
    if not io.exists(VagoPackage.DownloadPath) then lfs.mkdir(VagoPackage.DownloadPath) end
    local filename = "versions.lua"
    VagoPackage.Downloading=true
    downloadFile(VagoPackage.DownloadPath .. filename, VagoPackage.OnlineVersionFile)
end

function VagoPackage:CheckVersion()
    local path = VagoPackage.DownloadPath .. "versions.lua"
    local versions = {}
    table.load(path, versions)
    local pos = table.index_of(versions, VagoPackage.Version) or 0
    local line = ""
    if pos ~= #versions then
        if GlobalVar and GlobalVar.DownloadMessage == pos then
          return
        else
          cecho("<white>Newer version of Vagonuth AVATAR Package available\n")
          cecho("<white>Type the command <yellow>download <white>to update\n")
          GlobalVar.DownloadMessage = pos
        end
      end
end

function VagoPackage:UpdateVersion()
    if VagoPackage.downloadFileHandler then
        killAnonymousEventHandler(VagoPackage.downloadFileHandler)
    end
    if table.contains(getPackages(),"Vagonuth-Package") then
        uninstallPackage("Vagonuth-Package")
      end
    installPackage(VagoPackage.OnlinePath .. "Vagonuth-Package.mpackage")
end

function VagoPackage:onFileDownloaded(event, ...)
    if event == "sysDownloadDone" and VagoPackage.Downloading then
        local file = arg[1]
        if string.ends(file,"/versions.lua") then
            VagoPackage.Downloading=false
            VagoPackage:CheckVersion()
        end
    end
end

VagoPackage.downloadFileHandler = VagoPackage.downloadFileHandler or nil

if VagoPackage.downloadFileHandler then
    killAnonymousEventHandler(VagoPackage.downloadFileHandler)
end

VagoPackage.downloadFileHandler = registerAnonymousEventHandler("sysDownloadDone","VagoPackage:onFileDownloaded")

tempTimer(2, [[VagoPackage.DownloadVersionFile()]])



