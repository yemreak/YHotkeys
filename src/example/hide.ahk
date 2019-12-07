/*
HideWinList, by Zusukar
Originally Autohide by Charon the Hand.

This script hides a window with {Win}Q. {Win}W brings up a listview with icons showing the windows that
have been hidden. You can select one by double clicking its row or highlighting the row with arrow keys and
hitting {Enter}. The script will keep a list of windows currently hidden; if it exits for any reason other
than system shutdown, it writes the names of hidden windows to an .ini file. On restarting, the script reads
those values and rebuilds the listview. {Win}F7 exits the script (mostly for testing purposes). The hotkeys
are customizable. The colors of the listview (background, border, text) are customizable. Currently you can
hide 10 windows, but that too is customizable if necessary.

Credit to evl for his Alt-Tab Replacement, from which I borrowed the DllCall code to retrieve icons and much
help in building listviews. Also to the author (can't find his/her name anywhere) of Minimize Window to Tray
Menu from the script showcase for the trick of raising the next window in the z-order when hiding.

Credit to Sean for his GetTextExtentPoint function that determines text height and width.  This has been
modified to only return the width.
(http://www.autohotkey.com/forum/post-113847.html&sid=cb1840004443b42e1a730db24896b406#113847)
*/

#KeyHistory 0
#NoEnv
#NoTrayIcon
#InstallKeybdHook
#SingleInstance Force
DetectHiddenWindows On
SetTitleMatchMode 3
CoordMode, Mouse
OnExit, ch_Exit
OnMessage( 0x06, "ch_WM_ACTIVATE" )

;================================Variables================================;

ch_hotkeyHide := "#q"                     ;{Win}q
ch_hotkeyShow := "#w"                     ;{Win}w
ch_hotkeyExit := "#F7"                    ;{Win}F7
ch_maxWindows := 10
ch_bgColor := "EBEBEB"
ch_borderColor := "000000"
ch_textColor := "191919"
ch_textFont := "Microsoft Sans Serif"
ch_totalWindows := 0

;===============================Autoexecute===============================;

ch_LoadFromIni()
Hotkey, %ch_hotkeyHide%, ch_HideActiveWindow
Hotkey, %ch_hotkeyShow%, ch_ShowWindow
Hotkey, %ch_hotkeyExit%, ch_Exit
return

;=================================HotKeys=================================;


;===============================Subroutines===============================;

ch_HideActiveWindow:
  WinGetClass, ch_winClass, A
  If ch_winClass in Progman,Shell_TrayWnd
    return
  WinGet, ch_winId, Id, A
  Send, !{Esc}
  ch_HideWindow(ch_winId)
  return

ch_ShowWindow:
  If ch_totalWindows = 0
    return
  MouseGetPos, ch_xpos, ch_ypos            ;put LV right under the mouse
  ch_xpos -= 10
  ch_ypos -= 10
  ch_BuildListView()
  if ch_totalWindows > 0
    Gui, Show, x%ch_xpos% y%ch_ypos%
  return

ch_Exit:
  If A_ExitReason in Shutdown,Exit         ;if shutting down the computer, skip
    ExitApp
  ch_SaveToIni()                           ;if closing for any other reason, save hidden windows
  ExitApp

ch_LVMenu:
  If A_GuiEvent = DoubleClick               ;restore window on double-click
    ch_RestoreWindow(A_EventInfo)
  return

ButtonOK:                                  ;restore window on {Enter}
  GuiControlGet, ch_FocusedControl, FocusV
  If ch_FocusedControl <> ch_LVMenu
  {
    ch_FocusedControl :=
    return
  }
  else
  {
    ch_FocusedControl :=
    ch_RestoreWindow(LV_GetNext(0, "Focused"))
  }
  return

GUIEscape:
  GUI, Destroy
  return

;================================Functions================================;

ch_HideWindow(ch_winId)
{
  global
  local ch_stored := 0
  Loop, %ch_maxWindows%
  {
    If ch_winId%A_Index% =                ;find an empty variable and put the window ID in
    {
      ch_winId%A_Index% := ch_winId
      ch_totalWindows += 1
      ch_stored := 1
      Break
    }
  }
  If ch_stored = 1
    WinHide, ahk_id %ch_winId%
  return
}

ch_SaveToIni()
{
  global
  local this_id
  Loop, %ch_maxWindows%                  ;store currently
  {                                      ;hidden windows in ini file for restoration later
    this_id := ch_winId%A_Index%
    IfWinNotExist, ahk_id %this_id%
      continue
    If ch_winId%A_Index% =
      continue
    IniWrite, % ch_winId%A_Index%, HideWinList.ini, Window%A_Index%, WinId
  }
  return
}

ch_LoadFromIni()
{
  global
  local this_id
  Loop, %ch_maxWindows%                     ;read the ini file to see if there are any
  {                                         ;windows to be restored, then erase contents
    IniRead, this_id, HideWinList.ini, Window%A_Index%, WinId
    If this_id = ERROR
      continue
    IniDelete, HideWinList.ini, Window%A_Index%
    IfWinNotExist, ahk_id %this_id%
      continue
    ch_HideWindow(this_id)
  }
  return
}

ch_WM_ACTIVATE(ch_wParam)
{
  If (ch_wParam = 0)                      ;if the listview loses focus, hide it
    Gui, Destroy
  return
}

