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

#n::
    selector := "Notepad"
    com := "notepad"
    mode := 2
    OpenWindowInTray("class", selector, com, mode)
return

#"::
    selector := "Notion.exe"
    excludes := ["MSCTFIME","Default IME"]
    com := CreateStartProgramCmd("Notion")
    mode := 3
    OpenWindowInTray("exe", selector, com, mode, excludes)
return

#c::
    selector := "Google Calendar"
    com := CreateStartProgramCmd("Google Calendar")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
return

#z::
    selector := "BtcTurk PRO"
    com := CreateStartProgramCmd("BtcTurk | PRO")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
return

#SC056::
    selectors := ["| Binance", "Binance Spot"]
    com := CreateStartProgramCmd("Binance")
    mode := 2
    OpenWindowInTray("title", selectors, com, mode)
return

#y::
    selector := "YouTube"
    com := CreateStartProgramCmd("YouTube")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
return

#T::
    selector := "Google Translate"
    com := CreateStartProgramCmd("Google Translate")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
return

#k::
    selector := "Google Keep"
    com := CreateStartProgramCmd("Google Keep")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
return

; #"::
;     selector := "WindowsTerminal.exe"
;     com := createAppCommand("Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"
;     mode := 2
;     OpenWindowInTray("exe", selector, com, mode)
; return

#w::
    selector := "WhatsApp"
    com := createAppCommand("5319275A.WhatsAppDesktop_cv1g1gvanyjgm!WhatsAppDesktop")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
return

#g::
    selector := "GitHub Desktop"
    com := GetEnvPath("localappdata", "\GitHubDesktop\GitHubDesktop.exe")
    mode := 3
    OpenWindowInTray("title", selector, com, mode)
return

#e::
    selector := "CabinetWClass"
    com := "explorer.exe"
    OpenWindowInTray("class", selector, com)
return

/* 
#t::
    selector := "Telegram"
    com := createAppCommand("TelegramMessengerLLP.TelegramDesktop_t4vj0pshhgkwm!Telegram.TelegramDesktop.Store")
    mode := 2
    OpenWindowInTray("title", selector, com, mode)
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
