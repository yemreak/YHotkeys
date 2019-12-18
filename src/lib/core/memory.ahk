; ####################################################################################
; ##                                                                                ##
; ##                                 HAFIZA İŞLEMLERİ                               ##
; ##                                                                                ##
; ####################################################################################

this_version:= "1.2.3.0"

web_version := "1.2.3.1"

if (web_version > this_version)
  msgbox, get the new update

DropFromMem(ahkID){
    index := GetHiddenWindowIndex(ahkID)
    if index {
        global HIDDEN_WINDOWS
        HIDDEN_WINDOWS.RemoveAt(index)
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

    global HIDDEN_WINDOWS
    HIDDEN_WINDOWS.Push(item)
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
