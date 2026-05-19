@echo off
setlocal EnableExtensions

net session >nul 2>&1
if errorlevel 1 (
    echo Run this script as Administrator.
    exit /b 1
)

set "SERVICE_NAME=ZiovpoPract2Service"

sc query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 (
    echo Service %SERVICE_NAME% not found.
    exit /b 0
)

sc stop "%SERVICE_NAME%" >nul 2>&1
timeout /t 2 /nobreak >nul
sc delete "%SERVICE_NAME%"

if errorlevel 1 (
    echo Failed to delete the service.
    exit /b 1
)

echo Service %SERVICE_NAME% removed.
exit /b 0
