; Mintty quake console: Visor-like functionality for Windows
; Version: 1.8
; Author: Jon Rogers (lonepie@gmail.com)
; URL: https://github.com/lonepie/mintty-quake-console
; Credits:
;   Originally forked from: https://github.com/marcharding/mintty-quake-console
;   mintty: https://github.com/mintty/
;   Visor: http://visor.binaryage.com/
;
; MIT License
; Copyright (c) 2018 Jon Rogers

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

#NoEnv
#NoTrayIcon
#SingleInstance force
SendMode Input
DetectHiddenWindows, on
SetWinDelay, -1


; Configures and initialises the script
; ----------------------------------------------------------

CONSOLE_PATH := "%ProgramW6432%\PowerShell\7\pwsh.exe"
CONSOLE_ARGS := ""
CONSOLE_START_DIR := "%USERPROFILE%\Documents"

WINDOW_HEIGHT := 400
WINDOW_OPACITY := 235

ANIMATION_DURATION := 500
ANIMATION_SLEEP := 1

console_pid := 0
console_hidden := 0
last_active_id := 0

OnExit("RemoveConsole")
#`::ToggleConsole()
Return


; Gets or creates a console window
; ----------------------------------------------------------

GetConsole()
{
	global

	If (console_pid > 0 and WinExist("ahk_pid" console_pid)) {
		return console_pid
	}

	console_pid := 0
	console_hidden := 1

	exec := Trim(ExpandEnvVars(CONSOLE_PATH) . " " . ExpandEnvVars(CONSOLE_ARGS))
	active_dir := GetActivePath()
	dir := active_dir ? active_dir : ExpandEnvVars(CONSOLE_START_DIR)
	Run, %exec%, %dir%, Hide, console_pid
	WinWait, ahk_pid %console_pid%, , 1

	WinSet, AlwaysOnTop, On, ahk_pid %console_pid%
	WinSet, Transparent, %WINDOW_OPACITY%, ahk_pid %console_pid%
	WinSet, Style, -0xC40000, ahk_pid %console_pid% ; Hide borders

	VirtScreenPos(screen_left, screen_top, screen_width, screen_height)

	set_left := screen_left
	set_width := screen_width
	set_height := WINDOW_HEIGHT
	WinMove, ahk_pid %console_pid%, , %set_left%, -%set_height%, %set_width%, %set_height%

	return console_pid
}


; Toggles the state of the console
; ----------------------------------------------------------

ToggleConsole(dir:="")
{
	global

	GetConsole()

	If (dir == "") {
		dir := (WinActive("ahk_pid" console_pid)) ? "out" : "in"
	}

	If (dir == "in" and console_hidden) {
		WinGet, last_active_id, ID, A
		WinShow ahk_pid %console_pid%
		WinSet, AlwaysOnTop, On, ahk_pid %console_pid%
		WinActivate, ahk_pid %console_pid%
		console_hidden := 0
	}

	If (dir == "out" and last_active_id) {
		WinActivate, ahk_id %last_active_id%
	}

	SetTimer, HideWhenInactive, Off

	WinGetPos, window_x, window_y, window_width, window_height, ahk_pid %console_pid%
	VirtScreenPos(screen_left, screen_top, screen_width, screen_height)

	duration := ANIMATION_DURATION
	start_time := A_TickCount
	elapsed_time := 0

	While (elapsed_time < duration) {
		elapsed_time := Min(A_TickCount - start_time, duration)
		progress := EaseFn(elapsed_time / duration)

		delta_y := Round(window_height * progress)
		delta_y := % (dir = "in") ? delta_y - window_height : screen_top - delta_y
		WinMove, ahk_pid %console_pid%, , , delta_y

		Sleep, %ANIMATION_SLEEP%
	}

	If (dir == "in") {
		SetTimer, HideWhenInactive, 100
	}

	If (dir == "out") {
		WinHide ahk_pid %console_pid%
		console_hidden := 1
	}
}


; Remove the console window
; ----------------------------------------------------------

RemoveConsole()
{
	global
	If (console_pid && WinExist("ahk_pid" console_pid)) {
		WinClose, ahk_pid %console_pid%
		console_pid := 0
	}
}


; Animation easing function
; ----------------------------------------------------------

EaseFn(t)
{
	t := 1.0 - t
	return 1.0 - t * t * t * t * t
}


; Hides the console if it loses focus
; ----------------------------------------------------------

HideWhenInactive:
	If (!WinActive("ahk_pid" console_pid)) {
		last_active_id := 0
		if (WinExist("ahk_pid" console_pid)) {
			ToggleConsole("out")
		}
		SetTimer, HideWhenInactive, Off
	}
return


; Gets the working path of the active window
; ----------------------------------------------------------

GetActivePath()
{
	WinGetTitle, active_title, A
	If (!active_title) {
		return ""
	}

	; Windows Explorer
	If (WinActive("ahk_class CabinetWClass")) {
		full_path := ""
		for window in ComObjCreate("Shell.Application").Windows {
			try full_path := window.Document.Folder.Self.Path
			SplitPath, full_path, partial_title
			If (partial_title = active_title) {
				break
			}
		}
		return full_path
	}

	return ""
}


; Gets the screen size/position, minus the taskbar
; ----------------------------------------------------------

VirtScreenPos(ByRef mLeft, ByRef mTop, ByRef mWidth, ByRef mHeight)
{
	global displayOnMonitor
	if (displayOnMonitor > 0) {
		SysGet, Mon, Monitor, %displayOnMonitor%
		SysGet, MonArea, MonitorWorkArea, %displayOnMonitor%

		mLeft:=MonAreaLeft
		mTop:=MonAreaTop
		mWidth:=(MonAreaRight - MonAreaLeft)
		mHeight:=(MonAreaBottom - MonAreaTop)
	}
	else {
		Coordmode, Mouse, Screen
		MouseGetPos,x,y
		SysGet, m, MonitorCount

		; Iterate through all monitors.
		Loop, %m%
		{   ; Check if the window is on this monitor.
			SysGet, Mon, Monitor, %A_Index%
			SysGet, MonArea, MonitorWorkArea, %A_Index%
			if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
			{
				mLeft:=MonAreaLeft
				mTop:=MonAreaTop
				mWidth:=(MonAreaRight - MonAreaLeft)
				mHeight:=(MonAreaBottom - MonAreaTop)
			}
		}
	}
}


; Expands environment variables in the given string
; ----------------------------------------------------------

ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, int, 1999, "Cdecl int")
	return dest
}
