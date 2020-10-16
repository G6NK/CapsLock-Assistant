#NoEnv
;warn
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
Menu, Tray, Nostandard
Menu, tray, add, &Exit, ExitApp
Menu, Tray, Default, &Exit
Menu, Tray, add, Start With Windows, sww
Menu, Tray, add, Tip Off, Tips
Menu, Tray, Tip, CapsLock Assistant



SplitPath, A_Scriptname, , , , OutNameNoExt
LinkFile=%A_Startup%\%OutNameNoExt%.lnk ; Or A_StartupCommon
LinkFile2=%A_Startup%\%OutNameNoExt%.ini ; Or A_StartupCommon



IfExist, %LinkFile%
	{
		numsu = 1
		Menu, Tray, Check, Start With Windows
	}
else
	{
		numsu =0
		Menu, Tray, Uncheck, Start With Windows
	}

IfExist, %LinkFile2%
	{
		numtip = 1
		Menu, Tray, Check, Tip Off
	}
else
	{
		numtip =0
		Menu, Tray, UnCheck, Tip Off
		Gui CLTIP: add, text,,Capslock Assistant:`n `n You can make this app start with windows 'n by right clicking the icon in your tray menu! `n You can also turn off this tip from the menu
		Gui CLTIP: -caption -resize border
		Gui CLTIP: add, button,x350  y50 w60 gOK +Default , OK 
		Gui CLTIP: show

	}

return

OK:
gui, CLTIP:destroy
return

sww:
IfExist, %LinkFile%
	numsu = 1
else
	numsu =0

If %numsu%=0
	{
		FileCreateShortcut, %A_ScriptFullPath%, %LinkFile%
		Menu, Tray, Check, Start With Windows
	}
else
	{
		FileDelete, %LinkFile%
		Menu, Tray, Uncheck, Start With Windows
	}
Return

tips:
IfExist, %LinkFile2%
	numtip = 1
else
	numtip = 0

If %numtip%=0
	{
		FileAppend, %A_ScriptFullPath%, %LinkFile2%		
		Menu, Tray, check, Tip Off		
	}
else
	{
		FileDelete, %LinkFile2%
		Menu, Tray, Uncheck, Tip Off
	}

Return

;===============================

~CapsLock::
LOOP: ;---------------------------------------------------->Capslock on loop returns here when caps lock turns off

CapsLockStatus := GetKeyState("CapsLock", "T") ;--------------------------> gets capslock toggle state
If CapsLockStatus = 0 ;---------------------------------------->if capslock is off
{
ToolTip, CapsLock is Off ;------->tool tip CapsLock is OFF so
SoundBeep, 300 ;------------------>low beep once with tool tip
sleep 1000 ;-------------------------->show tool tip for one second
ToolTip ;-------------->remove tool tip
}
Else
{												
If CapsLockStatus = 1 ;------------------------->if caps lock is ON										
loop{ 											
		SoundBeep, 5000 ;----------------------------------------------------------->highbeep once				
			loop{ ;-------------------------------------------------->loops below:
				
				ToolTip, CapsLock is On ;------->tool tip CapsLock is ON so	 						
				CapsLockStatus := GetKeyState("CapsLock", "T")  ; ----->gets capslock toggle state		
				If CapsLockStatus = 0 ;-----------> if CapsLock is OFF 
					{ 
						GOSUB, LOOP ;--------------------Go to the Loop label at beginning
						break
					}
				Else ;------------------------------------------>if CapsLock is Not OFF
					{
							;---------------------->continue loop
					}
			}
		return
	}
	return
}
return

Exitapp:
ExitApp