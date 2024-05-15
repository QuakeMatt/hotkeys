#SingleInstance, Force
#Persistent
#NoEnv
#Warn

HoldSpace := 0
HoldForward := 0

XButton1::
    HoldSpace := !HoldSpace
    If HoldSpace
        SendInput {Space Down}{w Down}
    Else
        SendInput {w Up}{Space Up}
Return

;XButton2::
;    HoldForward := !HoldForward
;    If HoldForward
;        SendInput {w Down}
;    Else
;        SendInput {w Up}
;Return
