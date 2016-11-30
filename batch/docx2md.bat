@echo off

setlocal enabledelayedexpansion

:parse
if "%~x1" equ ".docx" call :convert "%~1"
shift /1
goto :exit

:convert
set /p "ign=converting [%~1] to [%~dpn1.md] ... " < nul
pandoc -f docx -t markdown_github "%~1" -o "%~dpn1.md"
echo done
goto :eof

:nosuchfile
echo !src! or !dst! does not exist!
goto :eof

:exit
endlocal