ch_BuildListView()
{
  global
  Gui, Destroy
  ch_GetLongestName()
  If ch_longestName = 0
    return
  Gui, Color, %ch_borderColor%, %ch_bgColor%
  Gui, Margin, 1,1
  Gui, +ToolWindow -Caption
  Gui, Font, s12 c%ch_textColor%, %ch_textFont%
  Gui, Add, ListView, Report -Hdr r%ch_totalWindows% w%ch_longestName% Count%ch_totalWindows% gch_LVMenu vch_LVMenu, ||
  ch_longestName :=

  ;invisible OK button, so you can use {Enter} to select
  Gui, Add, Button, w0 h0 x0 y-1 Hidden Default, OK

  ;Create an ImageList to hold the small icons.
  local ch_ImageListID := IL_Create(ch_totalWindows)

  ;Assign the above ImageList to the current ListView.
  LV_SetImageList(ch_ImageListID)
  Loop, %ch_maxWindows%
  {
    local this_id := ch_winId%A_Index%
    If this_id =
      continue
    IfWinNotExist ahk_id %this_id%
    {
      ch_winId%A_Index% :=
      ch_totalWindows -= 1
      continue
    }
    local ch_winId := ch_winId%A_Index%

    local ch_winClass
    WinGetClass, ch_winClass, ahk_id %ch_winId%
    If ch_winClass = #32770 ; fix for displaying control panel related windows (dialog class) that aren't on taskbar
      local ch_IconNumber := IL_Add(ch_ImageListID, "C:\WINDOWS\system32\shell32.dll" , 217) ; generic control panel icon
    Else
    {
      ;this whole icon routine is from evl, I don't pretend to
      ;understand it, I just modified it until it worked for me
      SendMessage, 0x7F, 2, 0,, ahk_id %ch_winId%
      local ch_hIcon := ErrorLevel
      If ( ! ch_hIcon )
      {
        SendMessage, 0x7F, 0, 0,, ahk_id %ch_winId%
        ch_hIcon := ErrorLevel
        If ( ! ch_hIcon )
        {
          ch_hIcon := DllCall( "GetClassLong", "uint", ch_winId, "int", -34 ) ; GCL_HICONSM is -34
          If ( ! ch_hIcon )
          {
            ch_hIcon := DllCall( "LoadIcon", "uint", 0, "uint", 32512 ) ; IDI_APPLICATION is 32512
          }
        }
      }
      ;Add the HICON directly to the small-icon and large-icon lists.
      ;Below uses +1 to convert the returned index from zero-based to one-based:
      ;Create the new row in the ListView and assign it the icon number determined above ; Add 2 spaces for looks
      ch_IconNumber := DllCall("ImageList_ReplaceIcon", "uint", ch_ImageListID, "int", -1, "uint", ch_hIcon) + 1
    }
    local ch_winName
    WinGetTitle, ch_winName, ahk_id %ch_winId%
    LV_Add("Icon" . ch_IconNumber, A_Index . A_Space . ch_winName)
    continue
  }
  LV_ModifyCol()
  return
}

ch_RestoreWindow(ch_RowNum)
{
  LV_GetText(ch_rowText, ch_RowNum, 1)        ;Get the Info from the row's first field.
  StringGetPos, ch_firstSpace, ch_rowText, %A_Space%  ;These two lines extract the
  StringLeft, ch_index, ch_rowText, ch_firstSpace     ;array index for the selected window
  ch_winId := ch_winId%ch_Index%
  WinShow, ahk_id %ch_winId%
  ch_winId%ch_index% :=                   ;Delete the contents of the variable
  global ch_totalWindows -= 1
  Gui, Destroy
  return
}

ch_GetLongestName()
{
  global
  ch_longestName := 0
  Loop, %ch_maxWindows%
  {
    local this_id := ch_winId%A_Index%
    If ch_winId%A_Index% =
      continue
    IfWinNotExist, ahk_id %this_id%
      continue
    local ch_winId := ch_winId%A_Index%
    local ch_winName
    WinGetTitle, ch_winName, ahk_id %ch_winId%
    local ch_winNameLength := GetTextWidth(ch_winName, ch_textFont)
    If (ch_winNameLength >= ch_longestName)
      ch_longestName := ch_winNameLength
  }

  If ch_longestName <> 0
    ch_longestName := ch_longestName + 50  ;add some room for the icon

  return
}

;GetTextWidth by Sean:  http://www.autohotkey.com/forum/post-113847.html&sid=cb1840004443b42e1a730db24896b406#113847
GetTextWidth(sString, sFaceName, nHeight = 12, bBold = False, bItalic = False, bUnderline = False, bStrikeOut = False, nCharSet = 0)
{
  hDC := DllCall("GetDC", "Uint", 0)
  nHeight := -DllCall("MulDiv", "int", nHeight, "int", DllCall("GetDeviceCaps", "Uint", hDC, "int", 90), "int", 72)

  hFont := DllCall("CreateFont", "int", nHeight, "int", 0, "int", 0, "int", 0, "int", 400 + 300 * bBold, "Uint", bItalic, "Uint", bUnderline, "Uint", bStrikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", sFaceName)
  hFold := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)

  DllCall("GetTextExtentPoint32", "Uint", hDC, "str", sString, "int", StrLen(sString), "int64P", nSize)

  DllCall("SelectObject", "Uint", hDC, "Uint", hFold)
  DllCall("DeleteObject", "Uint", hFont)
  DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

  nWidth  := nSize & 0xFFFFFFFF

  Return nWidth
}
