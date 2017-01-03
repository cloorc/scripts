@echo off
setlocal enabledelayedexpansion

for %%a in (in out) do (
	set rulename="trust%%a"
	
	set /p ign="try to remove rule !rulename!, please wait ... "<nul
	netsh advfirewall firewall delete rule name=!rulename!>nul 2>&1
	echo done
	
	set /p ign="try to create rule !rulename!, please wait ... "<nul
	netsh advfirewall firewall add rule name=!rulename! dir=%%a action=allow enable=yes profile=any localip=any remoteip=any protocol=any interfacetype=any security=notrequired>nul 2>&1
	echo done
)

endlocal

set /p ign="all done, press enter key to exit ..."
