#SingleInstance, force
OnExit,Exit

WS_Values = 0x0,0x80000000,0x40000000,0x20000000,0x10000000,0x8000000,0x4000000,0x2000000,0x1000000,0xC00000,0x800000,0x400000,0x200000,0x100000,0x80000,0x40000,0x20000,0x10000,0x20000,0x10000,0x0,0x20000000,0x40000,0xCF0000,0x80880000
WS_Titles = WS_OVERLAPPED,WS_POPUP,WS_CHILD,WS_MINIMIZE,WS_VISIBLE,WS_DISABLED,WS_CLIPSIBLINGS,WS_CLIPCHILDREN,WS_MAXIMIZE,WS_CAPTION,WS_BORDER,WS_DLGFRAME,WS_VSCROLL,WS_HSCROLL,WS_SYSMENU,WS_THICKFRAME,WS_GROUP,WS_TABSTOP,WS_MINIMIZEBOX,WS_MAXIMIZEBOX,WS_TILED,WS_ICONIC,WS_SIZEBOX,WS_OVERLAPPEDWINDOW,WS_POPUPWINDOW
WS_EX_Values = 0x1,0x4,0x8,0x10,0x20,0x40,0x80,0x100,0x200,0x400,0x1000,0x0,0x2000,0x0,0x4000,0x0,0x10000,0x20000,0x40000,0x300,0x188,0x80000
WS_EX_Titles = WS_EX_DLGMODALFRAME,WS_EX_NOPARENTNOTIFY,WS_EX_TOPMOST,WS_EX_ACCEPTFILES,WS_EX_TRANSPARENT,WS_EX_MDICHILD,WS_EX_TOOLWINDOW,WS_EX_WINDOWEDGE,WS_EX_CLIENTEDGE,WS_EX_CONTEXTHELP,WS_EX_RIGHT,WS_EX_LEFT,WS_EX_RTLREADING,WS_EX_LTRREADING,WS_EX_LEFTSCROLLBAR,WS_EX_RIGHTSCROLLBAR,WS_EX_CONTROLPARENT,WS_EX_STATICEDGE,WS_EX_APPWINDOW,WS_EX_OVERLAPPEDWINDOW,WS_EX_PALETTEWINDOW,WS_EX_LAYERED

Loop, parse, WS_Values, `,
{
  WS_Value%A_Index% = %A_LoopField%
  WS_nbr++
}

Loop, parse, WS_Titles, `,
  WS_Title%A_Index% = %A_LoopField%

Loop, parse, WS_EX_Values, `,
{
  WS_EX_Value%A_Index% = %A_LoopField%
  WS_EX_nbr++
}

Loop, parse, WS_EX_Titles, `,
  WS_EX_Title%A_Index% = %A_LoopField%

;SetFormat, integer, hex

ShowToolWindow = 1
Gui, +ToolWindow
Gui, -Resize
Gui, Margin, 0, 0

Gui, Add, Text, w300 vWindowName, Window name
Gui, Add, Text, w300 vWindowStats, Window stats
Gui, Add, Text, w300 vControlName, Control name
Gui, Add, Text, w300 vControlStats, Control stats

Gui, Add, Tab2,w300 h474,Win Style|Win ExStyle|Ctrl Style|Ctrl ExStyle

Gui, Tab, 1
Gui, Add, ListView, r25 w296 checked altsubmit gListview1 vListview1, Value|Name
Gui, Tab, 2
Gui, Add, ListView, r25 w296 checked altsubmit gListview2 vListview2, Value|Name

Gui, Tab

GuiControl, Disable, Listview1
GuiControl, Disable, Listview2

Gui, Listview, Listview1

Loop, %WS_nbr%
{
  LV_ADD("",WS_Value%A_Index%,WS_Title%A_Index%) 
}
LV_ModifyCol()

Gui, ListView, Listview2

Loop, %WS_EX_nbr%
{
  LV_ADD("",WS_EX_Value%A_Index%,WS_EX_Title%A_Index%)
}
LV_ModifyCol()

Gui, Show,, windowstyles

WinSet, AlwaysOnTop,, windowstyles

ManipulateWindow = 0
TriggerActiveStyles = 0

