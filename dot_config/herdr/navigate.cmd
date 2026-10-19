@echo off
rem Vim-aware pane navigation: forward the key to Vim/fzf, otherwise move Herdr focus.
rem Usage: navigate.cmd <left|down|up|right> <key>
herdr pane process-info --pane %HERDR_ACTIVE_PANE_ID% | findstr /I /R "name.:.[gnl]*vim[a-z]*\.exe name.:.view\.exe name.:.fzf\.exe" >nul
if %errorlevel%==0 (
  herdr pane send-keys %HERDR_ACTIVE_PANE_ID% %2
) else (
  herdr pane focus --direction %1 --pane %HERDR_ACTIVE_PANE_ID%
)
