usbipd attach --wsl --hardware-id 0403:6015 -a
if %errorlevel% neq 0 (
    echo An error occurred. Errorlevel: %errorlevel%
    pause
) else (
    exit
)