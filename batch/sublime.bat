@echo off

setlocal enabledelayedexpansion

set sublime=
if defined ProgramFiles (
	set sublime=!ProgramFiles:"=!\Sublime Text 3\sublime_text.exe
	if exist "!sublime!" goto :found
)
if defined ProgramFiles(x86) (
	set sublime=!ProgramFiles:"=!\Sublime Text 3\sublime_text.exe
	if exist "!sublime!" goto :found
)
if defined SUBLIME_INSTALLATION (
    set sublime=!SUBLIME_INSTALLATION:"=!
    if exist "!sublime!" goto :found
)
set /p location="sublime not found, please input the full path of sublime installation:"
if defined location (
    set sublime=!location:"=!
    if "x!sublime:~-4!" neq "x.exe" set sublime=!sublime!\sublime_text.exe
    if exist "!sublime!" (
        setx SUBLIME_INSTALLATION "!sublime!"
        goto :found
    )
)

:found
start "" "!sublime!" %*
goto :eof

:notfound
set /p ign="sublime not found, press enter key to exit ..."
goto :eof

endlocal
