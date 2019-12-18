; ####################################################################################
; ##                                                                                ##
; ##                               PENCERE YÖNETİMLERİ                              ##
; ##                                                                                ##
; ####################################################################################

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

IsWindowTitleExist(window_title) {
    return window_title != "Program Manager" and window_title != ""
}

StorePinnedWindow(window_id) {
    global PINNED_WINDOWS
    PINNED_WINDOWS.Push(window_id)
}

GetPinnedWindowIndex(window_id) {
    global PINNED_WINDOWS
    For index, wid in PINNED_WINDOWS {
        if (wid == window_id) {
            return index
        }
    }
    return 0
}

GetPinnedWindowIDs(){
    window_ids := []
    global PINNED_WINDOWS
    For index, window_id in PINNED_WINDOWS {
        window_ids.Push(window_id)
    }
return window_ids
}

ReleasePinnedWindow(window_id) {
    ix := GetPinnedWindowIndex(window_id)

    global PINNED_WINDOWS
    PINNED_WINDOWS.RemoveAt(ix)
}

ReleaseAllPinnedWindows() {
    window_ids := GetPinnedWindowIDs()
    For index, window_id in window_ids {
        WinGetTitle, window_title, ahk_id %window_id%
        OnPinnedWindow(window_id, window_title)
    }

    global PINNED_WINDOWS
    PINNED_WINDOWS := []
}

OnPinnedWindow(window_id, window_title) {
    UnPinWindow(window_id, window_title)
    ReleasePinnedWindow(window_id)
}

OnUnPinnedWindow(window_id, window_title) {
    PinWindow(window_id, window_title)
    StorePinnedWindow(window_id)
}

UnPinWindow(window_id, window_title) {
    global TRANSPARENT_NORMAL
    WinSet, Transparent, %TRANSPARENT_NORMAL%, ahk_id %window_id%

    new_title := StrReplace(window_title, "📌 ", "")
    WinSetTitle, ahk_id %window_id%, ,%new_title%

    WinSet, AlwaysOnTop, Off, ahk_id %window_id%
}

PinWindow(window_id, window_title) {
    global TRANSPARENT_PINNED
    WinSet, Transparent, %TRANSPARENT_PINNED%, ahk_id %window_id%

    new_title := "📌 " . window_title
    WinSetTitle, ahk_id %window_id%, ,%new_title%

    WinSet, AlwaysOnTop, On, ahk_id %window_id%
}

ToggleWindowPin() {
    WinGet, window_id, ID, A
    WinGetTitle, window_title, ahk_id %window_id%
    if (IsWindowTitleExist(window_title)) {
        if InStr(window_title, "📌") {
            OnPinnedWindow(window_id, window_title)
        } else {
            OnUnPinnedWindow(window_id, window_title)
        }
    }
}
