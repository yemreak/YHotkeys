; ####################################################################################
; ##                                                                                ##
; ##                                   KISAYOLLAR                                   ##
; ##                                                                                ##
; ####################################################################################

; ---------------------------------- Özellik Kısayolları ----------------------------------
return

#Space::
    ToggleWindowPin()
return
#+G::
    Send ^c
    Sleep, 100
    Run "http://www.google.com/search?q=%clipboard%"
return
#+T::
    Send ^c
    Sleep, 100
    Run "https://translate.google.com/?hl=tr#view=home&op=translate&sl=auto&tl=tr&text=%clipboard%"
return
#+N::
    Send ^c
    Run, notepad.exe
    WinActivate, Untitled - Notepad
    WinWaitActive, Untitled - Notepad
    Send ^v
    ToggleWindowPin()
return

return

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
