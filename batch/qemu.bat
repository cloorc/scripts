@echo off

if "%~1" equ "" goto :invalid_args

goto :eof

:invalid_args
echo Invalid arguments.
goto :eof