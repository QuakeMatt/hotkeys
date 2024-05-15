#SingleInstance, Force
#Persistent
#NoEnv
#Warn

SendMode, Input
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

$+Space::

    if (GetKeyState("W") && (GetKeyState("A") + GetKeyState("D")))
    {
        Send {Ctrl Down}
        KeyWait, Space
        Send {Ctrl Up}
    }
    else
    {
        Send {Space Down}
        KeyWait, Space
        Send {Space Up}
    }

return

$Space::

    Send {Space Down}

    if (GetKeyState("A") + GetKeyState("S") + GetKeyState("D"))
    {
        SpaceHeld := false
        HoldUntil := A_TickCount + 200

        while (GetKeyState("Space", "P") && false == SpaceHeld)
        {
            Sleep 10
            SpaceHeld := (A_TickCount > HoldUntil)
        }

        if (SpaceHeld) {
            Send {Ctrl Down}
            KeyWait, Space
            Send {Ctrl Up}
        }
    }

    Send {Space Up}

return
