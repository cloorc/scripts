@echo off

setlocal enabledelayedexpansion

set "src=%~1"
if not exist !src! goto :nosuchfile

set "ext=%~x1"
set "ext=!ext:~1!"

if "!ext!" neq "docx" goto :invalid_input_format

set "dst=%~dpn1.md"

pandoc -f docx -t markdown_github !src! -o !dst!
goto :exit

:nosuchfile
echo !src! not found!
goto :eof

:invalid_input_format
echo input format !ext! is not supported.
goto :eof

:exit
endlocal