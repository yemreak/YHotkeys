; v1.1.31.01'de tüm desktoplarda çalışır

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
    
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling

; Gizlenmiş pencelerin ID'si
HidedWindows := []

; TIP: Veri dizini yolu
DIR_NAME = %A_AppData%\YHotkeys

InstallIcons()
UpdateMenu()
return

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

class MenuObject {
    ahkID := 0
    title := ""
    iconPath := ""
}

InstallIcons() {
    global DIR_NAME
    FileCreateDir,  %DIR_NAME%
    FileInstall, .\res\ylogo.ico, %DIR_NAME%\ylogo.ico, 1
    FileInstall, .\res\default.ico, %DIR_NAME%\default.ico, 1
    FileInstall, .\res\clear.ico, %DIR_NAME%\clear.ico, 1
    FileInstall, .\res\close.ico, %DIR_NAME%\close.ico, 1
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

ToggleMemWindowWithTitle(menuName) {
    ahkID := GetHidedWindowsIDWithTitle(menuName)
    if ahkID
        ToggleWindowWithID(ahkID, True)
    else
        Run https://www.yemreak.com
}

RunUrl(url) {
    try {
        Run, %url%
    }
}

ActivateWindowWithID(ahkID, wait=True) {
    WinActivate, ahk_id %ahkID%
    if wait
        WinWaitActive, ahk_id %ahkID%
}

ShowHidedWindowWithID(ahkId)
{
    WinRestore, ahk_id %ahkID%
    WinShow, ahk_id %ahkID%
}

DropFromMem(ahkID){
    index := GetHidedWindowsIndexWithID(ahkID)
    if index {
        global HidedWindows
        HidedWindows.RemoveAt(index)
    }
return index
}

DropActiveWindowFromTrayMenu(){
    WinGetTitle, title, A
    Menu, Tray, Delete, %title%
    global HidedWindows
    if !HidedWindows.Length()
        Menu, Tray, Delete, Temizle
}

DropActiveWindowFromMem(){
    WinGet, ahkID, ID, A
    
return DropFromMem(ahkID)
}

KeepInMem(ahkID, title, iconPath) {
    item := new MenuObject
    
    item.ahkID := ahkID
    item.title := title
    item.iconPath := iconPath
    
    global HidedWindows
    HidedWindows.Push(item)
}

; Gizlenmeden önce kullanılmazsa id alamaz
KeepActiveWindowInMem() {
    WinGetActiveTitle, title
    WinGet, ahkID, ID, A
    WinGet, iconPath, ProcessPath, A
    
    KeepInMem(ahkID, title, iconPath)
}

AddTrayMenuIcon(title, iconPath, default=True) {
    if FileExist(iconPath) {
        Menu, Tray, Icon, %title%, %iconPath%,, 20
    } else if default {
        global DIR_NAME
        iconPath := DIR_NAME . "\default.ico"
        AddTrayMenuIcon(title, iconPath, False)
    }
}

UpdateMenu(){
    #Persistent
    ; Menu, Tray, NoStandard
    Menu, Tray, Add, YEmreAk, IconClicked
    
    global DIR_NAME
    iconPath := DIR_NAME . "\ylogo.ico"
    if FileExist(iconPath) {
        Menu, Tray, Icon, %iconPath%,, 0
        Menu, Tray, Icon, YEmreAk, %iconPath%,, 20
    }
    
    global HidedWindows
    if (HidedWindows.Length() > 0) {
        Menu, Tray, Add, Temizle, ClearAll
        Menu, Tray, Delete, Temizle
        Menu, Tray, Delete, Kapat
        
        iconPath := HidedWindows[HidedWindows.Length()].iconPath
        mainTitle := HidedWindows[HidedWindows.Length()].title
        
        For index, item in HidedWindows {
            title := item.title
            iconPath := item.iconPath
            
            Menu, Tray, Add, %title%, IconClicked
            AddTrayMenuIcon(title, iconPath)
        }
        
        Menu, Tray, Add, Temizle, ClearAll
        
        iconPath := DIR_NAME . "\clear.ico"
        AddTrayMenuIcon("Temizle", iconPath)
        
    } else {
        mainTitle := "YEmreAk"
    }
    
    Menu, Tray, Default, %mainTitle%
    Menu, Tray, Add, Kapat, CloseApp
    
    iconPath := DIR_NAME . "\close.ico"
    AddTrayMenuIcon("Kapat", iconPath)
}

SendWindowToTrayByID(ahkID) {
    WinHide ahk_id %ahkID%
}

; WARN: Bug sebebi olabilir
; WARN: Eğer uyarı mesajı verilirse, odaklanma bozuluyor
FocusPreviusWindow() {
    SendEvent, !{Esc}
}

ToggleWindowWithID(ahkID, hide=False) {
    DetectHiddenWindows, Off
    if !WinExist("ahk_id" . ahkID) {
        if hide {
            ShowHidedWindowWithID(ahkID)
            ActivateWindowWithID(ahkID)
            if DropActiveWindowFromMem()
                DropActiveWindowFromTrayMenu()
            UpdateMenu()
        } else {
            ActivateWindowWithID(ahkID, False)
        }
    } else {
        if WinActive("ahk_id" . ahkID) {
            if hide {
                KeepActiveWindowInMem()
                FocusPreviusWindow()
                SendWindowToTrayByID(ahkID)
                UpdateMenu()
            } else {
                WinMinimize, A
            }
        } else {
            ActivateWindowWithID(ahkID, False)
        }
    }
}

; Pencereleri gizlenebilir modda açma
OpenWindowByTitleInTray(windowName, url, mode=3) {
    SetTitleMatchMode, %mode%
    DetectHiddenWindows, On
    
    if WinExist(windowName) {
        WinGet, ahkID, ID, %windowName%
        ToggleWindowWithID(ahkID, True)
    } else {
        RunUrl(url)
    }
    
}

OpenWindowByClassInTray(className, url) {
    DetectHiddenWindows, On
    
    found := False
    WinGet, IDlist, list, ahk_class %className%
    Loop, %IDlist% {
        ahkID := IDlist%A_INDEX%
        if WinExist("ahk_id" . ahkID) {
            WinGetTitle, title
            if (title == "")
                continue
            
            ToggleWindowWithID(ahkID, True)
            found := True
        }
    }
    if !found
        RunUrl(url)
}

OpenWindowByTitle(title, url, mode=3) {
    SetTitleMatchMode, %mode%
    DetectHiddenWindows, Off
    
    if WinExist(title) {
        WinGet, ahkID, ID, %title%
        ToggleWindowWithID(ahkID, False)
    } else {
        RunUrl(url)
    }
}

GetEnvPath(envvar, path=""){
    EnvGet, prepath, %envvar%
    path = %prepath%%path%
return path
}

; ####################################################################################
; ##                                                                                ##
; ##                                   KISAYOLLAR                                   ##
; ##                                                                                ##
; ####################################################################################

; ---------------------------------- Göster / Gizle ----------------------------------
#q::
    name := "- OneNote"
    path := "shell:appsFolder\Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim"
    mode := 2
    OpenWindowByTitle(name, path, mode)
return

; #t::
;     name := "Tureng Dictionary"
;     path := "shell:appsFolder\24232AlperOzcetin.Tureng_9n2ce2f97t3e6!App"
;     mode := 2
;     OpenWindowByTitle(name, path, mode)
; return

; --------------------------------- Tray Kısayolları ---------------------------------

#w::
    name := "WhatsApp"
    path := "shell:appsFolder\5319275A.WhatsAppDesktop_cv1g1gvanyjgm!WhatsAppDesktop"
    mode := 2
    OpenWindowByTitleInTray(name, path, mode)
return

#g::
    name := "GitHub Desktop"
    path := GetEnvPath("localappdata", "\GitHubDesktop\GitHubDesktop.exe")
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

#c::
    name := "Clockify"
    path := GetEnvPath("localappdata", "\Programs\Clockify\Clockify.exe")
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

#x::
    name := "Google Calendar"
    path := GetEnvPath("appdata", "\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Google Calendar.lnk")
    mode := 2
    OpenWindowByTitleInTray(name, path, mode)
return

#e::
    name := "CabinetWClass"
    path := "explorer.exe"
    OpenWindowByClassInTray(name, path)
return

; Dizin kısayolları PgDn ile başlar
PgDn & g::
    name := "GitHub"
    path := GetEnvPath("userprofile", "\Documents\GitHub")
    OpenWindowByTitleInTray(name, path)
return

PgDn & s::
    name := "ShareX"
    path := "shell:appsFolder\19568ShareX.ShareX_egrzcvs15399j!ShareX"
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

PgDn & Shift::
    name := "Startup"
    path := "shell:startup"
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

PgDn & i::
    name := "Icons"
    path := GetEnvPath("userprofile", "\Google Drive\Pictures\Icons")
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

PgDn & d::
    name := "Downloads"
    path := "shell:downloads"
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

PgDn & u::
    name := "Yunus Emre Ak"
    path := GetEnvPath("userprofile")
    mode := 3
    OpenWindowByTitleInTray(name, path, mode)
return

; --------------------------------- Buton Kısayolları ---------------------------------

; Değiştirilen butonları kurtarma
Control & PgDn::
    Send , !{PgDn}
return
Control & PgUp::
    Send , !{PgUp}
return
