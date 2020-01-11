; Copyright [2019] [Yunus Emre Ak]
;
;    Licensed under the Apache License, Version 2.0 (the "License");
;    you may not use this file except in compliance with the License.
;    You may obtain a copy of the License at
;
;        http://www.apache.org/licenses/LICENSE-2.0
;
;    Unless required by applicable law or agreed to in writing, software
;    distributed under the License is distributed on an "AS IS" BASIS,
;    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;    See the License for the specific language governing permissions and
;    limitations under the License.

; ####################################################################################
; ##                                                                                ##
; ##                           YHotkeys Kısayol Yönetici                            ##
; ##                                                                                ##
; ####################################################################################

; v1.1.31.01'de tüm desktoplarda çalışır
; https://www.autohotkey.com/download/1.1/AutoHotkey_1.1.31.01_setup.exe

#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Uyumlukuk için A_ ön eki ile ortam değişkenlerini kullanın
#SingleInstance Force ; Sadece 1 kez açalıştırabilire
#KeyHistory 0 ; Tuş basımları loglamayı engeller

SetBatchLines, -1 ; Scripti sürekli olarak çalıştırma (nromalde her saniye 10ms uyur)
ListLines, On ; Derlenen verileri loglamaz

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; Yanlışlıkla 2 kere buton algılanmasını engeller

OnExit("ExitFunc")

#Include, %A_ScriptDir%\lib\core\config.ahk

CreateOrUpdateTrayMenu()

if not DEBUG {
    CheckForUpdate(True)
}

return

#Include, %A_ScriptDir%\lib\core\common.ahk
#Include, %A_ScriptDir%\lib\core\event.ahk
#Include, %A_ScriptDir%\lib\core\menu.ahk
#Include, %A_ScriptDir%\lib\window\focus.ahk
#Include, %A_ScriptDir%\lib\window\hide.ahk
#Include, %A_ScriptDir%\lib\window\pin.ahk
#Include, %A_ScriptDir%\lib\util\hotkeys.ahk
#Include, %A_ScriptDir%\lib\util\yemoji.ahk
#Include, %A_ScriptDir%\lib\util\fullscreen.ahk

ExitFunc(exitReason, exitCode) {
    if exitReason not in Logoff,Shutdown
    {
        ShowAllHiddenWindows()
        ReleaseAllPinnedWindows()
        return 0
    }
}

