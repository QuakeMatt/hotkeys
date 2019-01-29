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
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force  ; Ensures that only the last executed instance of script is running

Scripts := [	; Additional Startup Scripts Can Be Added Between the ( Continuations  ) Below
(Join,
"Scripts\AlwaysOnTop.ahk"
"Scripts\ColourPicker.ahk"
"Scripts\EasyWindowDrag.ahk"
"Scripts\GoToAnything.ahk"
"Scripts\Remapping.ahk"
"Scripts\PlainPaste.ahk"
)]

Startup := {}

for index, Script in Scripts ; Run All the Scripts, Keep Their PID, Keep Info for Tooltip Text
{
	Run, %Script%,,, pid
	Startup[Script,"PID"] := pid
	Tip_Text .= Substr(Script,1,-4) "`n"
}

Sort, Tip_Text ; Create the Tooltip
Tip_Text := Trim(Tip_Text, " `n")
Menu, Tray, Tip, %Tip_Text%

; Shortcut Trick to Get Windows 7 to Update Hidden Tray
;Send {LWin Down}b{LWin Up}{Enter}{Escape}

;Sleep 500

;Tray_Icons := {}
;Tray_Icons := TrayIcons()

;if A_OSVersion in WIN_VISTA,WIN_7
;{
;	arr := {}
;	arr := TrayIconsOverflow()
;	for index, Icon in arr
;		Tray_Icons.Insert(Icon)
;	arr := ""
;}

OnExit, ExitSub ; Gosub to ExitSub when this Script Exits

;Loop, 5	; Try To Remove 5 Times Because Icons May Lag During Bootup
;{
;	for index, Script in Startup
;		for index2, Icon in Tray_Icons
;			If (Script.Pid = Icon.Pid)
;				RemoveTrayIcon(Icon.hWnd, Icon.uID)
;	Sleep 90000
;}

~#^!Escape::ExitApp

ExitSub: ; Stop All the Startup Scripts (Called When this Scripts Exits)
	DetectHiddenWindows, On
	for index, element in Startup
		PostMessage, 0x111, 65307,,,% "ahk_pid " element.PID
exitapp

;#include Lib/TrayIcon.ahk ; Library to Manipulate Tray Icons
