; ####################################################################################
; ##                                                                                ##
; ##                                 MENÜ YÖNETİMLERİ                               ##
; ##                                                                                ##
; ####################################################################################

class MenuObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

GetIconPath(iconName) {
    global DIR_NAME
    return DIR_NAME . "\" . iconName
}

DeleteMenu() {
    Menu, Tray, DeleteAll
}

AddHeaderMenu() {
    global APP_NAME, ICON_APP, VERSION

    Menu, Tray, UseErrorLevel , On
    Menu, Tray, NoStandard
    Menu, Tray, Click, 1

    Menu, Tray, Add, %APP_NAME%, IconClicked
    Menu, Tray, Tip, %APP_NAME% v%VERSION% ~ YEmreAk

    iconPath := GetIconPath(ICON_APP)
    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 20
        AddTrayMenuIcon(APP_NAME, iconPath)
    }
}

AddFooterMenu() {
    global TITLE_CLOSE
    Menu, Tray, Add, %TITLE_CLOSE%, CloseApp

    global ICON_CLOSE
    iconPath := GetIconPath(ICON_CLOSE)
    AddTrayMenuIcon(TITLE_CLOSE, iconPath)
}

AddUpdateMenu() {
    global RELEASE_TAGNAME
    if (RELEASE_TAGNAME) {
        global TITLE_UPDATE
        title := TITLE_UPDATE . " (v" . RELEASE_TAGNAME . ")"
        Menu, Tray, Add, %title%, UpdateClick

        global ICON_UPDATE
        iconPath := GetIconPath(ICON_UPDATE)

        AddTrayMenuIcon(title, iconPath)
    }
}

AddClearMenu() {
    global TITLE_CLEAR
    Menu, Tray, Add, %TITLE_CLEAR%, ClearAll

    global ICON_CLEAR
    iconPath := GetIconPath(ICON_CLEAR)

    AddTrayMenuIcon(TITLE_CLEAR, iconPath)
}

AddWindowsMenu() {
    global HIDDEN_WINDOWS
    if (HIDDEN_WINDOWS.Length() > 0) {
        iconPath := HIDDEN_WINDOWS[HIDDEN_WINDOWS.Length()].iconPath
        mainTitle := HIDDEN_WINDOWS[HIDDEN_WINDOWS.Length()].title

        For index, item in HIDDEN_WINDOWS {
            title := item.title
            iconPath := item.iconPath

            Menu, Tray, Add, %title%, IconClicked
            AddTrayMenuIcon(title, iconPath)
        }
        AddClearMenu()
    } else {
        global APP_NAME
        mainTitle := APP_NAME
    }

    Menu, Tray, Default, %mainTitle%
}

CreateOrUpdateTrayMenu(){
    DeleteMenu()
    AddHeaderMenu()
    AddWindowsMenu()
    AddUpdateMenu()
    AddFooterMenu()
}

DropWindowFromTrayMenu(ahkID){
    WinGetTitle, title, ahk_id %ahkID%
    Menu, Tray, Delete, %title%

    global HIDDEN_WINDOWS
    if !HIDDEN_WINDOWS.Length()
        Menu, Tray, Delete, Temizle
}

AddTrayMenuIcon(title, iconPath) {
    if FileExist(iconPath) {
        Menu, Tray, Icon, %title%, %iconPath%,, 20
    } else {
        global ICON_DEFAULT
        defaultIconPath := GetIconPath(ICON_DEFAULT)
        Menu, Tray, Icon, %title%, %defaultIconPath%,, 20
    }
}
