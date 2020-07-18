#SingleInstance, Force
#KeyHistory, 0
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; DetectHiddenWindows, On
; SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
; SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
; SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag

Check(verArray, tagArray, index) {
    if (index > verArray.Length()) {
        return False
    }
    
    if (verArray[index] < tagArray[index]) {
        return True
    } else if (verArray[index] == tagArray[index]) {
        return Check(verArray, tagArray, index + 1)
    }
    
    return False
}

UpdateExist(tagname) {
    tagArray := StrSplit(tagname, ".")
    
    VERSION = 2.3.1
    verArray := StrSplit(VERSION, ".")
    
    Loop % verArray.MaxIndex() {
        if (verArray[A_index] < tagArray[A_index]) {
            return True
        } else if (verArray[A_index] > tagArray[A_index]) {
            return False
        }
    }
    return False
}

out := UpdateExist("2.3.0")
MsgBox, % ""
