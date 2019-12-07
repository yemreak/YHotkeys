; Menü yönetimi

class MenuObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

CreateMenuHeader(name, iconPath, defaultIconPath, version) {
    Menu, Tray, UseErrorLevel , On
    Menu, Tray, NoStandard
    Menu, Tray, Click, 1

    Menu, Tray, Add, %name%, IconClicked
    Menu, Tray, Tip, %name% v%version% ~ YEmreAk

    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 20
        AddTrayMenuIcon(name, iconPath, defaultIconPath)
    }
}

CreateOrUpdateTrayMenu(name, dirname, windows, version){
    Menu, Tray, DeleteAll

    iconPath := dirname . "\seedling.ico"
    defaultIconPath := dirname . "\default.ico"

    CreateMenuHeader(name, iconPath, defaultIconPath, version)

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

        iconPath := dirname . "\clear.ico"
        AddTrayMenuIcon("Temizle", iconPath, defaultIconPath)

    } else {
        mainTitle := "YHotkeys"
    }

    Menu, Tray, Default, YHotkeys
    Menu, Tray, Add, Kapat, CloseApp

    iconPath := dirname . "\close.ico"
    AddTrayMenuIcon("Kapat", iconPath, defaultIconPath)
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
