#Space::

	MouseGetPos, , , mouseWindow
	WinGet, ExStyle, ExStyle, ahk_id %mouseWindow%
	if (ExStyle & 0x8) { ; AlwaysOnTop == true
		Winset, AlwaysOnTop, off, ahk_id %mouseWindow%
	}
	else { ; AlwaysOnTop == false
		Winset, AlwaysOnTop, on, ahk_id %mouseWindow%
	}

	WinGet, activeWindow, ID, A
	Winset, Top, , ahk_id %activeWindow%

return
