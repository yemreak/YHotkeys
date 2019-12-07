; Hafıza işlemleri
DropFromMem(ahkID, HidedWindows){
    index := GetHidedWindowsIndexWithID(ahkID)
    if index {
        HidedWindows.RemoveAt(index)
    }
return index
}

KeepWindowInMem(ahkID) {
    WinGetTitle, title, ahk_id %ahkID%
    WinGet, iconPath, ProcessPath, ahk_id %ahkID%
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
