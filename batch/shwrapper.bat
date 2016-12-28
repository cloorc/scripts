@echo off
setlocal enabledelayedexpansion

set git_home=
for /f "usebackq tokens=1,2,* delims= " %%e in (`REG QUERY HKEY_LOCAL_MACHINE\Software\GitForWindows /v InstallPath`) do (
	if "%%e" equ "InstallPath" (
		set "git_home=%%g"
	)
)
if not defined git_home goto :git_not_installed

set "sh_exe=!git_home!\bin\sh.exe"
if not exist "!sh_exe!" goto :bash_not_found

"!sh_exe!" $*

goto :end

:git_not_installed
echo Git has not been found, propably not installed yet. Please install git first.
echo Download git here: https://git-scm.com/download/win
goto :end

:bash_not_found
echo Bash not found in '!sh_exe!', please verify your git installation.
goto :end

:end
endlocal