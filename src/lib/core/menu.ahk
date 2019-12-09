; Menü yönetimi

class MenuObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

GetIconPath(dirname, iconName) {
    return dirname . "\" . iconName
}

CreateMenuHeader(appname, iconPath, defaultIconPath, version) {
    Menu, Tray, UseErrorLevel , On
    Menu, Tray, NoStandard
    Menu, Tray, Click, 1

    Menu, Tray, Add, %appname%, IconClicked
    Menu, Tray, Tip, %appname% v%version% ~ YEmreAk

    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 20
        AddTrayMenuIcon(appname, iconPath, defaultIconPath)
    }
}

CreateMenuFooter(mainTitle, iconPath, defaultIconPath) {
    Menu, Tray, Default, %mainTitle%
    Menu, Tray, Add, Kapat, CloseApp

    global TITLE_CLOSE
    AddTrayMenuIcon(TITLE_CLOSE, iconPath, defaultIconPath)
}

AddUpdateMenu(iconPath, defaultIconPath) {
    Menu, Tray, Add, Update, UpdateClick
    AddTrayMenuIcon("Update", iconPath, defaultIconPath)
}

CreateOrUpdateTrayMenu(appname, dirname, windows, version){
    Menu, Tray, DeleteAll

    global ICON_APP, ICON_DEFAULT
    iconPath := GetIconPath(dirname, ICON_APP)
    defaultIconPath := GetIconPath(dirname, ICON_DEFAULT)

    CreateMenuHeader(appname, iconPath, defaultIconPath, version)

    if (windows.Length() > 0) {
        iconPath := windows[windows.Length()].iconPath
        mainTitle := windows[windows.Length()].title

        For index, item in windows {
            title := item.title
            iconPath := item.iconPath

            Menu, Tray, Add, %title%, IconClicked
            AddTrayMenuIcon(title, iconPath, defaultIconPath)
        }

        Menu, Tray, Add, Temizle, ClearAll

        global ICON_CLEAR, TITLE_CLEAR
        iconPath := GetIconPath(dirname, ICON_CLEAR)
        AddTrayMenuIcon(TITLE_CLEAR, iconPath, defaultIconPath)

    } else {
        mainTitle := appname
    }

    iconPath := GetIconPath(dirname, ICON_CLEAR)
    AddUpdateMenu(iconPath, defaultIconPath)

    global ICON_CLOSE
    iconPath := GetIconPath(dirname, ICON_CLOSE)
    CreateMenuFooter(mainTitle, iconPath, defaultIconPath)
}

DropWindowFromTrayMenu(ahkID, windows){
    WinGetTitle, title, ahk_id %ahkID%
    Menu, Tray, Delete, %title%
    if !windows.Length()
        Menu, Tray, Delete, Temizle
}

AddTrayMenuIcon(title, iconPath, defaultIconPath=False) {
    if FileExist(iconPath) {
        Menu, Tray, Icon, %title%, %iconPath%,, 20
    } else if default {
        AddTrayMenuIcon(title, defaultIconPath)
    }
}
