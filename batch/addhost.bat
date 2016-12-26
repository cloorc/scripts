@echo off
setlocal enabledelayedexpansion

:loop
set host=
set ip=
set /p host=pls specify host string, quit to exit:
if not defined host goto :loop
if "!host!" equ "quit" goto :exit
set /p ip=pls specify ip address for host !host!:
if not defined ip goto :loop
goto :loop

:exit
endlocal
