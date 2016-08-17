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
		if not defined groupId (
			set groupId=%%e
		) else (
			if not defined artifactId (
				set artifactId=%%e
			) else (
				if not defined version (
					set version=%%e
				)
			)
		)
	)
)

if defined groupId if defined artifactId if defined version goto :execute
goto :invalid_parameters

:execute
set jar=!artifactId!-!version!.jar
set src=!artifactId!-!version!-sources.jar
set parent=!repo!/!groupId:.=/!/!artifactId!/!version!
echo going to get: !groupId!:!artifactId!:!version!
if not exist !jar! axel -n 4 -o !jar! !parent!/!jar!
if not exist !src! axel -n 4 -o !src! !parent!/!src!
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