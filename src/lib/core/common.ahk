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

InstallIcons() {
    global DIR_NAME
    FileCreateDir,  %DIR_NAME%
    FileInstall, .\res\update.ico, %DIR_NAME%\update.ico, 1
    FileInstall, .\res\seedling.ico, %DIR_NAME%\seedling.ico, 1
    FileInstall, .\res\default.ico, %DIR_NAME%\default.ico, 1
    FileInstall, .\res\clear.ico, %DIR_NAME%\clear.ico, 1
    FileInstall, .\res\close.ico, %DIR_NAME%\close.ico, 1
}
