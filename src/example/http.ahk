URL := "https://translate.google.com/?hl=tr#view=home&op=translate&sl=auto&tl=tr&text=" . Clipboard

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
MsgBox, %Response%
