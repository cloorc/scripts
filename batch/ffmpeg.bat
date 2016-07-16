@echo off
setlocal enabledelayedexpansion

if not defined FFMPEG_HOME call :init
if not exist "!FFMPEG_HOME!\ff-prompt.bat" call :init

if not exist "!FFMPEG_HOME!\ff-prompt.bat" (
	call :print "invalid installation directory: !FFMPEG_HOME!" && goto :exit
)

:start
pushd "!FFMPEG_HOME!">nul
"ff-prompt.bat" %*
popd>nul
goto :exit

:init
set /p FFMPEG_HOME=pls specify ffmpeg installation folder:
if not defined FFMPEG_HOME (
	call :print "invalid installation directory: !FFMPEG_HOME!" && goto :exit
)
setx FFMPEG_HOME "!FFMPEG_HOME!">nul 2>&1
goto :eof

:print
echo %*
goto :eof

:exit
endlocal
goto :eof