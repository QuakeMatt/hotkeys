;; Go to anything that is in the currently selected text: URLs, email addresses, Windows paths, or just "Google it"
#b::
    ;Tip("Clipping...")  ;; include my mouse-tip library for this https://gist.github.com/2400547
    clip := GTA_CopyToClipboard()
    if (!clip) {
        return
    }
    addr := GTA_ExtractAddress(clip)
    if (!addr)
    {
        ; Google it
        ;Tip("Searching for [" SubStr(clip, 1, 50) "] ...")
        addr := "https://www.google.co.uk/search?q=" . clip
    }
    else {
        ; Go to it using system's default methods for the address
        ;Tip("Going to " Substr(addr, 1, 25) " ...")
    }

    Run %addr%
    return

;; utility functions

;; Safely copies-to-clipboard, restoring clipboard's original value after
;; Returns the captured clip text, or "" if unsuccessful after 1 second
GTA_CopyToClipboard()
{
    ; Wait for modifier keys to be released before we send ^C
    KeyWait LWin
    KeyWait Alt
    KeyWait Shift
    KeyWait Ctrl

    ; Capture to clipboard, then restore clipboard's value from before capture
    ExistingClipboard := ClipboardAll
    Clipboard =
    SendInput ^{Insert}
    ClipWait, 1
    NewClipboard := Clipboard
    Clipboard := ExistingClipboard
    if (ErrorLevel)
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        ;Tip("The attempt to copy text onto the clipboard failed.")
        return ""
    }
    return NewClipboard
}

;; Extracts an address from anywhere in str.
;; Recognized addresses include URLs, email addresses, domain names, Windows local paths, and Windows UNC paths.
GTA_ExtractAddress(str)
{
    if (RegExMatch(str, "S)((http|https|ftp|mailto:)://[\S]+)", match))
        return match1
    if (RegExMatch(str, "S)(\w+@[\w.]+\.(com|net|org|gov|cc|edu|info))", match))
        return "mailto:" . match1
    if (RegExMatch(str, "S)(www\.\S+)", match))
        return "http://" . match1
    if (RegExMatch(str, "S)(\w+\.(com|net|org|gov|cc|edu|info))", match))
        return "http://" . match1
    if (RegExMatch(str, "S)([a-zA-Z]:[\\/][\\/\-_.,\d\w\s]+)", match))
        return match1
    if (RegExMatch(str, "S)(\\\\[\w\-]+\\.+)", match))
        return match1
    return ""
}
