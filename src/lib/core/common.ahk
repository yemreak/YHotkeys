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

WriteToIni(sec, key, val) {
    global DIR_NAME
    IniWrite, %val%, %DIR_NAME%\yhotkeys.ini, %sec%, %key%
}

CheckForUpdate(silent := False) {
    global PATH_UPDATER, DIR_NAME, APP_NAME, VERSION, API_RELEASE
    command = %PATH_UPDATER% "%APP_NAME%" "%VERSION%" "%API_RELEASE%" "%A_Temp%\YInstaller.exe" %silent%
    RunWait, %command%
}
