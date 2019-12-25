; ####################################################################################
; ##                                                                                ##
; ##                                  EYLEMLER                                      ##
; ##                                                                                ##
; ####################################################################################

return

IconClicked:
    ToggleMemWindowWithTitle(A_ThisMenuItem)
return

ClearAll:
    ClearAllHiddenWindows()
return

OnDocumentationClicked:
    OpenDocumentationPage()
return

OnHotkeysClicked:
    MsgBox, 😥 Henüz desteklenmemekte
return

CheckForUpdate:
    CheckForUpdate()
return

ShowAll:
    ShowAllHiddenWindows()
return

CloseApp:
    ExitApp
Return

OpenInFileExplorer() {
    Send ^c
    Sleep, 100
    RunWait, explorer.exe %clipboard%
}

SearchOnGoogle() {
    Send ^c
    Sleep, 100
    Run "http://www.google.com/search?q=%clipboard%"
}

TranslateOnGoogle() {
    Send ^c
    Sleep, 100
    Run "https://translate.google.com/?hl=tr#view=home&op=translate&sl=auto&tl=tr&text=%clipboard%"
}

KeepOnNotepad() {
    Send ^c
    Run, notepad.exe
    WinActivate, Untitled - Notepad
    WinWaitActive, Untitled - Notepad
    Send ^v
    ToggleWindowPin()
}

OpenDocumentationPage() {
    global APP_PAGE
    Run, %APP_PAGE%
}
