; Hafıza işlemleri
DropActiveWindowFromMem(){
    WinGet, ahkID, ID, A

return DropFromMem(ahkID)
}

DropFromMem(ahkID){
    index := GetHidedWindowsIndexWithID(ahkID)
    if index {
        global HidedWindows
        HidedWindows.RemoveAt(index)
    }
return index
}

; Gizlenmeden önce kullanılmazsa id alamaz
KeepActiveWindowInMem() {
    WinGetActiveTitle, title
    WinGet, ahkID, ID, A
    WinGet, iconPath, ProcessPath, A

    KeepInMem(ahkID, title, iconPath)
}

KeepInMem(ahkID, title, iconPath) {
    item := new MenuObject

    item.ahkID := ahkID
    item.title := title
    item.iconPath := iconPath

    global HidedWindows
    HidedWindows.Push(item)
}

ClearAllHidedWindows() {
    ahkIDs := GetHidedWindowsIDs()
    For index, ahkID in ahkIDs {
        ToggleWindowWithID(ahkID, True)
        WinKill, ahk_id %ahkID%
    }
}

GetHidedWindowsIDs(){
    ahkIDs := []
    global HidedWindows
    For index, item in HidedWindows {
        ahkIDs.Push(item.ahkID)
    }
return ahkIDs
}

GetHidedWindowsIDWithTitle(title){
    global HidedWindows
    For index, item in HidedWindows {
        if (item.title == title) {
            return item.ahkID
        }
    }
return 0
}

GetHidedWindowsIndexWithID(ahkID){
    global HidedWindows
    For index, item in HidedWindows {
        if (item.ahkID == ahkID) {
            return index
        }
    }
return 0
}
