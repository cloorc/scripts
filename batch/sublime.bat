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

goto :notfound

:found
"!sublime!" %*
goto :eof

:notfound
set /p ign="sublime not found, press enter key to exit ..."
goto :eof

endlocal
