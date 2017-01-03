@echo off

setlocal enabledelayedexpansion

set plist=%TEMP%\%~n0.txt

for %%c in (%*) do (
  if "x%%c" equ "x/y" set noconfirm=true
)

:find
tasklist|findstr /c:java>!plist!

:showandkill
for /f "usebackq tokens=1,2,3,5" %%p in (!plist!) do (
  set /p ign="going to kill process [%%q/%%p/%%r/%%s] ... "<nul
  if defined noconfirm (
    call :kill %%q
  ) else (
    set continue=
    set /p confirm="continue?[Y/n]:"
    if not defined confirm set continue=true
    if "x!confirm!" equ "xy" set continue=true
    if "x!confirm!" equ "xY" set continue=true
    if defined continue call :kill %%q
  )
)
goto :exit

:kill
taskkill /pid:%1 /f>nul 2>nul
goto :eof

:exit
endlocal
