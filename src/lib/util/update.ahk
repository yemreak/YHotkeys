; ####################################################################################
; ##                                                                                ##
; ##                              GÜNCELLEME ARACI                                  ##
; ##                                                                                ##
; ####################################################################################

#Include, %A_ScriptDir%\lib\util\json.ahk

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
    body := response.body
    download_url := response.assets[1].browser_download_url

    global RELEASE_TAGNAME, RELEASE_BODY, RELEASE_URL
    RELEASE_TAGNAME := tagname
    RELEASE_BODY := body
    RELEASE_URL := download_url
}

ShowUpdateDialog() {
    global RELEASE_TAGNAME, RELEASE_BODY
    MsgBox, 4,🌟 %RELEASE_TAGNAME% sürümü mevcut, %RELEASE_BODY% `n`nGüncellemek ister misin?
    IfMsgBox Yes
        return True
    else
        return False
}

UpdateExist() {
    global VERSION, RELEASE_TAGNAME
    return RELEASE_TAGNAME and VERSION < RELEASE_TAGNAME
}

CheckForUpdates() {
    try {
        global API_RELEASE
        response := HTTPRequest("GET", API_RELEASE)
        OnResponse(response)
    }
}

OnResponse(response) {
    StoreReleaseInfos(response)

    if (UpdateExist()) {
        if (ShowUpdateDialog()) {
            UpdateApp()
        }
    }
}

OnUpdateClick() {
    if (ShowUpdateDialog()) {
        UpdateApp()
    }
}

UpdateApp() {
    global FILENAME, RELEASE_URL
    FileSelectFile, downlaodLocation, S, %FILENAME%

    if (downlaodLocation) {
        if (downlaodLocation == A_ScriptFullPath) {
            MsgBox, 0, 😥 Yol hatalı, 🚩 Lütfen scriptin yolundan farklı bir yol seçin
            UpdateApp()
        } else {
            DownloadFile(RELEASE_URL, downlaodLocation)
            Run, %downlaodLocation%
            MsgBox, 0, 👏 Güncelleme başarılı, 🌱 İmleci ikon üstüne getirerek yeni sürümü görebilirsiniz.
            ExitApp
        }
    }
}
