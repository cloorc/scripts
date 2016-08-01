@echo off
setlocal enabledelayedexpansion
echo %1|findstr /r ^[0-9]*$>nul && set sleep=%1
if not defined sleep set sleep 1
ping -n !sleep! 127.0.0.1>nul 2>&1
endlocal