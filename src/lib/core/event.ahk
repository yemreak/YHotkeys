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

RunOnExplorer(url) {
	url := FixIfUrl(url)
	
    command = %ComSpec% /c ""explorer.exe" "%url%""
    RunWait, %command%, , hide
}

FixIfUrl(url) {
	if url not contains http
		If url contains www.,.com
			url := "http://" . url

	return url
}

RunCommand(url) {
    command = %ComSpec% /c "%url%"
    RunWait, %command%, , hide, ahkPID

    return ahkPID
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

uriEncode(str) {
	f = %A_FormatInteger%
	SetFormat, Integer, Hex
	If RegExMatch(str, "^\w+:/{0,2}", pr)
		StringTrimLeft, str, str, StrLen(pr)
	StringReplace, str, str, `%, `%25, All
	Loop
		If RegExMatch(str, "i)[^\w\.~%]", char)
			StringReplace, str, str, %char%, % "%" . Asc(char), All
		Else Break
	SetFormat, Integer, %f%
	Return, pr . str
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
