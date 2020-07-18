; https://www.autohotkey.com/boards/viewtopic.php?t=28760

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

#w:: Focus("next") ; Goes down the z-order list (will wrap around like a cassete tape when it reaches the last window)
; 1,2,3,4,5 -> 4,3,2,1 -> 2,3,4,5 and so on.
#^w:: Focus("bot") ; Activates the Bottommost window in the z-order. Super arbitrary.
#+w:: Focus("recent") ; Toggle between your current window and the most recent one. Super useful.
#!w:: Focus(2) ; Activate the 2nd window in the alt-tab z-order. This is NOT equivelent to "recent"
; as some applications (magnifier, Alwaysontop things) will claim the #1 spot
; and your two apps are on numbers 2 and 3.

Focus(z){
   static past ; saves the last z parameter passed
   awesome := AltTabWindows()
   if (z = "next") {
      static awesome_next
      if (z != past || awesome_next >= awesome.length()) {
         current := WinActive("A")
         loop % awesome.length()
         {
            if (current = awesome[A_Index]) {
               awesome_next := A_Index+1
               WinActivate, % "ahk_id" awesome[awesome_next]
               break
            }
         }
      }
      else {
         WinActivate, % "ahk_id" awesome[++awesome_next]
      }
      past := z
   }
   else if (z = "bot") {
      past := z
      WinActivate, % "ahk_id" awesome.pop()
   }
   else if (z = "recent") {
      current := WinActive("A")
      i := 0
      loop % awesome.length()
      {
         if (current = awesome[A_Index]) {
            past := z
            WinActivate, % "ahk_id" awesome[A_Index+1]
            break
         }
      }
   }
   else {
      past := z
      WinActivate, % "ahk_id" awesome[z]
   }
   return
}

;es := WS_EX_TOPMOST
;next := "AltTabListID_" A_Index+1
;WinActivateBottom, % "ahk_id" (%next%)

AltTabWindows() {
   static WS_EX_TOPMOST := 0x8 ; sets the Always On Top flag
   static WS_EX_APPWINDOW := 0x40000 ; provides a taskbar button
   static WS_EX_TOOLWINDOW := 0x80 ; removes the window from the alt-tab list
   static GW_OWNER := 4
   
   AltTabList := {}
   windowList := ""
   DetectHiddenWindows, Off ; makes DllCall("IsWindowVisible") unnecessary
   WinGet, windowList, List ; gather a list of running programs
   Loop, %windowList%
   {
      ownerID := windowID := windowList%A_Index%
      Loop { ;If the window we found is opened by another application or "child", let's get the hWnd of the parent
         ownerID := Format("0x{:x}", DllCall("GetWindow", "UInt", ownerID, "UInt", GW_OWNER))
      } Until !Format("0x{:x}", DllCall("GetWindow", "UInt", ownerID, "UInt", GW_OWNER))
      ownerID := ownerID ? ownerID : windowID
      
      ; only windows that are not removed from the Alt+Tab list, AND have a taskbar button, will be appended to our list.
      If (Format("0x{:x}", DllCall("GetLastActivePopup", "UInt", ownerID)) = windowID)
      {
         WinGet, es, ExStyle, ahk_id %windowID%
         If (!((es & WS_EX_TOOLWINDOW) && !(es & WS_EX_APPWINDOW)) && !IsInvisibleWin10BackgroundAppWindow(windowID))
            AltTabList.Push(windowID)
      }
   }
   
   ; UNCOMMENT THIS FOR TESTING
   ;WinGetClass, class1, % "ahk_id" AltTabList[1]
   ;WinGetClass, class2, % "ahk_id" AltTabList[2]
   ;WinGetClass, classF, % "ahk_id" AltTabList.pop()
   ;msgbox % "Number of Windows: " AltTabList.length() "`nFirst windowID: " class1 "`nSecond windowID: " class2 "`nFinal windowID: " classF
   return AltTabList
}

IsInvisibleWin10BackgroundAppWindow(hWindow) {
   result := 0
   VarSetCapacity(cloakedVal, A_PtrSize) ; DWMWA_CLOAKED := 14
   hr := DllCall("DwmApi\DwmGetWindowAttribute", "Ptr", hWindow, "UInt", 14, "Ptr", &cloakedVal, "UInt", A_PtrSize)
   if !hr ; returns S_OK (which is zero) on success. Otherwise, it returns an HRESULT error code
      result := NumGet(cloakedVal) ; omitting the "&" performs better
   return result ? true : false
}

  /*
  DWMWA_CLOAKED: If the window is cloaked, the following values explain why:
  1  The window was cloaked by its owner application (DWM_CLOAKED_APP)
  2  The window was cloaked by the Shell (DWM_CLOAKED_SHELL)
  4  The cloak value was inherited from its owner window (DWM_CLOAKED_INHERITED)
*/
