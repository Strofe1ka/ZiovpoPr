@echo off
setlocal EnableExtensions

net session >nul 2>&1
if errorlevel 1 (
    echo Run PowerShell or CMD as Administrator.
    echo Right-click -^> "Run as administrator"
    exit /b 1
)

set "SERVICE_NAME=ZiovpoPract2Service"

sc start "%SERVICE_NAME%"
if errorlevel 1 (
    echo Start failed. Check: sc query %SERVICE_NAME%
    exit /b 1
)

timeout /t 2 /nobreak >nul
sc query "%SERVICE_NAME%"
echo.
echo If STATE is RUNNING, check the tray for ZIoVPO Pract2 icon.
exit /b 0
