@echo off

setlocal enabledelayedexpansion

set services="VMAuthdService" "VMnetDHCP" "VMware NAT Service" "VMUSBArbService" "VMwareHostd" "LanmanWorkstation"

for %%c in (%*) do (
	if "x%%c" equ "xstart" (
		for %%s in (%services%) do (
			set /p "ign=try to %%c service %%s ... " <nul
			set done=fail
			net /y start %%s>nul 2>&1 && set done=done
			echo !done!
		)
	) else if "x%%c" equ "xstop" (
		for %%s in (%services%) do (
			set /p "ign=try to %%c service %%s ... " <nul
			set done=fail
			net /y stop %%s>nul 2>&1 && set done=done
			echo !done!
		)
	) else if "x%%c" equ "xsc" (
		for %%s in (%services%) do (
			set /p "ign=try to config service %%s boot on demand ... " <nul
			set done=fail
			sc config %%s start= demand>nul 2>&1 && set done=done
			echo !done!
		)
	) else (
		echo invalid command for net : %%c
	)
)

endlocal

set /p "ign=all done, press enter key to exit ... "
