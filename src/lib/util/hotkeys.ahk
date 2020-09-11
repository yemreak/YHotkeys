; ####################################################################################
; ##                                                                                ##
; ##                                   KISAYOLLAR                                   ##
; ##                                                                                ##
; ####################################################################################

; https://windows.yemreak.com/autohotkey/diger-islemler#hotkeys-butonlari

#SingleInstance, Force
#KeyHistory, 0
#MaxThreadsPerHotkey, 1

#Include, %A_ScriptDir%\lib\core\common.ahk
#Include, %A_ScriptDir%\lib\core\event.ahk
#Include, %A_ScriptDir%\lib\core\menu.ahk
#Include, %A_ScriptDir%\lib\window\hide.ahk
#Include, %A_ScriptDir%\lib\window\pin.ahk

; ---------------------------------- Fast Hotkeys ----------------------------------

F1::TranslateWithPopup()
+F1::TranslateInline()
#Esc::CloseAllActivePrograms()

; ---------------------------------- Özellik Kısayolları ----------------------------------

!"::
    SwitchWindow()
return
#Space::
    ToggleWindowPin()
return

; -------------------------------- Seçili metni kullanma ---------------------------------

#^G::
    SearchOnGoogle()
return
#^E::
    OpenInFileExplorer()
return
#^C::
    OpenInCommandPrompt()
return
#^T::
    TranslateOnGoogle()
return
#^N::
    KeepOnNotepad()
return

#^F1::FullScreenWindow()

; -------------------------------- Seçili metni değiştirme ---------------------------------

#^+U::
    ToUpperCase()
return
#^+L::
    ToLowerCase()
return
#^+T::
    TranslateInline()
return
#^+I::
    ToInverted()
return
#^+E::
    ToEncode()
return
#^+D::
    ToDecode()
return

#F1::Suspend

; ----------------------------- Uygulamayı yeniden çalıştırma -------------------------------

#+e::Run, explorer

; ---------------------------------- Uygulama tetikleme ----------------------------------

; -------------- Göster / Gizle --------------

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

#p::
    name := "Your Phone"
    com := createAppCommand("Microsoft.YourPhone_8wekyb3d8bbwe!App")
    mode := 2
    OpenWindowByTitle(name, com, mode)
return

#m::
    name := "- Mail"
    com := createAppCommand("microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail")
    mode := 2
    OpenWindowByTitle(name, com, mode)
return

; -------------- Tray Kısayolları --------------

#"::
    name := "Notepad"
    com := "notepad"
    mode := 2
    OpenWindowInTray("class", name, com, mode)
return

#c::
    name := "Google Calendar"
    com := CreateStartProgramCmd("Google Calendar")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

#z::
    name := "BtcTurk | PRO"
    com := CreateStartProgramCmd("BTCTurk PRO")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

#SC056::
    name := "| Binance"
    com := CreateStartProgramCmd("Binance")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

#y::
    name := "YouTube"
    com := CreateStartProgramCmd("YouTube")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

#T::
    name := "Google Translate"
    com := CreateStartProgramCmd("Google Translate")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

#k::
    name := "Google Keep"
    com := CreateStartProgramCmd("Google Keep")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return

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

/* 
#t::
    name := "Telegram"
    com := createAppCommand("TelegramMessengerLLP.TelegramDesktop_t4vj0pshhgkwm!Telegram.TelegramDesktop.Store")
    mode := 2
    OpenWindowInTray("title", name, com, mode)
return 
*/

; -------------------------------- Özel Scriptler ---------------------------------

#^!+s::
    name := "ShareX"
    com := createAppCommand("19568ShareX.ShareX_egrzcvs15399j!ShareX")
    mode := 3
    OpenWindowInTray("title", name, com, mode)
return

; -------------------------------- Koşullu Kısayollar ---------------------------------

; WARN: En alta yazılmazsa sonrasındakilerin çalışmasını engeller, IfWındows yapılması gerekir

#If MouseIsOver("ahk_class Shell_TrayWnd") ; For MouseIsOver, see #If example 1.
    WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}
^WheelUp::Send {B}
^WheelDown::Send {Volume_Down}
#IfWinActive
