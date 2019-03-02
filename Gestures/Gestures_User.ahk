Gestures:

/*
 * Gestures
 */

m_LowThreshold = 4      ; Minimum distance to register as a gesture "stroke."
m_Timeout = 2000        ; Maximum time in milliseconds between the last mouse movement
						; and release of the gesture key/button.

m_EnabledIcon =

return


; ----------------------------------------------------------


Clip(Text="", Reselect="") ; http://www.autohotkey.com/forum/viewtopic.php?p=467710 , modified February 19, 2013
{
	Static BackUpClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackUpClip
		BackUpClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
		If (Text = "") {
			SendInput, ^c
			ClipWait, LongCopy ? 0.6 : 0.2, True
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			SendInput, ^v
		}
		SetTimer, %A_ThisFunc%, -700
		Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
		If (Text = "")
			Return LastClip := Clipboard
		Else If (ReSelect = True) or (Reselect and (StrLen(Text) < 3000)) {
			StringReplace, Text, Text, `r, , All
			SendInput, % "{Shift Down}{Left " StrLen(Text) "}{Shift Up}"
		}
	}
	Return
	Clip:
	Return Clip()
}


; ----------------------------------------------------------


Gesture_L:
	SetTitleMatchMode, RegEx
	if WinActive("ahk_group ^Explorer$") {
		Send !{Left}
	}
	else if WinActive("- Sublime Text") {
		Send !{Left}
	}
	else if WinActive("- Visual Studio Code") {
		Send ^{PgUp}
	}
	else if WinActive("- (Microsoft )?Visual C\+\+") {
		Send ^-
	}
	else if WinActive("ahk_class ^#32770$") && G_ControlExist("SHELLDLL_DefView1") {
		; Possibly a File dialog, so try sending "Back" command.
		SendMessage, 0x111, 0xA00B ; WM_COMMAND, ID
	}
	else if WinActive("ahk_class WinMergeWindowClassW") {
		Send !{Up}
	}
	else {
		Send {Browser_Back}
	}
return


; ----------------------------------------------------------


Gesture_R:
	SetTitleMatchMode, RegEx
	if WinActive("ahk_group ^Explorer$") {
		Send !{Right}
	}
	else if WinActive("- Sublime Text") {
		Send !{Right}
	}
	else if WinActive("- Visual Studio Code") {
		Send ^{PgDn}
	}
	else if WinActive("- (Microsoft )?Visual C\+\+") {
		Send ^+-
	}
	else if WinActive("ahk_class WinMergeWindowClassW") {
		Send !{Down}
	}
	else {
		Send {Browser_Forward}
	}
return


; ----------------------------------------------------------


Gesture_U:
	SetTitleMatchMode, RegEx
	if UwpActive("MicrosoftEdge.exe", hwnd) {
		UwpSend("!{home}", hwnd)
	}
	else if WinActive("ahk_class IEFrame") {
		SendEvent {Alt down}{home}{Alt up}
	}
	else if WinActive("ahk_class MozillaWindowClass") {
		Send !{home}
	}
	else if WinActive("ahk_class Chrome_WidgetWin_1") {
		SendEvent !d
		Clip("https://www.google.co.uk/")
		Send {enter}
	}
	else if WinActive("ahk_class OperaWindowClass") {
		Send !{home}
	}
	else {
		Send ^n
	}
return


; ----------------------------------------------------------


Gesture_D:
	SetTitleMatchMode, RegEx
	if UwpActive("MicrosoftEdge.exe", hwnd) {
		UwpSend("^w", hwnd)
	}
	else if WinActive("ahk_class IEFrame") {
		SendEvent {Ctrl down}w{Ctrl up}
	}
	else if WinActive("ahk_class MozillaWindowClass") {
		SendEvent ^w
	}
	else if WinActive("ahk_class Chrome_WidgetWin_1") {
		SendEvent ^w
	}
	else if WinActive("ahk_class OperaWindowClass") {
		SendEvent ^w
	}
	else if WinActive("ahk_class FM") {
		Send !{F4}
	}
	else if WinActive("- Notepad2") {
		Send !{F4}
	}
	else if WinActive("ahk_class CalcFrame") {
		Send !{F4}
	}
	else {
		SendEvent ^w
	}
return


; ----------------------------------------------------------


Gesture_U_L:
	if UwpActive("MicrosoftEdge.exe", hwnd) {
		UwpSend("^t", hwnd)
	}
	else if WinActive("ahk_class IEFrame") {
		SendEvent {Ctrl down}t{Ctrl up}
	}
	else if WinActive("Microsoft Edge ahk_class ApplicationFrameWindow") {
		Send ^t
	}
	else if WinActive("ahk_class MozillaWindowClass") {
		Send ^t
	}
	else if WinActive("ahk_class Chrome_WidgetWin_1") {
		Send ^t
	}
	else if WinActive("ahk_class OperaWindowClass") {
		Send ^t
	}
return


; ----------------------------------------------------------


Gesture_U_R:
	if UwpActive("MicrosoftEdge.exe", hwnd) {
		UwpSend("!d", hwnd)
		Sleep 13
		Clip("https://www.google.co.uk/")
		Sleep 13
		SendInput !{enter}
	}
	else if WinActive("ahk_class IEFrame") {
		SendEvent {Alt down}d{Alt up}
		Sleep 25
		Clip("https://www.google.co.uk/")
		Sleep 25
		SendEvent {Alt down}{enter}{Alt up}
	}
	else if WinActive("ahk_class MozillaWindowClass") {
		SendEvent !d
		Sleep 13
		Clip("https://www.google.co.uk/")
		Sleep 13
		SendEvent !{enter}
	}
	else if WinActive("ahk_class Chrome_WidgetWin_1") {
		SendEvent {Alt down}d{Alt up}
		Clip("https://www.google.co.uk/")
		SendEvent {Alt down}{enter}{Alt up}
	}
	else if WinActive("ahk_class OperaWindowClass") {
		Send ^t
		Sleep 10
		Send !{home}
	}
	else if WinActive("ahk_class WinMergeWindowClassW") {
		Send !{Right}
		Sleep 10
		Send !{Down}
	}
return


; ----------------------------------------------------------


Gesture_U_D:
	if UwpActive("MicrosoftEdge.exe", hwnd) {
		UwpSend("^+t", hwnd)
	}
	else if WinActive("ahk_class IEFrame") {
		SendEvent {Ctrl down}{Shift down}t{Shift up}{Ctrl up}
	}
	else if WinActive("ahk_class MozillaWindowClass") {
		Send ^+t
	}
	else if WinActive("ahk_class Chrome_WidgetWin_1") {
		Send ^+t
	}
	else if WinActive("ahk_class OperaWindowClass") {
		Send ^+t
	}
	else if WinActive("- Sublime Text") {
		Send ^+t
	}
	else if WinActive("- Visual Studio Code") {
		Send ^+t
	}
return


; ----------------------------------------------------------


Gesture_D_L:
	if UwpActive("MicrosoftEdge.exe", hwnd) {
		UwpSend("!d", hwnd)
		Sleep 13
		Clip("about:Tabs")
		Sleep 13
		SendInput !{enter}
	}
	else if WinActive("ahk_class IEFrame") {
		SendEvent {Alt down}d{Alt up}
		Sleep 25
		Clip("about:Tabs")
		Sleep 25
		SendEvent {enter}
	}
	else if WinActive("ahk_class MozillaWindowClass") {
		Send !d
		Send {raw}about:newtab
		Send {enter}
	}
	else if WinActive("ahk_class Chrome_WidgetWin_1") {
		SendEvent {Alt down}d{Alt up}
		Clip("chrome://newtab")
		SendEvent {enter}
	}
	else if WinActive("ahk_class OperaWindowClass") {
		Send {F8}
		Sleep 10
		Send {raw}about:speeddial
		;Sleep 10
		Send {enter}
	}
	else if WinActive("ahk_class WinMergeWindowClassW") {
		Send !{Left}
		Sleep 10
		Send !{Down}
	}
return
