[CmdletBinding()]
param([switch]$Strict)

$ErrorActionPreference = 'Continue'
$script:Failures = 0
$script:Warnings = 0
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

function Result([string]$Level, [string]$Name, [string]$Detail = '') {
    $color = @{ PASS = 'Green'; WARN = 'Yellow'; FAIL = 'Red' }[$Level]
    Write-Host "[$Level] $Name$(if ($Detail) { ": $Detail" })" -ForegroundColor $color
    if ($Level -eq 'FAIL') { $script:Failures++ }
    if ($Level -eq 'WARN') { $script:Warnings++ }
}

try {
    $info = docker info --format '{{.OSType}}|{{.Architecture}}|{{.MemTotal}}' 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Docker Engine antwortet nicht' }
    $parts = $info -split '\|'
    Result PASS 'Docker Engine' "$($parts[0])/$($parts[1])"
    if ($parts[0] -ne 'linux') { Result FAIL 'Linux Containers' 'Docker Desktop auf Linux Containers umstellen' } else { Result PASS 'Linux Containers' }
    $memoryGb = [math]::Round(([double]$parts[2] / 1GB), 1)
    if ($memoryGb -lt 6) { Result WARN 'Docker RAM' "${memoryGb} GB; 8 GB oder mehr empfohlen" } else { Result PASS 'Docker RAM' "${memoryGb} GB" }
} catch { Result FAIL 'Docker Engine' $_.Exception.Message }

docker compose version *> $null
if ($LASTEXITCODE -eq 0) { Result PASS 'Docker Compose v2' } else { Result FAIL 'Docker Compose v2' 'nicht verfügbar' }

if (Test-Path .env) { Result PASS '.env' } else { Result WARN '.env' 'fehlt; .env.example kopieren' }
if (Test-Path content/DEA-C01_Floci_Hands-on_Missionenplan.md) { Result PASS 'Missionenplan' } else { Result FAIL 'Missionenplan' 'Source of Truth fehlt' }

$drive = Get-PSDrive -Name ([IO.Path]::GetPathRoot($Root).TrimEnd(':\'))
$freeGb = [math]::Round($drive.Free / 1GB, 1)
if ($freeGb -lt 20) { Result WARN 'Freier Speicher' "${freeGb} GB; schwere Profile benötigen mehr" } else { Result PASS 'Freier Speicher' "${freeGb} GB" }

docker compose config --quiet *> $null
if ($LASTEXITCODE -eq 0) { Result PASS 'Compose-Konfiguration' } else { Result FAIL 'Compose-Konfiguration' }

$ports = 3000, 4500, 4566
foreach ($port in $ports) {
    $listener = Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $listener) { Result PASS "Port $port" 'frei' }
    else {
        $process = Get-Process -Id $listener.OwningProcess -ErrorAction SilentlyContinue
        $ours = docker ps --format '{{.Names}}|{{.Ports}}' 2>$null | Select-String "127.0.0.1:$port->"
        if ($ours) { Result PASS "Port $port" 'von diesem Lab belegt' } else { Result WARN "Port $port" "belegt durch $($process.ProcessName) (PID $($listener.OwningProcess))" }
    }
}

try {
    $health = Invoke-RestMethod -Uri 'http://127.0.0.1:4566/_floci/health' -TimeoutSec 2
    $healthStatus = if ($health.status) { $health.status } else { 'erreichbar' }
    Result PASS 'Floci Health' $healthStatus
} catch { Result WARN 'Floci Health' 'Core ist nicht gestartet' }
try { Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:4500/' -TimeoutSec 2 | Out-Null; Result PASS 'Floci UI' } catch { Result WARN 'Floci UI' 'nicht erreichbar' }
try {
    $tracker = Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/health' -TimeoutSec 2
    if ($tracker.missionCount -eq 44) { Result PASS 'Mission Tracker' '44 Missionen' } else { Result FAIL 'Mission Tracker' 'unerwartete Missionsanzahl' }
} catch { Result WARN 'Mission Tracker' 'nicht erreichbar' }

Write-Host "`nErgebnis: $script:Failures Fehler, $script:Warnings Warnungen"
if ($script:Failures -gt 0 -or ($Strict -and $script:Warnings -gt 0)) { exit 1 }
exit 0
