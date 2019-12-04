; Menü yönetimi

class MenuObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

IconClicked:
    ToggleMemWindowWithTitle(A_ThisMenuItem)
Return

ClearAll:
    ClearAllHidedWindows()
Return

CloseApp:
    ClearAllHidedWindows()
    ExitApp
Return

CreateOrUpdateTrayMenu(dirname, windows, version){
    #Persistent
    Menu, Tray, UseErrorLevel , On
    Menu, Tray, NoStandard
    Menu, Tray, Add, YHotkeys, IconClicked

    Menu, Tray, Tip, YHotkeys v%version% ~ YEmreAk
    Menu, Tray, Click, 1

    iconPath := dirname . "\seedling.ico"
    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 20
        iconPath := dirname . "\seedling.ico"
        AddTrayMenuIcon("YHotkeys", iconPath)
    }

    if (windows.Length() > 0) {
        Menu, Tray, Add, Temizle, ClearAll
        Menu, Tray, Delete, Temizle
        Menu, Tray, Delete, Kapat

        iconPath := windows[windows.Length()].iconPath
        mainTitle := windows[windows.Length()].title

        For index, item in windows {
            title := item.title
            iconPath := item.iconPath

            Menu, Tray, Add, %title%, IconClicked
            AddTrayMenuIcon(title, iconPath)
        }

        Menu, Tray, Add, Temizle, ClearAll

        iconPath := dirname . "\clear.ico"
        AddTrayMenuIcon("Temizle", iconPath)

    } else {
        mainTitle := "YHotkeys"
    }

    Menu, Tray, Default, YHotkeys
    Menu, Tray, Add, Kapat, CloseApp

    iconPath := dirname . "\close.ico"
    AddTrayMenuIcon("Kapat", iconPath)
}

DropActiveWindowFromTrayMenu(windows){
    WinGetTitle, title, A
    Menu, Tray, Delete, %title%
    if !windows.Length()
        Menu, Tray, Delete, Temizle
}

AddTrayMenuIcon(title, iconPath, default=True) {
    if FileExist(iconPath) {
        Menu, Tray, Icon, %title%, %iconPath%,, 20
    } else if default {
        global dirname
        iconPath := dirname . "\default.ico"
        AddTrayMenuIcon(title, iconPath, False)
    }
}
