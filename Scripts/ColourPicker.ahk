#d::
	MouseGetPos, mouseX, mouseY
	PixelGetColor, colour, %mouseX%, %mouseY%, RGB
	colour := SubStr(colour, 3)
	StringLower, colour, colour
	ClipBoard := colour
return
