; Calculator launch key
Launch_App2::
	if WinActive("Calculator ahk_class ApplicationFrameWindow", "Calculator") {
		SendInput !{F4}
	}
	else if WinExist("Calculator ahk_class ApplicationFrameWindow", "Calculator") {
		WinActivate
	}
	else {
		Run calc.exe
	}
return

; Numpad enter, while calculator has focus
#IfWinActive Calculator ahk_class ApplicationFrameWindow, Calculator
	NumpadEnter::
		SendInput {Enter}
		SendInput ^c
	return
#IfWinActive
