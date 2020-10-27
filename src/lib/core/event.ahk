; ####################################################################################
; ##                                                                                ##
; ##                                  EYLEMLER                                      ##
; ##                                                                                ##
; ####################################################################################

#Include, %A_ScriptDir%\lib\util\translate.ahk
#Include, %A_ScriptDir%\lib\util\fullscreen.ahk

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
return

#IfWinExist ahk_class tooltips_class32
ESC::
~LButton::
~RButton::
    ToolTip
return
#IfWinActive

RunOnExplorer(url) {
    url := FixIfUrl(url)

    command := ExplorerCommand(url)
    command := ConsoleCommand(command)
    RunWait, %command%, , hide
}

ConsoleCommand(command) {
    cmd = %ComSpec% /c "%command%"
return cmd
}

ExplorerCommand(url) {
return "explorer.exe """ . url . """"
}

FixIfUrl(url) {
    if url not contains http
        If url contains www.,.com
        url := "http://" . url

return url
}

RunHide(command) {
    Run, %command%, , hide, ahkPID
return ahkPID
}

RunOnConsole(command) {
    command := ConsoleCommand(command)
return RunHide(command)
}

CopySelected() {
    Send ^c
    Sleep, 100
}

SendFast(string) {
    Clipboard := string
    Send, ^v
}

ToRegex(mode) {
    CopySelected()
    SendFast(RegExReplace(Clipboard, "(.*)", mode))
}

ToUpperCase() {
    ToRegex("$U1")
}

ToLowerCase() {
    ToRegex("$L1")
}

ToTitleCase() {
    ToRegex("$T1")
}

ToDecode() {
    CopySelected()
    SendFast(uriDecode(Clipboard))
}

ToEncode() {
    CopySelected()
    SendFast(uriEncode(Clipboard))
}

uriDecode(str) {
    Loop
        If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
        StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
    Else Break
        Return, str
}

ToInverted() {
    CopySelected()
    Lab_Invert_Char_Out:= ""
    Loop % Strlen(Clipboard) {
        Lab_Invert_Char:= Substr(Clipboard, A_Index, 1)
        if Lab_Invert_Char is upper
            Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) + 32)
        else if Lab_Invert_Char is lower
            Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) - 32)
        else
            Lab_Invert_Char_Out:= Lab_Invert_Char_Out Lab_Invert_Char
    }
    SendFast(Lab_Invert_Char_Out)
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

OpenInCommandPrompt() {
    value := GetExistClipboard()
    RunWait, %ComSpec% /k cd %value%
}

OpenInFileExplorer() {
    value := GetExistClipboard()
    RunOnExplorer(value)
}

SearchOnGoogle() {
    value := GetExistClipboard()
    RunOnExplorer("http://www.google.com/search?q=" . value)
}

TranslateOnGoogle() {
    value := GetExistClipboard()
    RunOnExplorer("https://translate.google.com/?hl=tr#view=home&op=translate&sl=auto&tl=tr&text=" . value)
}

TranslateWithPopup() {
    value := GetExistClipboard()
    ToolTip, % GoogleTranslate(value, "auto", "tr")
}

TranslateInline() {
    value := GetExistClipboard()
    results := GoogleTranslate(value, "auto", "tr")
    resultArray := StrSplit(results, "`n")
    SendFast(resultArray[1])
}

KeepOnNotepad() {
    CopySelected()

    Run, notepad.exe
    WinActivate, Untitled - Notepad
    WinWaitActive, Untitled - Notepad

    Send ^v

    ToggleWindowPin()
}

OpenDocumentationPage() {
    global APP_PAGE
    RunOnExplorer(APP_PAGE)
}

FullScreenWindow() {
    FWT()
}

EdgeAppCommand(appId) {
return """C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"" --profile-directory=Default --app-id=" . appId
}

CreateGoogleSearchUrl(query) {
return "https://www.google.com/search?q=" . query
}

CreateStartProgramCmd(name) {
    filepath = %A_AppData%\Microsoft\Windows\Start Menu\Programs\%name%.lnk
    if FileExist(filepath) {
        return ExplorerCommand(filepath)
    }
    else {
        return ExplorerCommand(CreateGoogleSearchUrl(name)) 
    }
}

CloseAllActivePrograms() {
    Run, powershell -Command "Get-Process | Where-Object {$_.MainWindowTitle -ne """"""} | stop-process", ,hide
}
