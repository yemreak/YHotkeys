; ####################################################################################
; ##                                                                                ##
; ##                             SABİTLEME YÖNETİMİ                                 ##
; ##                                                                                ##
; ####################################################################################

; --------------------------------- Hafıza İşlemleri ---------------------------------

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

; --------------------------------- Yönetim İşlemleri ---------------------------------

ReleasePinnedWindow(window_id) {
    ix := GetPinnedWindowIndex(window_id)
    
    global PINNED_WINDOWS
    PINNED_WINDOWS.RemoveAt(ix)
}

ReleaseAllPinnedWindows() {
    window_ids := GetPinnedWindowIDs()
    For index, window_id in window_ids {
        OnPinnedWindow(window_id)
    }
    
    global PINNED_WINDOWS
    PINNED_WINDOWS := []
}

OnPinnedWindow(window_id) {
    UnPinWindow(window_id)
    ReleasePinnedWindow(window_id)
}

OnUnPinnedWindow(window_id) {
    PinWindow(window_id)
    StorePinnedWindow(window_id)
}

UnPinWindow(window_id) {
    global TRANSPARENT_NORMAL
    WinSet, Transparent, %TRANSPARENT_NORMAL%, ahk_id %window_id%
    WinSet, AlwaysOnTop, Off, ahk_id %window_id%
}

PinWindow(window_id) {
    global TRANSPARENT_PINNED
    WinSet, Transparent, %TRANSPARENT_PINNED%, ahk_id %window_id%
    WinSet, AlwaysOnTop, On, ahk_id %window_id%
}

IsWindowTitleExist(window_title) {
    return window_title != "Program Manager" and window_title != ""
}

IsPinned(window_id) {
    WinGet, window_trans, Transparent, ahk_id %window_id%
    
    global TRANSPARENT_PINNED
    return window_trans == TRANSPARENT_PINNED
}

ToggleWindowPin() {
    WinGet, window_id, ID, A
    WinGetTitle, window_title, ahk_id %window_id%
    if (IsWindowTitleExist(window_title)) {
        if (IsPinned(window_id)) {
            OnPinnedWindow(window_id)
        } else {
            OnUnPinnedWindow(window_id)
        }
    }
}
