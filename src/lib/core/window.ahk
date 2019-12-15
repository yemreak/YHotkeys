; Pencere yönetimleri

ShowHidedWindowWithID(ahkId)
{
    WinRestore, ahk_id %ahkID%
    WinShow, ahk_id %ahkID%
}

MinimizeWindowWithID(ahkId) {
    Winminimize, ahk_id %ahkID%
}

ActivateWindowWithID(ahkID, wait=False) {
    WinActivate, ahk_id %ahkID%
    if wait
        WinWaitActive, ahk_id %ahkID%
}

; WARN: Bug sebebi olabilir (bundan değil bug)
; WARN: Eğer uyarı mesajı verilirse, odaklanma bozuluyor
FocusPreviusWindow(ahkID) {
    ; SendMessage, 0x7, 0, 0, Edit3, A  ; WM_SETFOCUS = 0x07
    SendInput, !{Esc}
    WinWaitNotActive, ahk_id %ahkID%
}

SendWindowToTrayByID(ahkID) {
    WinHide ahk_id %ahkID%
}
