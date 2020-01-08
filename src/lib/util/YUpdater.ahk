; ####################################################################################
; ##                                                                                ##
; ##                              GÜNCELLEME ARACI                                  ##
; ##                                                                                ##
; ####################################################################################

; update.exe name version url silent_flag
; YUpdater.exe YHotkeys 1 https://api.github.com/repos/yedhrab/YHotkeys/releases/latest .

#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Uyumlukuk için A_ ön eki ile ortam değişkenlerini kullanın
#SingleInstance Force ; Sadece 1 kez açalıştırabilire
#KeyHistory 0 ; Tuş basımları loglamayı engeller

SetBatchLines, -1 ; Scripti sürekli olarak çalıştırma (nromalde her saniye 10ms uyur)
ListLines, On ; Derlenen verileri loglamaz

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxThreadsPerHotkey, 1 ; Yanlışlıkla 2 kere buton algılanmasını engeller

TEXT_DOWNLOAD_START := "⏱ Yükleme hazırlanıyor"
TEXT_DOWNLOADING := "✨ Yükleniyor..."

VERSION := "1.0.0"
TIP_MENU := "✨ YUpdater - Güncelleyici ~ YEmreAk (v" . VERSION . ")"

TITLE_TEXT_DOWNLOADING := "Yükleniyor"
ICON_TRAY := "..\..\res\update.ico"

RELEASE_TAGNAME := ""
RELEASE_TITLE := ""
RELEASE_BODY := ""
RELEASE_URL := ""

APP_NAME = 0
APP_VERSION = 0
APP_GITHUB_RELEASE_API = 0
APP_PATH = 0

FLAG_SILENT = 0

SetTrayMenu()
ParseArgs()
CheckForUpdates()
return

#Include, %A_ScriptDir%\json.ahk

SetTrayMenu() {
    global TIP_MENU, ICON_TRAY
    Menu, Tray, Tip, %TIP_MENU%
    If (FileExist(ICON_TRAY)) {
        Menu, Tray, Icon, %ICON_TRAY%
    }
}

