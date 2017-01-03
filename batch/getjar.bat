@echo off

setlocal enabledelayedexpansion

axel --version>/nul 2>&1 && set is_axel_exist=true

if not defined is_axel_exist goto :command_not_found

set repo=http://repo2.maven.org/maven2

set groupId=
set artifactId=
set version=
for %%e in ( %* ) do (
	if %%e gtr 0 (
		set c=%%e
		if "!c!" equ "-r" (
			mvn help:evaluate -Dexpression="settings.localRepository"|findstr /R "^[^\[]">%TEMP%\mvn.out
			for /f "usebackq delims=" %%l in (%TEMP%\mvn.out) do set localRepo=%%l
		) else (
			if not defined groupId (
				set groupId=!c!
			) else (
				if not defined artifactId (
					set artifactId=!c!
				) else (
					if not defined version set version=!c!
				)
			)
		)
	)
)

if defined groupId if defined artifactId if defined version goto :execute
goto :invalid_parameters

:execute
if not defined localRepo (
	set localRepo=.
) else (
	set localRepo=!localRepo!\!groupId:.=\!\!artifactId!\!version!
)
set jar=!artifactId!-!version!.jar
set src=!artifactId!-!version!-sources.jar
set parent=!repo!/!groupId:.=/!/!artifactId!/!version!
echo going to get: !groupId!:!artifactId!:!version! to !localRepo! from !repo!
pushd !localRepo!>nul
if not exist !jar! axel -n 4 -o !jar! !parent!/!jar!
if not exist !src! axel -n 4 -o !src! !parent!/!src!
popd>nul
goto :end

:invalid_parameters
echo invalid arguments found.
echo coordinate: !groupId!:!artifactId!:!version!
goto :end

:command_not_found
echo command axel is not found.
goto :end

:end
endlocal
goto :eof