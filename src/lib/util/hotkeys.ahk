; ####################################################################################
; ##                                                                                ##
; ##                                   KISAYOLLAR                                   ##
; ##                                                                                ##
; ####################################################################################

; https://windows.yemreak.com/autohotkey/diger-islemler#hotkeys-butonlari

#SingleInstance, Force
#KeyHistory, 0
#MaxThreadsPerHotkey, 1

SetBatchLines, -1
ListLines, Off

return

; ---------------------------------- Özellik Kısayolları ----------------------------------

#Space::
    ToggleWindowPin()
return
#^G::
    SearchOnGoogle()
return
#^E::
    OpenInFileExplorer()
return
#^T::
    TranslateOnGoogle()
return
#^N::
    KeepOnNotepad()
return
!"::
    SwitchWindow()
return

#F1::Suspend

; ---------------------------------- Çalıştır ----------------------------------

#+e::Run, explorer

; ---------------------------------- Göster / Gizle ----------------------------------
; WARN: - olmazsa hata oluşmakta

#q::
    name := "- OneNote"
    com := createAppCommand("Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim")
    mode := 2
    OpenWindowByTitle(name, com, mode)
return

#x::
    name := "- Calendar"
    com := createAppCommand("microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar")
    mode := 2
    OpenWindowByTitle(name, com, mode)
return

#c::
    ; BUG: Hesap makinesi tekrardan açılmıyor
    name := "Calculator"
    com := createAppCommand("Microsoft.WindowsCalculator_8wekyb3d8bbwe!App")
    mode := 2
    OpenWindowByTitle(name, com, mode)
return


; #t::
;     name := "Tureng Dictionary"
;     com := createAppCommand("24232AlperOzcetin.Tureng_9n2ce2f97t3e6!App"
;     mode := 2
;     OpenWindowByTitle(name, com, mode)
; return

; --------------------------------- Tray Kısayolları ---------------------------------

; #"::
;     name := "WindowsTerminal.exe"
;     com := createAppCommand("Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"
;     mode := 2
;     OpenWindowInTray("exe", name, com, mode)
; return

#w::
    name := "WhatsApp"
    com := createAppCommand("5319275A.WhatsAppDesktop_cv1g1gvanyjgm!WhatsAppDesktop")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

#g::
    name := "GitHub Desktop"
    com := GetEnvPath("localappdata", "\GitHubDesktop\GitHubDesktop.exe")
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

#e::
    name := "CabinetWClass"
    com := "explorer.exe"
    OpenWindowInTray("class", name, com)
return

; --------------------------------- Dizin Kısayolları ---------------------------------

; Dizin kısayolları PgDn ile başlar
PgDn & g::
    name := "GitHub"
    com := GetEnvPath("userprofile", "\Documents\GitHub")
    OpenWindowInTray("title", name, com)
return

PgDn & s::
    name := "ShareX"
    com := createAppCommand("19568ShareX.ShareX_egrzcvs15399j!ShareX")
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

PgDn & Shift::
    name := "Startup"
    com := "shell:startup"
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

PgDn & i::
    name := "Icons"
    com := GetEnvPath("userprofile", "\Google Drive\Pictures\Icons")
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

PgDn & d::
    name := "Downloads"
    com := "shell:downloads"
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

PgDn & u::
    name := "Yunus Emre Ak"
    com := GetEnvPath("userprofile")
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

; --------------------------------- Buton Kısayolları ---------------------------------

; Değiştirilen butonları kurtarma
Control & PgDn::
    Send , !{PgDn}
return
Control & PgUp::
    Send , !{PgUp}
return

; -------------------------------- Koşullu Kısayollar ---------------------------------
; WARN: En alta yazılmazsa sonrasındakilerin çalışmasını engeller, IfWındows yapılması gerekir

#If MouseIsOver("ahk_class Shell_TrayWnd") ; For MouseIsOver, see #If example 1.
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}
^WheelUp::Send {B}
^WheelDown::Send {Volume_Down}
#IfWinActive
