@echo off

set "e_notfound=no proper maven installation found."

if not defined M2_HOME set /p M2_HOME=please specify maven installation path:
if not defined M2_HOME call :exit %e_notfound%

set "mvn=%M2_HOME%\bin\mvnDebug.cmd"

if not exist %mvn% call :exit %e_notfound%
setx M2_HOME %M2_HOME%>nul 2>&1

call %mvn% %*
goto :eof

:exit
echo %~1
exit