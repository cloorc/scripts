::mvndelete

@echo off
setlocal enabledelayedexpansion

set artifact=%~1
set "gapv=!artifact::= !"

:: g/a/v
if "!gapv!" equ "!artifact!" goto :gav

:gapv
for %%e in (!gapv!) do (
	if defined version goto :error
	if defined packaing if not defined version set version=%%e
	if defined artifactId if not defined version set packaing=%%e
	if defined groupId if not defined artifactId set artifactId=%%e
	if not defined groupId set groupId=%%e
)
goto :delete

:gav
set "gav=!artifact:/= !"
if "!gav!" equ "!gav!" goto :error
for %%e in (!artifact!) do (
	if defined version goto :error
	if defined artifactId if not defined version set version=%%e
	if defined groupId if not defined artifactId set artifactId=%%e
	if not defined groupId set groupId=%%e
)
goto :delete

:delete
pushd %TEMP%
if exist pom.xml del /f pom.xml
for /f "usebackq delims=" %%l in (`mvn help:evaluate -Dexpression^=settings.localRepository`) do (
	set line6=%%l
	set line6=!line6:~0,6!
	if "!line6!" neq "[INFO]" set localRepository=%%l
)
popd
set "target=!localRepository!\!groupId:.=\!\!artifactId!\!version!"
rmdir /s !target!
if exist "!target!" echo folder cannot be removed.
goto :eof

:error
echo invalid format, must be one of :
echo groupId:artifactId:packaing:version
echo groupId/artifactId/version

:exit
endlocal
