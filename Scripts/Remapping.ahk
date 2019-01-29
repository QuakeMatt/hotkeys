; Ctrl + Up => Home
^Up::
Send {Home}
return

; Ctrl + Down => End
^Down::
Send {End}
return

; Ctrl + Shift + Up => Shift + Home
^+Up::
Send +{Home}
return

; Ctrl + Shift + Down => Shift + End
^+Down::
Send +{End}
return

; Ctrl + RButton => Ctrl + U (Sublime Text)
#IfWinActive ahk_class PX_WINDOW_CLASS
^RButton::^u
#IfWinActive

; Media controls
>^p::Media_Play_Pause
>^n::Media_Next

; Task view
XButton1::
Send #{Tab}
return

; Task view
XButton2::
Send #{Tab}
return
