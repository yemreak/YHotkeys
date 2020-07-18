; ####################################################################################
; ##                                                                                ##
; ##                                 MENÜ YÖNETİMLERİ                               ##
; ##                                                                                ##
; ####################################################################################

GetIconPath(iconName) {
    global DIR_ICON
    return DIR_ICON . "\" . iconName
}

DeleteMenu() {
    global MENU_TRAY, MENU_MORE
    Menu, %MENU_TRAY%, DeleteAll
}

AddHeaderMenu() {
    global APP_NAME, TIP_MENU, ICON_APP
    
    Menu, Tray, UseErrorLevel , On
    Menu, Tray, NoStandard
    Menu, Tray, Click, 1
    
    Menu, Tray, Add, %APP_NAME%, IconClicked
    Menu, Tray, Tip, %TIP_MENU%
    
    iconPath := GetIconPath(ICON_APP)
    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 20
        
        global MENU_TRAY
        AddMenuIcon(MENU_TRAY, APP_NAME, iconPath)
    }
    
    Menu, Tray, Default, %APP_NAME%
}

CreateMenuItem(rootmenu, title, onclick, icon_name) {
    Menu, %rootmenu%, Add, %title%, %onclick%
    iconPath := GetIconPath(icon_name)
    AddMenuIcon(rootmenu, title, iconPath)
}

AddFooterMenu() {
    global MENU_TRAY, TITLE_CLOSE, ICON_CLOSE
    CreateMenuItem(MENU_TRAY, TITLE_CLOSE, "CloseApp", ICON_CLOSE)
}

AddUpdateMenu() {
    global MENU_MORE, TITLE_UPDATE, ICON_UPDATE
    CreateMenuItem(MENU_MORE, TITLE_UPDATE, "CheckForUpdate", ICON_UPDATE)
}

AddClearMenu() {
    global MENU_TRAY, TITLE_CLEAR, ICON_CLEAR
    CreateMenuItem(MENU_TRAY, TITLE_CLEAR, "ClearAll", ICON_CLEAR)
}

AddDocumentationMenu() {
    global MENU_MORE, TITLE_DOC, ICON_DOC
    CreateMenuItem(MENU_MORE, TITLE_DOC, "OnDocumentationClicked", ICON_DOC)
}

AddHotkeysMenu() {
    global MENU_MORE, TITLE_HOTKEYS, ICON_HOTKEY
    CreateMenuItem(MENU_MORE, TITLE_HOTKEYS, "OnHotkeysClicked", ICON_HOTKEY)
}

HasHiddenWindow() {
    global HIDDEN_WINDOWS
    return HIDDEN_WINDOWS.Length() > 0
}

AddWindowsMenu() {
    global HIDDEN_WINDOWS
    iconPath := HIDDEN_WINDOWS[HIDDEN_WINDOWS.Length()].iconPath
    mainTitle := HIDDEN_WINDOWS[HIDDEN_WINDOWS.Length()].title
    
    For index, item in HIDDEN_WINDOWS {
        title := item.title
        iconPath := item.iconPath
        
        global MENU_TRAY
        Menu, %MENU_TRAY%, Add, %title%, IconClicked
        AddMenuIcon(MENU_TRAY, title, iconPath)
    }
}

CreateSubMenu(rootmenu, title, submenu, icon_name) {
    Menu, %rootmenu%, Add, %title%, :%submenu%
    iconPath := GetIconPath(icon_name)
    AddMenuIcon(rootmenu, title, iconPath)
}

AddMoreMenu() {
    AddDocumentationMenu()
    AddHotkeysMenu()
    AddUpdateMenu()
    
    global MENU_TRAY, TITLE_MORE, MENU_MORE, ICON_MORE
    CreateSubMenu(MENU_TRAY, TITLE_MORE, MENU_MORE, ICON_MORE)
}

CreateOrUpdateTrayMenu(){
    DeleteMenu()
    AddHeaderMenu()
    
    if (HasHiddenWindow()) {
        AddWindowsMenu()
        AddClearMenu()
    }
    
    AddMoreMenu()
    AddFooterMenu()
}

DropWindowFromTrayMenu(ahkID){
    WinGetTitle, title, ahk_id %ahkID%
    Menu, Tray, Delete, %title%
    
    global HIDDEN_WINDOWS
    if !HIDDEN_WINDOWS.Length()
        Menu, Tray, Delete, Temizle
}

AddMenuIcon(mname, title, iconPath) {
    if FileExist(iconPath) {
        Menu, %mname%, Icon, %title%, %iconPath%,, 20
    } else {
        global ICON_DEFAULT
        defaultIconPath := GetIconPath(ICON_DEFAULT)
        Menu, %mname%, Icon, %title%, %defaultIconPath%,, 20
    }
}
