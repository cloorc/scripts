@echo off

call :debug start ...

setlocal enabledelayedexpansion

call :debug test maven installation ...
set mvnfound=
call mvn --version>nul 2>&1 && set mvnfound=true
if not defined mvnfound goto :mvnnotfound

set commands=install get deploy
rem maven get -r:http://repo1.maven.org/maven2/ -m:groupId:artifactId:version [-t:targetDir]
rem maven install -m:groupId:artifactId:version:packaging -f:x:\path\to\file.ext
rem maven deploy -r:http://repo1.maven.org/maven2/ -m:groupId:artifactId:version:packaging -f:x:\path\to\file.ext -i:repositoryId

call :debug supported commands: !commands!

call :debug parse arguments ...

set command=
set repoUrl=http://repo1.maven.org/maven2/
for %%c in (%*) do (
	set arg=%%c
	set opt=!arg:~0,2!
	set val=!arg:~3!
	if "x!arg!" equ "xinstall" (
		set command=install
	) else if "x!arg!" equ "xget" (
		set command=get
	) else if "x!opt!" equ "x-r" (
		set repoUrl=!val!
	) else if "x!opt!" equ "x-m" (
		for /f "tokens=1,2,3,4,5 delims=:" %%m in ("!val!") do (
			set groupId=%%m
			set artifactId=%%n
			set packaging=%%o
			set version=%%p
		)
	) else if "x!opt!" equ "x-f" (
		set file=!val!
	) else if "x!opt!" equ "x-i" (
		set repositoryId=!val!
	) else if "x!opt!" equ "x-t" (
		set targetDir=!val!
	)
)

call :debug command: !command!
call :debug repoUrl: !repoUrl!
call :debug groupId: !groupId!
call :debug artifactId: !artifactId!
call :debug version: !version!
call :debug packaging: !packaging!
call :debug repositoryId: !repositoryId!
call :debug file: !file!
call :debug targetDir: !targetDir!

if not defined command goto :usage
for %%c in (!commands!) do (
	call :debug supported command: %%c
	if "x%%c" equ "x!command!" (
		call :debug command [!command!] is going to be executed ...
		goto :!command!
	)
)
goto :usage

:debug
if defined debug echo %*
goto :eof

:usage
echo usage:
echo   %~n0 get -r:http://repo1.maven.org/maven2/ -m:groupId:artifactId:version [-t:targetDir]
echo   %~n0 install -m:groupId:artifactId:version:packaging -f:x:\path\to\file.ext
echo   %~n0 deploy -r:http://repo1.maven.org/maven2/ -m:groupId:artifactId:version:packaging -f:x:\path\to\file.ext -i:repositoryId
goto :exit

:install
call mvn install:install-file -DgroupId=!groupId! -DartifactId=!artifactId! -Dversion=!version! -Dpackaging=!packaging! -Dfile=!file!
goto :exit

:deploy
call mvn deploy:deploy-file -DgroupId=!groupId! -DartifactId=!artifactId! -Dversion=!version! -Dpackaging=!packaging! -Dfile=!file! -Durl=!repoUrl! -DrepositoryId=!repositoryId!
goto :exit

:get
set success=
call mvn dependency:get -DrepoUrl=!repoUrl! -Dartifact=!groupId!:!artifactId!:!version!
if defined targetDir (
	set repository=%USERPROFILE%\.m2\repository
	set localTmp=%TEMP%\%~n0_tmp
	type %USERPROFILE%\.m2\settings.xml|findstr /c:localRepository>!localTmp!
	set localRepository=
	for /f "usebackq tokens=2 delims=<> " %%r in (!localTmp!) do (
		if not defined localRepository (
			set localRepository=%%r
		)
	)
	set filename=!artifactId!-!version!.jar
	set relative=!groupId:.=\!\!artifactId!\!version!\!filename!
	call :debug local repository: !localRepository!
	call :debug repository: !repository!
	call :debug file relative to repository: !relative!
	if exist "!localRepository!\!relative!" (
		copy /b "!localRepository!\!relative!" !targetDir!\!filename!
	) else if exist "!repository!\!relative!" (
		copy /b "!repository!\!relative!" !targetDir!\!filename!
	)
)
goto :exit

:mvnnotfound
echo mvn not in PATH, program is going to exit.
goto :exit

:exit
endlocal
