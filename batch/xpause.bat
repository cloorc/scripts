@echo off
setlocal enabledelayedexpansion
if "%*" neq "" (
	set /p "ign=%* ... "<nul
	pause>nul 2>&1
) else (
	pause
)
endlocal