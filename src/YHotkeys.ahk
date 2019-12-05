; v1.1.31.01'de tüm desktoplarda çalışır

#NoEnv  ; Uyumlukuk için A_ ön eki ile ortam değişkenlerini kullanın
#SingleInstance Force ; Sadece 1 kez açalıştırabilire

#KeyHistory 0 ; Tuş basımları loglamayı engeller

SetBatchLines, -1 ; Scripti sürekli olarak çalıştırma (nromalde her saniye 10ms uyur)
ListLines, On ; Derlenen verileri loglamaz

#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; Yanlışlıkla 2 kere buton algılanmasını engeller

OnExit("ExitFunc")

DIR_NAME = %A_AppData%\YHotkeys
VERSION = 2.1.0

; Gizlenmiş pencelerin ID'si
HidedWindows := []

InstallIcons(DIR_NAME)
CreateOrUpdateTrayMenu(DIR_NAME, HidedWindows, VERSION)
return

#Include, %A_ScriptDir%\lib\common.ahk
#Include, %A_ScriptDir%\lib\menu.ahk
#Include, %A_ScriptDir%\lib\memory.ahk
#Include, %A_ScriptDir%\lib\window.ahk
#Include, %A_ScriptDir%\lib\emoji.ahk

IconClicked:
    ToggleMemWindowWithTitle(A_ThisMenuItem)
Return

ClearAll:
    ClearAllHidedWindows()
Return

ShowAll:
    ShowAllHiddenWindows()
return


CloseApp:
    ExitApp
Return

ExitFunc(exitReason, exitCode) {
    if exitReason not in Logoff,Shutdown
    {
        ShowAllHiddenWindows()
        return 0
    }
}

OpenWindowInTray(selector, name, url, mode=3) {
    SetTitleMatchMode, %mode%
    DetectHiddenWindows, On

    IDlist := []
    if (selector == "title") {
        WinGet, IDlist, list, %name%
    } else if (selector == "class") {
        WinGet, IDlist, list, ahk_class %name%
    } else if (selector == "exe") {
        WinGet, IDlist, list, ahk_exe %name%
    }

    found := False
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

ShowAllHiddenWindows() {
    ahkIDs := GetHidedWindowsIDs()
    For index, ahkID in ahkIDs {
        ToggleWindowWithID(ahkID, True)
    }

    return ahkIDs
}

ClearAllHidedWindows() {
    global HidedWindows, DIR_NAME, VERSION

    DetectHiddenWindows, On

    ahkIDs := GetHidedWindowsIDs()
    For index, ahkID in ahkIDs {
        WinKill, ahk_id %ahkID%
        WinWaitClose, ahk_id %ahkID%
    }

    HidedWindows := []
    CreateOrUpdateTrayMenu(DIR_NAME, HidedWindows, VERSION)

}

ToggleMemWindowWithTitle(menuName) {
    ahkID := GetHidedWindowsIDWithTitle(menuName)
    if ahkID
        ToggleWindowWithID(ahkID, True)
    else
        Run https://github.com/yedhrab/YHotkeys
}

ToggleWindowWithID(ahkID, hide=False) {
    global HidedWindows, DIR_NAME, VERSION

    DetectHiddenWindows, Off
    if !WinExist("ahk_id" . ahkID) {
        if hide {
            if DropFromMem(ahkID, HidedWindows){
                DropWindowFromTrayMenu(ahkID, HidedWindows)
                CreateOrUpdateTrayMenu(DIR_NAME, HidedWindows, VERSION)
            }
            ShowHidedWindowWithID(ahkID)
        }
        ActivateWindowWithID(ahkID)
    } else {
        if WinActive("ahk_id" . ahkID) {
            if hide {
                KeepWindowInMem(ahkID)
                FocusPreviusWindow(ahkID)
                SendWindowToTrayByID(ahkID)
                CreateOrUpdateTrayMenu(DIR_NAME, HidedWindows, VERSION)
            } else {
                WinMinimize, A
            }
        } else {
            ActivateWindowWithID(ahkID)
        }
    }
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
;     ;     name := "Tureng Dictionary"
;     path := "shell:appsFolder\24232AlperOzcetin.Tureng_9n2ce2f97t3e6!App"
;     mode := 2
;     OpenWindowByTitle(name, path, mode)
; return

; --------------------------------- Tray Kısayolları ---------------------------------

#w::
    ; WARN: 4 tane var exe ile ele alınmalı WhatsApp.exe (bundan değil)
    name := "WhatsApp"
    path := "shell:appsFolder\5319275A.WhatsAppDesktop_cv1g1gvanyjgm!WhatsAppDesktop"
    mode := 2
    OpenWindowInTray("title", name, path, mode)
return

#g::
    name := "GitHub Desktop"
    path := GetEnvPath("localappdata", "\GitHubDesktop\GitHubDesktop.exe")
    mode := 3
    OpenWindowInTray("title", name, path, mode)
return

#x::
    name := "Google Calendar"
    path := GetEnvPath("appdata", "\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Google Calendar.lnk")
    mode := 2
    OpenWindowInTray("title", name, path, mode)
return

#e::
    name := "CabinetWClass"
    path := "explorer.exe"
    OpenWindowInTray("class", name, path)
return

; Dizin kısayolları PgDn ile başlar
PgDn & g::
    name := "GitHub"
    path := GetEnvPath("userprofile", "\Documents\GitHub")
    OpenWindowInTray("title", name, path)
return

PgDn & s::
    name := "ShareX"
    path := "shell:appsFolder\19568ShareX.ShareX_egrzcvs15399j!ShareX"
    mode := 3
    OpenWindowInTray("title", name, path, mode)
return

PgDn & Shift::
    name := "Startup"
    path := "shell:startup"
    mode := 3
    OpenWindowInTray("title", name, path, mode)
return

PgDn & i::
    name := "Icons"
    path := GetEnvPath("userprofile", "\Google Drive\Pictures\Icons")
    mode := 3
    OpenWindowInTray("title", name, path, mode)
return

PgDn & d::
    name := "Downloads"
    path := "shell:downloads"
    mode := 3
    OpenWindowInTray("title", name, path, mode)
return

PgDn & u::
    name := "Yunus Emre Ak"
    path := GetEnvPath("userprofile")
    mode := 3
    OpenWindowInTray("title", name, path, mode)
return

; --------------------------------- Buton Kısayolları ---------------------------------

; Değiştirilen butonları kurtarma
Control & PgDn::
    Send , !{PgDn}
return
Control & PgUp::
    Send , !{PgUp}
return
