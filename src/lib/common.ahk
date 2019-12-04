; Genel işlemler

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

InstallIcons(dir_name) {
    FileCreateDir,  %dir_name%
    FileInstall, .\res\seedling.ico, %dir_name%\seedling.ico, 1
    FileInstall, .\res\default.ico, %dir_name%\default.ico, 1
    FileInstall, .\res\clear.ico, %dir_name%\clear.ico, 1
    FileInstall, .\res\close.ico, %dir_name%\close.ico, 1
}
