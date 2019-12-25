; ####################################################################################
; ##                                                                                ##
; ##                                 GENEL İŞLEMLER                                 ##
; ##                                                                                ##
; ####################################################################################

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

TrimStr(str) {
    return Trim(Clipboard, OmitChars := " `r`n`t")
}
