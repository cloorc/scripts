@echo off

setlocal enabledelayedexpansion

if "%1" equ "" goto :usage
if "%2" equ "" goto :usage

if not exist "%~dp1" mkdir %~dp1

for /f "usebackq delims=" %%p in (`where axel`) do (
	set AXEL=%%p
)

if not defined AXEL (
	echo axel.exe does not exist on PATH.
	goto :done
)

if not exist "%USERPROFILE%\axel" mkdir "%USERPROFILE\axel"
set log=%USERPROFILE%\axel\%~n1.txt

echo %*>%log% 2>&1
cd %~dp1>>%log% 2>&1
:try
for /f "usebackq delims=" %%l in (`%AXEL% -an 8 %2`) do (
	echo %%l>>%log%
	set line=%%l
	if "!line:~9,3!" equ "404" (
		set url=%2
		set "url=!url:/= !"
		for %%e in (!url!) do (
			set "file=%%e"
		)
		del "!file!">>%log% 2>&1
		exit 404
	)
	:: 502 should be retry
	::if "!line:~9,3!" equ "502" exit 2
	if "!line:~0,10!" equ "Downloaded" goto :done
)
goto :try

:usage
echo %0 [output-file-path] [input-url]
goto :done

:done
endlocal
exit 0