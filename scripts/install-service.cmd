@echo off
setlocal EnableExtensions EnableDelayedExpansion

net session >nul 2>&1
if errorlevel 1 (
    echo Run this script as Administrator.
    exit /b 1
)

set "SERVICE_NAME=ZiovpoPract2Service"
set "DISPLAY_NAME=ZIoVPO Pract2 Service"
set "SCRIPT_DIR=%~dp0"
set "SVC_EXE=%SCRIPT_DIR%..\build\Release\ziovpo-pract2-service.exe"

if not exist "%SVC_EXE%" (
    echo Build the project first:
    echo   cmake -S . -B build -A x64
    echo   cmake --build build --config Release
    exit /b 1
)

for %%I in ("%SVC_EXE%") do set "SVC_EXE=%%~fI"

call :RemoveService
call :WaitUntilServiceGone 60
if errorlevel 1 (
    echo Service is still pending deletion ^(error 1072^).
    echo Close services.msc / Task Manager, then run this script again.
    exit /b 1
)

set "CREATE_OK=0"
for /L %%R in (1,1,15) do (
    sc create "%SERVICE_NAME%" binPath= "\"%SVC_EXE%\"" DisplayName= "%DISPLAY_NAME%" start= demand type= own
    if not errorlevel 1 (
        set "CREATE_OK=1"
        goto :create_done
    )
    echo Waiting for SCM to allow create, attempt %%R/15...
    call :WaitUntilServiceGone 5
    timeout /t 2 /nobreak >nul
)
:create_done

if "%CREATE_OK%"=="0" (
    echo Failed to create the service.
    echo If you see error 1072, wait 30 seconds and run install-service.cmd again.
    exit /b 1
)

sc description "%SERVICE_NAME%" "ZIoVPO pract2: RPC ALPC + GUI launcher"

echo.
echo Service installed: %SERVICE_NAME%
echo Start:  sc start %SERVICE_NAME%
echo     or: Start-Service %SERVICE_NAME%
echo GUI is launched by the service in user sessions.
exit /b 0

:RemoveService
sc query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 exit /b 0

echo Stopping %SERVICE_NAME%...
sc stop "%SERVICE_NAME%" >nul 2>&1
call :WaitUntilStopped 30

taskkill /F /IM ziovpo-pract2-service.exe >nul 2>&1

echo Deleting %SERVICE_NAME%...
sc delete "%SERVICE_NAME%" >nul 2>&1
exit /b 0

:WaitUntilStopped
set /A TRIES=%~1
:wait_stop_loop
sc query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 exit /b 0
sc query "%SERVICE_NAME%" | findstr /I "STOPPED" >nul 2>&1
if not errorlevel 1 exit /b 0
if !TRIES! LEQ 0 exit /b 0
set /A TRIES-=1
timeout /t 1 /nobreak >nul
goto :wait_stop_loop

:WaitUntilServiceGone
set /A TRIES=%~1
:wait_gone_loop
sc query "%SERVICE_NAME%" >nul 2>&1
if errorlevel 1 exit /b 0
if !TRIES! LEQ 0 exit /b 1
set /A TRIES-=1
timeout /t 1 /nobreak >nul
goto :wait_gone_loop
