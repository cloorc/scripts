@echo off

setlocal enabledelayedexpansion

:parse
if "%~x1" equ ".md" call :convert "%~1"
shift /1
goto :exit

:convert
set /p "ign=converting [%~1] to [%~dpn1.docx] ... " < nul
pandoc -f markdown_github -t docx "%~1" -o "%~dpn1.docx"
echo done
goto :eof

:nosuchfile
echo !src! or !dst! does not exist!
goto :eof

:exit
endlocal