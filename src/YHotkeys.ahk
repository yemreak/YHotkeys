; v1.1.31.01'de tüm desktoplarda çalışır
; https://www.autohotkey.com/download/1.1/AutoHotkey_1.1.31.01_setup.exe

#NoEnv  ; Uyumlukuk için A_ ön eki ile ortam değişkenlerini kullanın
#SingleInstance Force ; Sadece 1 kez açalıştırabilire

#KeyHistory 0 ; Tuş basımları loglamayı engeller

SetBatchLines, -1 ; Scripti sürekli olarak çalıştırma (nromalde her saniye 10ms uyur)
ListLines, On ; Derlenen verileri loglamaz

#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; Yanlışlıkla 2 kere buton algılanmasını engeller

OnExit("ExitFunc")

#Include, %A_ScriptDir%\lib\core\config.ahk

InstallIcons()
CreateOrUpdateTrayMenu()

return

#Include, %A_ScriptDir%\lib\core\common.ahk
#Include, %A_ScriptDir%\lib\core\menu.ahk
#Include, %A_ScriptDir%\lib\core\memory.ahk
#Include, %A_ScriptDir%\lib\core\window.ahk
#Include, %A_ScriptDir%\lib\util\hotkeys.ahk
#Include, %A_ScriptDir%\lib\util\yemoji.ahk
#Include, %A_ScriptDir%\lib\util\fullscreen.ahk

IconClicked:
    ToggleMemWindowWithTitle(A_ThisMenuItem)
return

ClearAll:
    ClearAllHIDDEN_WINDOWS()
return

CheckForUpdate:
    ; TODO: Update aracını çalıştır
return

ShowAll:
    ShowAllHiddenWindows()
return

CloseApp:
    ExitApp
Return

ExitFunc(exitReason, exitCode) {
    if exitReason not in Logoff,Shutdown
    {
        ShowAllHiddenWindows()
        ReleaseAllPinnedWindows()
        return 0
    }
}

OpenWindowInTray(selector, name, url, mode=3) {
    SetTitleMatchMode, %mode%
    DetectHiddenWindows, On

    IDlist := []
    if (selector == "title") {
        WinGet, IDlist, list, %name%
    } else if (selector == "class") {
        WinGet, IDlist, list, ahk_class %name%
    } else if (selector == "exe") {
        WinGet, IDlist, list, ahk_exe %name%
    }

    found := False
    Loop, %IDlist% {
        ahkID := IDlist%A_INDEX%
        if WinExist("ahk_id" . ahkID) {
            WinGetTitle, title
            if (title == "")
                continue

            ToggleWindow(ahkID, True)
            found := True
        }
    }
    if !found
        RunUrl(url)
}

OpenWindowByTitle(title, url, mode=3) {
    SetTitleMatchMode, %mode%
    DetectHiddenWindows, Off

    if WinExist(title) {
        WinGet, ahkID, ID, %title%
        ToggleWindow(ahkID, False)
    } else {
        RunUrl(url)
    }
}

ShowAllHiddenWindows() {
    ahkIDs := GetHiddenWindowIDs()
    For index, ahkID in ahkIDs {
        ToggleWindow(ahkID, True)
    }

    return ahkIDs
}

ClearAllHIDDEN_WINDOWS() {
    DetectHiddenWindows, On

    ahkIDs := GetHiddenWindowIDs()
    For index, ahkID in ahkIDs {
        WinKill, ahk_id %ahkID%
        WinWaitClose, ahk_id %ahkID%
    }

    global HIDDEN_WINDOWS
    HIDDEN_WINDOWS := []

    CreateOrUpdateTrayMenu()
}

ToggleMemWindowWithTitle(menuName) {
    ahkID := GetHiddenWindowIDByTitle(menuName)
    if ahkID
        ToggleWindow(ahkID, True)
    else
        Run https://github.com/yedhrab/YHotkeys
}

ShowWindowInTray(ahkID) {
    if DropFromMem(ahkID){
        DropWindowFromTrayMenu(ahkID)
        CreateOrUpdateTrayMenu()
    }
    ShowHidedWindow(ahkID)
}

MinimizeWindowToTray(ahkID) {
    KeepWindowInMem(ahkID)
    SendWindowToTrayByID(ahkID)
    CreateOrUpdateTrayMenu()
}

OnWinNotExist(ahkID, mask) {
    if mask {
        ShowWindowInTray(ahkID)
    }
    ActivateWindow(ahkID)
}

OnWinActive(ahkID, mask) {
    if mask {
        MinimizeWindowToTray(ahkID)
    }
    MinimizeWindow(ahkID)
}

OnWinNotActive(ahkID) {
    ActivateWindow(ahkID)
}

ToggleWindow(ahkID, mask=False) {
    DetectHiddenWindows, Off
    if !WinExist("ahk_id" . ahkID) {
        OnWinNotExist(ahkID, mask)
    } else {
        if WinActive("ahk_id" . ahkID) {
            OnWinActive(ahkID, mask)
        } else {
            OnWinNotActive(ahkID)
        }
    }
}
