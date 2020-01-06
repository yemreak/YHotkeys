; ####################################################################################
; ##                                                                                ##
; ##                               PENCERE YÖNETİMİ                                 ##
; ##                                                                                ##
; ####################################################################################

return

; --------------------------------- Hafıza İşlemleri ---------------------------------

class WindowObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

DropFromMem(ahkID){
    index := GetHiddenWindowIndex(ahkID)
    if index {
        global HIDDEN_WINDOWS
        HIDDEN_WINDOWS.RemoveAt(index)
    }
    return index
}

KeepWindowInMem(ahkID) {
    item := CreateWindowObject(ahkID)

    global HIDDEN_WINDOWS
    HIDDEN_WINDOWS.Push(item)
}

CreateWindowObject(ahkID) {
    WinGetTitle, title, ahk_id %ahkID%
    WinGet, iconPath, ProcessPath, ahk_id %ahkID%

    item := new WindowObject

    item.ahkID := ahkID
    item.title := title
    item.iconPath := iconPath

    return item
}

GetHiddenWindowIDs(){
    ahkIDs := []
    global HIDDEN_WINDOWS
    For index, item in HIDDEN_WINDOWS {
        ahkIDs.Push(item.ahkID)
    }
return ahkIDs
}

GetHiddenWindowIDByTitle(title){
    global HIDDEN_WINDOWS
    For index, item in HIDDEN_WINDOWS {
        if (item.title == title) {
            return item.ahkID
        }
    }
return 0
}

GetHiddenWindowIndex(ahkID){
    global HIDDEN_WINDOWS
    For index, item in HIDDEN_WINDOWS {
        if (item.ahkID == ahkID) {
            return index
        }
    }
return 0
}

; --------------------------------- Yönetim İşlemleri ---------------------------------

ShowHidedWindow(ahkId)
{
    WinRestore, ahk_id %ahkID%
    WinShow, ahk_id %ahkID%
}

MinimizeWindow(ahkId) {
    Winminimize, ahk_id %ahkID%
}

ActivateWindow(ahkID, wait=False) {
    WinActivate, ahk_id %ahkID%
    if wait
        WinWaitActive, ahk_id %ahkID%
}

SendWindowToTrayByID(ahkID) {
    WinHide ahk_id %ahkID%
}

SwitchWindow() {
    WinGet, window_id, ID, A
    WinGet, window_exe, ProcessName, ahk_id %window_id%
    WinGet, window_ids, List, ahk_exe %window_exe%
    Loop, %window_ids% {
        window_idx := window_ids%A_Index%
        WinGetTitle, window_titlex, ahk_id %window_idx%
        if (IsWindowTitleExist(window_titlex) and window_idx != window_id) {
            WinActivate, ahk_id %window_idx%
            Break
        }
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

        DetectHiddenWindows, On
        if WinExist("ahk_id" . ahkID) {
            WinGetTitle, title, ahk_id %ahkID%
            if (title == "")
                continue

            ToggleWindow(ahkID, True)
            found := True
        }
    }
    if !found
        RunOnExplorer(url)
}

OpenWindowByTitle(title, url, mode=3) {
    SetTitleMatchMode, %mode%
    DetectHiddenWindows, Off

    if WinExist(title) {
        WinGet, ahkID, ID, %title%
        ToggleWindow(ahkID, False)
    } else {
        RunOnExplorer(url)
    }
}

ShowAllHiddenWindows() {
    ahkIDs := GetHiddenWindowIDs()
    For index, ahkID in ahkIDs {
        ToggleWindow(ahkID, True)
    }

    return ahkIDs
}

ClearAllHiddenWindows() {
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
        global APP_PAGE
        Run, %APP_PAGE%
}

ShowWindowInTray(ahkID) {
    if DropFromMem(ahkID){
        DropWindowFromTrayMenu(ahkID)
        CreateOrUpdateTrayMenu()
    }
    ShowHidedWindow(ahkID)
}

FocusPreviusWindow() {
    Send !{ESC}
}

MinimizeWindowToTray(ahkID) {
    KeepWindowInMem(ahkID)
    FocusPreviusWindow()
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
    } else {
        MinimizeWindow(ahkID)
    }
}

OnWinNotActive(ahkID) {
    ActivateWindow(ahkID)
}

; DEV: Toggle windows by class
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
