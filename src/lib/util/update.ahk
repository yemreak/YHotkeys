#Include, %A_ScriptDir%\lib\util\json.ahk

HTTPRequest(requestType, url) {
    oHTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
    If !IsObject(oHTTP) {
        MsgBox,4112,Fatal Error,Unable to create HTTP object
        ExitApp
    }

    oHTTP.Open(requestType, URL)
    oHTTP.SetAutoLogonPolicy(0) ; AutoLogonPolicy_Always=0, AutoLogonPolicy_OnlyIfBypassProxy=1, AutoLogonPolicy_Never=2
    oHTTP.Send()

    return JSON.Load(oHTTP.ResponseText)
}

UpdateApp(force=false) {
    if (force) {
        global NEWEST_URL
        downloadUrl := NEWEST_URL
    } else {
        global RELEASE_URL
        url := RELEASE_URL

        response := HTTPRequest("GET", url)
        tagname := response.tag_name

        global VERSION
        if (tagname == VERSION) {
            MsgBox, Zaten yeni -_-
            return
        }

        assetURL := response.assets_url
        response := HTTPRequest("GET", assetURL)
        downloadUrl := response[1].browser_download_url
    }

    global FILENAME
    MsgBox, Yenileniyor...
    UrlDownloadToFile, %downloadUrl%, %FILENAME%
    MsgBox, Yenilendi :)
}
