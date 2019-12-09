#Include, %A_ScriptDir%\..\lib\util\json.ahk

URL = https://api.github.com/repos/yedhrab/YHotkeys/releases/latest

oHTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
If !IsObject(oHTTP)
{
  MsgBox,4112,Fatal Error,Unable to create HTTP object
  ExitApp
}

oHTTP.Open("GET", URL)
oHTTP.SetAutoLogonPolicy(0) ; AutoLogonPolicy_Always=0, AutoLogonPolicy_OnlyIfBypassProxy=1, AutoLogonPolicy_Never=2
oHTTP.Send()

Response := oHTTP.ResponseText
parsed := JSON.Load(Response)
tagname := parsed.tag_name
MsgBox, %tagname%
