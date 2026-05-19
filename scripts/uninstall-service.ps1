#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

$serviceName = "ZiovpoPract2Service"
$svc = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if (-not $svc) {
    Write-Host "Служба $serviceName не найдена."
    exit 0
}

if ($svc.Status -eq "Running") {
    Stop-Service -Name $serviceName -Force
}

sc.exe delete $serviceName | Out-Null
Write-Host "Служба $serviceName удалена."
