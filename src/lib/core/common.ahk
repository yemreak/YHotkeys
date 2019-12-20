; ####################################################################################
; ##                                                                                ##
; ##                                 GENEL İŞLEMLER                                 ##
; ##                                                                                ##
; ####################################################################################

RunUrl(url) {
    ; WARN: Bazı uygulamarın geç açılması soruna sebep oluyor
    ; BUG: Uygulamalar bazen 2 kere açılıyor
    try {
        SetTitleMatchMode, Slow

        RunWait, %url%
    }
}

GetEnvPath(envvar, path=""){
    EnvGet, prepath, %envvar%
    path = %prepath%%path%
return path
}

RemoveOldData() {
    global DIR_NAME
    FileRemoveDir, %DIR_NAME%, 1
}

InstallIcons() {
    global DIR_ICON
    FileCreateDir,  %DIR_ICON%
    FileInstall, .\res\update.ico, %DIR_ICON%\update.ico, 1
    FileInstall, .\res\seedling.ico, %DIR_ICON%\seedling.ico, 1
    FileInstall, .\res\default.ico, %DIR_ICON%\default.ico, 1
    FileInstall, .\res\clear.ico, %DIR_ICON%\clear.ico, 1
    FileInstall, .\res\close.ico, %DIR_ICON%\close.ico, 1
}

InstallUpdateTool() {
    global DIR_NAME, PATH_UPDATER
    FileCreateDir,  %DIR_NAME%
    FileInstall, .\lib\util\updater.exe, %PATH_UPDATER%, 1
}

WriteToIni(sec, key, val) {
    global DIR_NAME
    IniWrite, %val%, %DIR_NAME%\yhotkeys.ini, %sec%, %key%
}

CheckForUpdate() {
    global PATH_UPDATER, DIR_NAME, APP_NAME, VERSION, API_RELEASE
    command = %PATH_UPDATER% "%APP_NAME%" "%VERSION%" "%API_RELEASE%" "%A_ScriptFullPath%"
    RunWait, %command%
}
