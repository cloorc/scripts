@echo off

setlocal enabledelayedexpansion

:: try to retrieve code page
codepage=
for /f "usebackq tokens=2,3* delims=:" %%a in (`chcp`) do (
    if not defined codepage set codepage=%%a
)

:: chcp to 437
chcp 437>/nul

:: try to find gateway
set begin=
set /a index=0
for /f "usebackq tokens=1,2* delims=:" %%a in (`ipconfig`) do (
    if defined begin (
        echo %%a|findstr /c:"Media State">nul && set state=%%b
        if "x!state!" neq "x Media disconnected" (
            set /a index+=1
            if !index! equ 5 set gateway=%%~b
        ) else (
            set begin=
        )
    )
    echo %%a|findstr /c:"Ethernet adapter VPN - VPN Client">nul && set begin=1
)

:: drop default gateway
if defined gateway (
    set /p ign=going to delete default route with gateway %gateway% ... <nul
    route delete 0.0.0.0 mask 0.0.0.0 %gateway%>nul 2>&1 && echo done.
    :: flush dns
    set /p ign=going to refresh dns settings ... <nul
    ipconfig /flushdns>nul && echo done.
)

:: change code page to origin
chcp !codepage!>nul

endlocal