Loop
{
  Sleep, 100
  
  if ManipulateWindow
  {
    if TriggerActiveStyles
    {
      TriggerActiveStyles = 0
      
      GuiControl, -altsubmit, Listview1
      GuiControl, -altsubmit, Listview2
      
      WinSet, Style, %thestyle%, ahk_id %winid%
      WinSet, ExStyle, %theexstyle%, ahk_id %winid%
      
      Gosub ActiveStyles
      
      GuiControl, +altsubmit, Listview1
      GuiControl, +altsubmit, Listview2
      
    }
    Continue
  }
  
  MouseGetPos,mx,my,winid,ctrl
  
  WinGetTitle, wintitle, ahk_id %winid%
  
  WinGet, thestyle, Style, ahk_id %winid%
  WinGet, theexstyle, ExStyle, ahk_id %winid%
  
  ControlGet, TheControlStyle, Style,, %ctrl%, ahk_id %winid%
  ControlGet, TheControlEXStyle, ExStyle,, %ctrl%, ahk_id %winid%
  ControlGet, TheControlHwnd, Hwnd,, %ctrl%, ahk_id %winid%
  
  Gosub ActiveStyles
}

Return

ActiveStyles: ;----------------------------------------------------------------

GuiControl,,WindowName, Window - %wintitle%
GuiControl,,WindowStats, Style %thestyle% ExStyle %theexstyle%
GuiControl,,ControlName, Control - %ctrl% - Hwnd %TheControlHwnd%
GuiControl,,ControlStats, Style %TheControlStyle% ExStyle %TheControlExStyle%

Gui,ListView,Listview1

loop, %WS_nbr%
{
  LV_GetText(SortedListValue,A_Index)
  
  If (thestyle & SortedListValue = SortedListValue)
    LV_Modify(A_Index, "Check")
  Else
    LV_Modify(A_Index, "-Check")
}

Gui,ListView,Listview2

loop, %WS_EX_nbr%
{
  LV_GetText(SortedListValue,A_Index)
  
  If (theexstyle & SortedListValue = SortedListValue)
    LV_Modify(A_Index, "Check")
  Else
    LV_Modify(A_Index, "-Check")
}

Return

Listview1: ;-------------------------------------------------------------------

Critical

If !ManipulateWindow
  Return

MainEventCode = %A_GuiEvent%
SubEventCode = %ErrorLevel%
CheckRowNumber = %A_EventInfo%

If InStr(MainEventCode,"I")
{
  If InStr(SubEventCode,"C",True)
  {
    Gui,ListView,Listview1
    LV_GetText(SortedListValue,CheckRowNumber)
    
    SetFormat, integer, hex
    thestyle := thestyle | SortedListValue
    SetFormat, integer, d
    
    TriggerActiveStyles = 1
  }
  
  If InStr(SubEventCode,"c",True)
  {
    Gui,ListView,Listview1
    LV_GetText(SortedListValue,CheckRowNumber)
    
    SetFormat, integer, hex
    SortedListValue := 0xFFFFFFFF ^ SortedListValue
    thestyle := thestyle & SortedListValue
    SetFormat, integer, d
    
    TriggerActiveStyles = 1
  }
} 

Return

Listview2: ;-------------------------------------------------------------------

Critical

If !ManipulateWindow
  Return

MainEventCode = %A_GuiEvent%
SubEventCode = %ErrorLevel%
CheckRowNumber = %A_EventInfo%

If InStr(MainEventCode,"I")
{
  If InStr(SubEventCode,"C",True)
  {
    Gui,ListView,Listview2
    LV_GetText(SortedListValue,CheckRowNumber)
    
    SetFormat, integer, hex
    theexstyle := theexstyle | SortedListValue
    SetFormat, integer, d
    
    TriggerActiveStyles = 1
  }
  
  If InStr(SubEventCode,"c",True)
  {
    Gui,ListView,Listview2
    LV_GetText(SortedListValue,CheckRowNumber)
    
    SetFormat, integer, hex
    SortedListValue := 0xFFFFFFFF ^ SortedListValue
    theexstyle := theexstyle & SortedListValue
    SetFormat, integer, d
    
    TriggerActiveStyles = 1
  }
} 

Return

PrintScreen:: ;----------------------------------------------------------------

ManipulateWindow := !ManipulateWindow

If ManipulateWindow
{
  GuiControl, Enable, Listview1
  GuiControl, Enable, Listview2
}
Else
{
  GuiControl, Disable, Listview1
  GuiControl, Disable, Listview2
}

Return

GuiClose: ;--------------------------------------------------------------------
Exit:
ExitApp

Return
