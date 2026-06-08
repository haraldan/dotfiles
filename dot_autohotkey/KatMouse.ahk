#Requires AutoHotkey v2.0+
#SingleInstance
TraySetIcon("icons/mouse_white.ico")

MButton::
{
    MouseGetPos(&x, &y, &winID)

    if WinExist("ahk_id " winID)
    {
        WinMoveBottom("ahk_id " winID)
    }
    return
}
