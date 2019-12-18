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

StoreReleaseInfos(tagname, body) {
    global RELEASE_TAGNAME, RELEASE_BODY
    RELEASE_TAGNAME := tagname
    RELEASE_BODY := body
}

ShowUpdateDialog() {
    global RELEASE_TAGNAME, RELEASE_BODY
    if RELEASE_TAGNAME and RELEASE_BODY {
        MsgBox, 4,🌟 %RELEASE_TAGNAME% sürümü mevcut, %RELEASE_BODY% `n`nGüncellemek ister misin?
        IfMsgBox Yes
            return True
        else
            return False
    } else {
        return False
    }
}

CheckForUpdates() {
    try {
        global API_RELEASE
        response := HTTPRequest("GET", API_RELEASE)

        tagname := response.tag_name
        body := response.body
        if (tagname) {
            global VERSION
            if (UpdateExist(tagname)) {
                StoreReleaseInfos(tagname, body)
                if (ShowUpdateDialog()) {
                    assets := response.assets
                    downloadURL := assets[1].browser_download_url

                    global FILENAME
                    FileSelectFile, downlaodLocation, S, %FILENAME%
                    if (downlaodLocation) {
                        DownloadFile(downloadUrl, downlaodLocation)
                    }
                }
            }
        }
    }
}

UpdateApp() {
    if (ShowUpdateDialog()) {
        global FILENAME, RELEASE_URL
        FileSelectFile, downlaodLocation, S, %FILENAME%
        if (downlaodLocation) {
            DownloadFile(RELEASE_URL, downlaodLocation)
        }
    }
}

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

    global VERSION
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
