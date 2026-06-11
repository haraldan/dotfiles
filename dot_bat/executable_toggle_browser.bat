@echo off
setlocal enabledelayedexpansion

set "SFTA=%~dp0SetUserFTA.exe"
set "EDGE=MSEdgeHTM"
set "BRAVE=BraveHTML"

"%SFTA%" get > "%TEMP%\sfta_out.txt"

REM /b matches start of line, space after comma ensures exact "http, " match
for /f "tokens=2 delims=, " %%i in ('findstr /b "http, " "%TEMP%\sfta_out.txt"') do (
    set "CURRENT=%%i"
    goto :found
)
:found

echo Current http: !CURRENT!

if /i "!CURRENT!"=="%EDGE%" (
    echo Switching to Brave...
    "%SFTA%" http %BRAVE%
    "%SFTA%" https %BRAVE%
) else (
    echo Switching to Edge...
    "%SFTA%" http %EDGE%
    "%SFTA%" https %EDGE%
)

del "%TEMP%\sfta_out.txt" >nul 2>&1
echo.
echo Done.