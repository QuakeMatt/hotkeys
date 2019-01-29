; Startup - AutoHotkey
; Fanatic Guru
; 2013 08 19
;
; Startup Script for Startup Folder to Run on Bootup.
;
; Runs the Scripts Defined in the Scripts Array
; Removes the Scripts' Tray Icons leaving only Startup - AutoHotkey
; Creates a ToolTip for the One Tray Icon Showing the Startup Scripts
; If Startup - AutoHotkey is Exited All Startup Scripts are Exited
;
;------------------------------------------------
;
#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent                  ; Keep the script running after initialisation
#SingleInstance Force        ; Ensures that only the last executed instance of script is running
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Scripts := [ ; Additional Startup Scripts Can Be Added Between the ( Continuations  ) Below
(Join,
"Scripts\Bundle.ahk"
"Scripts\EasyWindowDrag.ahk"
"Gestures\Gestures.ahk"
)]

Startup := {}

for index, Script in Scripts ; Run All the Scripts, Keep Their PID, Keep Info for Tooltip Text
{
	Run, %Script%,,, pid
	Startup[Script,"PID"] := pid
}

Menu, Tray, Icon, Tray.ico

OnExit("ExitFunc")

ExitFunc(ExitReason, ExitCode)
{
	global Startup
	DetectHiddenWindows, On
	for index, element in Startup
	{
		PostMessage, 0x111, 65307,,,% "ahk_pid " element.PID
	}
}
