#Requires AutoHotkey v2.0+
TraySetIcon "icons/caps_white.ico",1,true

LShift & RShift:: CapsLock
RShift & LShift:: CapsLock


*CapsLock::
{
    Send "{LControl down}"
}

*CapsLock up::
{
    Send "{LControl Up}"

    if (A_PriorKey=="CapsLock"){
	if (A_TimeSincePriorHotkey < 150)
		Suspend "1"
		Send "{Esc}"
		Suspend "0"
	}
}