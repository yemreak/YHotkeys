#Persistent
Menu, Tray,Icon, Calc.exe, 1
Menu, Tray, NoStandard
Menu, Tray, Add, &Calculator, Calc
Menu, Tray, Add, 
Menu, Tray, Standard
Menu, Tray, Default, &Calculator

Return

Calc:
   If WinExist("Calculator")
      WinClose, Calculator
   else
      Run, Calc.exe
Return
