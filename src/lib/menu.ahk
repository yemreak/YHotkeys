; Menü yönetimi

class MenuObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

CreateOrUpdateTrayMenu(dirname, windows, version){
    Menu, Tray, DeleteAll

    Menu, Tray, UseErrorLevel , On
    Menu, Tray, NoStandard
    Menu, Tray, Click, 1

    Menu, Tray, Add, YHotkeys, IconClicked
    Menu, Tray, Tip, YHotkeys v%version% ~ YEmreAk

    iconPath := dirname . "\seedling.ico"
    defaultIconPath := dirname . "\default.ico"

    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 20
        iconPath := dirname . "\seedling.ico"
        AddTrayMenuIcon("YHotkeys", iconPath, defaultIconPath)
    }

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
