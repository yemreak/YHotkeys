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

#Persistent
SetTimer, Alert1, 500
return

A_DAY = 1000000

Alert1:
    IfWinNotExist, Video Conversion, Process Complete
    {
        ; Sayaç ile kontrol edip, günlük güncelleme yapılabilir
        ; Kullanıcı seçebilir
        MsgBox, % A_Now - A_DAY
        SetTimer, Alert1, Off
        ExitApp,
        return
    }
    ; Otherwise:
    SetTimer, Alert1, Off ; i.e. the timer turns itself off here.
    SplashTextOn, , , The video conversion is finished.
    Sleep, 3000
    SplashTextOff
return
