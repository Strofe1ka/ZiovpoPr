#Requires -RunAsAdministrator
# Если PowerShell блокирует скрипты, используйте install-service.cmd
# или: powershell -ExecutionPolicy Bypass -File .\scripts\install-service.ps1
$ErrorActionPreference = "Stop"

$serviceName = "ZiovpoPract2Service"
$displayName = "ZIoVPO Pract2 Service"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$binDir = Resolve-Path (Join-Path $scriptDir "..\build\Release")
$svcPath = Join-Path $binDir "ziovpo-pract2-service.exe"

if (-not (Test-Path $svcPath)) {
    Write-Error "Сначала соберите проект: cmake --build build --config Release"
}

$existing = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($existing) {
    if ($existing.Status -eq "Running") {
        Stop-Service -Name $serviceName -Force
    }
    sc.exe delete $serviceName | Out-Null
    Start-Sleep -Seconds 1
}

New-Service `
    -Name $serviceName `
    -BinaryPathName "`"$svcPath`"" `
    -DisplayName $displayName `
    -StartupType Manual `
    -Description "ZIoVPO pract2: RPC (ALPC) + GUI launcher" | Out-Null

Write-Host "Служба установлена: $serviceName"
Write-Host "Запуск: Start-Service $serviceName"
Write-Host "GUI: $binDir\ziovpo-pract2.exe (запускается службой в сессиях пользователей)"
