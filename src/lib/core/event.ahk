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

RunUrl(url) {
    try {
        command = %ComSpec% /c ""explorer.exe" "%url%""
        RunWait, %command%, , hide
    }
}

CopySelected() {
    Send ^c
    Sleep, 100
}

; Seçili alan varsa onu, yoksa eski kopyalananı alma
GetExistClipboard() {
    value := TrimStr(clipboard)

    CopySelected()
    trimmed_clipboard := TrimStr(clipboard)
    if (StrLen(trimmed_clipboard) > 0) {
        return trimmed_clipboard
    } else if (StrLen(value) > 0) {
        return value
    } else {
        return False
    }
}

OpenInFileExplorer() {
    value := GetExistClipboard()
    if (value) {
        RunUrl(value)
    }
}

SearchOnGoogle() {
    value := GetExistClipboard()
    if (value) {
        RunUrl("http://www.google.com/search?q=" . value)
    }
}

TranslateOnGoogle() {
    value := GetExistClipboard()
    if (value) {
        RunUrl("https://translate.google.com/?hl=tr#view=home&op=translate&sl=auto&tl=tr&text=" . value)
    }
}

KeepOnNotepad() {
    CopySelected()

    RunUrl("notepad.exe")
    WinActivate, Untitled - Notepad
    WinWaitActive, Untitled - Notepad

    Send ^v

    ToggleWindowPin()
}

OpenDocumentationPage() {
    global APP_PAGE
    RunUrl(APP_PAGE)
}
