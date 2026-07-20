[CmdletBinding()]
param([switch]$SkipDoctor)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path .env)) { Copy-Item .env.example .env; Write-Warning '.env wurde aus .env.example erstellt. Passwörter vor schweren Profilen ändern.' }
if (-not $SkipDoctor) { & "$PSScriptRoot/doctor.ps1"; if ($LASTEXITCODE -ne 0) { throw 'Doctor-Prüfung fehlgeschlagen.' } }
docker compose up --build -d
if ($LASTEXITCODE -ne 0) { throw 'Core konnte nicht gestartet werden.' }
Write-Host 'Mission Tracker: http://localhost:3000' -ForegroundColor Cyan
Write-Host 'Floci UI:       http://localhost:4500' -ForegroundColor Cyan
Write-Host 'Floci API:      http://localhost:4566' -ForegroundColor Cyan
