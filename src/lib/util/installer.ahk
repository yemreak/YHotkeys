﻿#Warn ; Enable warnings to assist with detecting common errors.
#NoEnv ; Uyumlukuk için A_ ön eki ile ortam değişkenlerini kullanın
#SingleInstance Force ; Sadece 1 kez açalıştırabilire
#KeyHistory 0 ; Tuş basımları loglamayı engeller

SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; Yanlışlıkla 2 kere buton algılanmasını engeller

#Include, %A_ScriptDir%\..\core\config.ahk

TIP_MENU := "👷‍♂️ YHotkeys - Kurulum Aracı ~ YEmreAk (v" . VERSION . ")"
ICON_TRAY := "..\..\res\worker.ico"

SetTrayMenu()

if (CLEAN_INSTALL) {
    RemoveOldData()
}

if (ShowConfirmDialog()) {
    KillScript()
    CreateDataDir()
    InstallIcons()
    InstallExe()
    InstallTools()
    AskToStart()
}
return

SetTrayMenu() {
    global TIP_MENU, ICON_TRAY
    Menu, Tray, Tip, %TIP_MENU%
    If (FileExist(ICON_TRAY)) {
        Menu, Tray, Icon, %ICON_TRAY%
    }
}

RemoveOldData() {
    global DIR_NAME
    FileRemoveDir, %DIR_NAME%, 1
}

InstallIcons() {
    global DIR_ICON
    FileCreateDir, %DIR_ICON%
    FileInstall, ..\..\res\update.ico, %DIR_ICON%\update.ico, 1
    FileInstall, ..\..\res\seedling.ico, %DIR_ICON%\seedling.ico, 1
    FileInstall, ..\..\res\default.ico, %DIR_ICON%\default.ico, 1
    FileInstall, ..\..\res\clear.ico, %DIR_ICON%\clear.ico, 1
    FileInstall, ..\..\res\close.ico, %DIR_ICON%\close.ico, 1
    FileInstall, ..\..\res\details.ico, %DIR_ICON%\details.ico, 1
    FileInstall, ..\..\res\hotkeys.ico, %DIR_ICON%\hotkeys.ico, 1
    FileInstall, ..\..\res\doc.ico, %DIR_ICON%\doc.ico, 1
    FileInstall, ..\..\res\worker.ico, %DIR_ICON%\worker.ico, 1
}

CreateDataDir() {
    global DIR_NAME
    FileCreateDir, %DIR_NAME%
}

InstallExe() {
    global DIR_NAME, PATH_EXE, DIR_ICON
    FileInstall, ..\..\YHotkeys.exe, %PATH_EXE%, 1
    FileCreateShortcut, %PATH_EXE%, %A_Desktop%\YHotkeys.lnk, %DIR_NAME%, , Kısayol Yöneticisi, %DIR_ICON%\seedling.ico
    AskToAddStartUp()
}

InstallTools() {
    InstallUpdateTool()
    InstallEmojiScript()
    ; InstallPythonTool()
}

InstallEmojiScript() {
    global DIR_SCRIPTS
    FileCreateDir, %DIR_SCRIPTS%
    FileInstall, .\yemoji.ahk, %DIR_SCRIPTS%\yemoji.ahk, 1
}

; InstallPythonTool() {
;     ; FileInstall, ..\..\tools\temp.exe, %DIR_ICON%\temp.exe, 1
; }

InstallUpdateTool() {
    global PATH_UPDATER
    FileInstall, .\YUpdater.exe, %PATH_UPDATER%, 1
}

AskToStart() {
    if (AskDialog("▶️ Kurulum tamamlandı, çalıştırmak ister misiniz?")) {
        global PATH_EXE
        Run, %PATH_EXE%
    }
    ExitApp
}

AskToAddStartUp() {
    if (AskDialog("▶️ Başlangıçta çalışmasını ister misiniz?")) {
        global DIR_NAME, PATH_EXE, DIR_ICON
        FileCreateShortcut, %PATH_EXE%, %A_Startup%\YHotkeys.lnk, %DIR_NAME%, , Kısayol Yöneticisi, %DIR_ICON%\seedling.ico
    }
}

AskDialog(message) {
    global RELEASE_TITLE, RELEASE_BODY, TIP_MENU, APP_VERSION, RELEASE_TAGNAME
    MsgBox, 4, %TIP_MENU%, %message%
    IfMsgBox Yes
    return True
    else
        return False
}

ShowConfirmDialog() {
    global RELEASE_TITLE, RELEASE_BODY, TIP_MENU, APP_VERSION, RELEASE_TAGNAME
    MsgBox, 4, %TIP_MENU%, ☠️ Kurulum işlemi çalışan YHotkeys'i sonlandıracaktır, devam edilsin mi?
    IfMsgBox Yes
    return True
    else
        return False
}

KillScript() {
    global APP_NAME
    command = taskkill /IM "%APP_NAME%.*" /F /T
    RunWait, %comspec% /c "%command%", , Hide
}