ParseArgs() {
    global APP_NAME, APP_VERSION, APP_GITHUB_RELEASE_API, APP_PATH, FLAG_SILENT
    APP_NAME := A_Args[1]
    APP_VERSION := A_Args[2]
    APP_GITHUB_RELEASE_API := A_Args[3]
    APP_PATH := A_Args[4]
    FLAG_SILENT := A_Args[5]

    if not (APP_NAME and APP_VERSION and APP_GITHUB_RELEASE_API and APP_PATH) {
        global TIP_MENU
        MsgBox, 0, %TIP_MENU%, ❗ Eksik parametreler var: `n`n💎APP_NAME: %APP_NAME%`n💎APP_VERSION: %APP_VERSION%`n💎APP_GITHUB_RELEASE_API:%APP_GITHUB_RELEASE_API%`n💎APP_PATH:%APP_PATH%
        ExitApp
    }
}

HTTPRequest(requestType, url) {
    oHTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
    If !IsObject(oHTTP) {
        MsgBox,4112,Fatal Error,Unable to create HTTP object
        ExitApp
    }

    oHTTP.Open(requestType, url)
    oHTTP.SetAutoLogonPolicy(0) ; AutoLogonPolicy_Always=0, AutoLogonPolicy_OnlyIfBypassProxy=1, AutoLogonPolicy_Never=2
    oHTTP.Send()

    return JSON.Load(oHTTP.ResponseText)
}

DownloadFile(UrlToFile, SaveFileAs, Overwrite := True, UseProgressBar := True, ExpectedFileSize := 0) {
    ;Check if the file already exists and if we must not overwrite it
    If (!Overwrite && FileExist(SaveFileAs))
        Return
    ;Check if the user wants a progressbar
    If (UseProgressBar) {
        ;Initialize the WinHttpRequest Object
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        ;Download the headers
        WebRequest.Open("HEAD", UrlToFile)
        WebRequest.Send()

        try {
            ;Store the header which holds the file size in a variable:
            FinalSize := WebRequest.GetResponseHeader("Content-Length")
        } catch e {
            ; Cannot get "Content-Length" header
            FinalSize := ExpectedFileSize
        }

        global TEXT_DOWNLOAD_START
        ;Create the progressbar and the timer
        Progress, w250 h80, , %TEXT_DOWNLOAD_START%, %UrlToFile%

        LastSizeTick := 0
        LastSize := 0

        ; Enable progress bar updating if the system knows file size
        SetTimer, __UpdateProgressBar, 1500
    }

    ;Download the file
    UrlDownloadToFile, %UrlToFile%, %SaveFileAs%
    ;Remove the timer and the progressbar because the download has finished
    If (UseProgressBar) {
        Progress, Off
        SetTimer, __UpdateProgressBar, Off
    }
    Return

    ;The label that updates the progressbar
    __UpdateProgressBar:
        ;Get the current filesize and tick
        CurrentSize := FileOpen(SaveFileAs, "r").Length ;FileGetSize wouldn't return reliable results
        CurrentSizeTick := A_TickCount

        ;Calculate the downloadspeed
        SpeedOrig  := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000))

        SpeedUnit  := "KB/s"
        Speed      := SpeedOrig

        if (Speed > 1024) {
            ; Convert to megabytes
            SpeedUnit := "MB/s"
            Speed := Round(Speed/1024, 2)
        }

        SpeedText := Speed . " " . SpeedUnit

        ;Save the current filesize and tick for the next time
        LastSizeTick := CurrentSizeTick
        LastSize := FileOpen(SaveFileAs, "r").Length

        if FinalSize = 0
        {
            PercentDone := 50
        } else {
            ;Calculate percent done
            PercentDone := Round(CurrentSize/FinalSize*100)
            SpeedText := SpeedText . ", " . Round((FinalSize - CurrentSize) / SpeedOrig / 1024) . "s left"
        }

        ;Update the ProgressBar
        global TEXT_DOWNLOADING, TITLE_TEXT_DOWNLOADING
        Progress, %PercentDone%, %PercentDone%`% (%SpeedText%), %TEXT_DOWNLOADING%, %TITLE_TEXT_DOWNLOADING%; %SaveFileAs% (%PercentDone%`%)
    Return
}

StoreReleaseInfos(response) {
    tagname := response.tag_name
    name := response.name
    body := response.body
    download_url := response.assets[1].browser_download_url

    global RELEASE_TAGNAME, RELEASE_TITLE, RELEASE_BODY, RELEASE_URL
    RELEASE_TAGNAME := tagname
    RELEASE_TITLE := name . " ( " . tagname . " )"
    RELEASE_BODY := body
    RELEASE_URL := download_url
}

ShowUpdateDialog() {
    global RELEASE_TITLE, RELEASE_BODY, TIP_MENU, APP_VERSION, RELEASE_TAGNAME
    MsgBox, 4, %TIP_MENU%, %RELEASE_TITLE%`n`n%RELEASE_BODY% `n`n✨ Güncellemek ister misin? ( %APP_VERSION% -> %RELEASE_TAGNAME% )
    IfMsgBox Yes
        return True
    else
        return False
}

UpdateExist() {
    global RELEASE_TAGNAME, APP_VERSION
    return RELEASE_TAGNAME and APP_VERSION < RELEASE_TAGNAME
}

CheckForUpdates() {
    try {
        global APP_GITHUB_RELEASE_API
        response := HTTPRequest("GET", APP_GITHUB_RELEASE_API)
        OnResponse(response)
    }
}

OnResponse(response) {
    StoreReleaseInfos(response)

    global FLAG_SILENT
    if (UpdateExist()) {
        OnUpdateClick()
    } else if (not FLAG_SILENT) {
        global TIP_MENU
        MsgBox, 0, %TIP_MENU%, 👏 Zaten son sürümdesiniz`n💖 Günceli takip etmeniz ne hoş
    }
}

OnUpdateClick() {
    if (ShowUpdateDialog()) {
        UpdateApp()
    }
}

UpdateApp() {
    KillScript()

    global RELEASE_URL, APP_PATH
    DownloadFile(RELEASE_URL, APP_PATH)

    Run, %APP_PATH%

    global TIP_MENU
    MsgBox, 0, %TIP_MENU%, 👏 Güncelleme başarılı`n🌱 İmleci ikon üstüne getirerek yeni sürümü görebilirsiniz.
    ExitApp
}

KillScript() {
    global APP_NAME
    command := "taskkill /im " . APP_NAME . ".*"
    RunWait, %comspec% /c "%command%", , Hide
}
