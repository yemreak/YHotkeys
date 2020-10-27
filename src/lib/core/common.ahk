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

createAppCommand(path, query) {
    ; path := CreateGoogleSearchUrl(query)
    return ExplorerCommand("shell:appsFolder\" . path)
}

WriteToIni(sec, key, val) {
    global DIR_NAME
    IniWrite, %val%, %DIR_NAME%\yhotkeys.ini, %sec%, %key%
}

CheckForUpdate(silent := False) {
    global PATH_UPDATER, DIR_NAME, APP_NAME, VERSION, API_RELEASE
    updateCommand = %PATH_UPDATER% "%APP_NAME%" "%VERSION%" "%API_RELEASE%" "%A_Temp%\YInstaller.exe" %silent%
    RunWait, %updateCommand%
}

TrimStr(str) {
    return Trim(Clipboard, OmitChars := " `r`n`t")
}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

HasVal(haystack, needle) {
    for index, value in haystack
        if (value = needle)
        return index
    if !(IsObject(haystack))
        throw Exception("Bad haystack!", -1, haystack)
    return 0
}
