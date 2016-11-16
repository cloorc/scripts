@echo off

setlocal enabledelayedexpansion

set src=README.md
if not exist !src! goto :nosuchfile

set dst=README.docx
if "%~1" neq "" set "dst=%~1"

pandoc -f markdown_github -t docx !src! -o !dst!
goto :exit

:nosuchfile
echo README.md not found!
goto :eof

:exit
endlocal