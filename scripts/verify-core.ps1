[CmdletBinding()]
param([switch]$SkipRestart)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)

function Pass([string]$Message) { Write-Host "[PASS] $Message" -ForegroundColor Green }
function Wait-Http([string]$Uri, [int]$Seconds = 60) {
    $deadline = (Get-Date).AddSeconds($Seconds)
    do { try { return Invoke-RestMethod -Uri $Uri -TimeoutSec 3 } catch { Start-Sleep -Seconds 2 } } while ((Get-Date) -lt $deadline)
    throw "Timeout: $Uri"
}

$health = Wait-Http 'http://127.0.0.1:4566/_floci/health'
Pass 'Floci Health Endpoint'
$tracker = Wait-Http 'http://127.0.0.1:3000/api/health'
if ($tracker.missionCount -ne 44) { throw "Mission Tracker meldet $($tracker.missionCount) statt 44 Missionen." }
Pass 'Mission Tracker mit 44 Missionen'
$ui = Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:4500/' -TimeoutSec 5
if ($ui.StatusCode -ne 200) { throw 'Floci UI liefert nicht HTTP 200.' }
Pass 'Floci UI HTTP 200'

$identity = docker compose exec -T floci awslocal sts get-caller-identity 2>&1
if ($LASTEXITCODE -ne 0) { throw "AWS CLI gegen Floci fehlgeschlagen: $identity" }
Pass 'AWS CLI / STS'

$bucket = "smoke-core-$([Guid]::NewGuid().ToString('N').Substring(0,12))"
$temp = New-TemporaryFile
try {
    Set-Content -LiteralPath $temp -Value 'northstar-smoke' -NoNewline
    docker compose exec -T floci awslocal s3api create-bucket --bucket $bucket --create-bucket-configuration LocationConstraint=eu-central-1 | Out-Null
    docker compose cp $temp "floci:/tmp/smoke.txt" | Out-Null
    docker compose exec -T floci awslocal s3 cp /tmp/smoke.txt "s3://$bucket/smoke.txt" | Out-Null
    $listed = docker compose exec -T floci awslocal s3api head-object --bucket $bucket --key smoke.txt
    if ($LASTEXITCODE -ne 0) { throw 'S3 HeadObject fehlgeschlagen.' }
    Pass 'Temporärer S3 Write/Read'
} finally {
    docker compose exec -T floci awslocal s3 rm "s3://$bucket/smoke.txt" 2>$null | Out-Null
    docker compose exec -T floci awslocal s3api delete-bucket --bucket $bucket 2>$null | Out-Null
    Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
}
Pass 'S3 Smoke-Ressourcen entfernt'

if (-not $SkipRestart) {
    $parameter = '/smoke/platform/persistence'
    docker compose exec -T floci awslocal ssm put-parameter --name $parameter --type String --value survives-restart --overwrite | Out-Null
    docker compose restart floci | Out-Null
    Wait-Http 'http://127.0.0.1:4566/_floci/health' 90 | Out-Null
    $value = docker compose exec -T floci awslocal ssm get-parameter --name $parameter --query 'Parameter.Value' --output text
    if ($value.Trim() -ne 'survives-restart') { throw 'Persistenznachweis nach Neustart fehlgeschlagen.' }
    docker compose exec -T floci awslocal ssm delete-parameter --name $parameter | Out-Null
    Pass 'Floci-Persistenz über Neustart'
}

$missions = Invoke-RestMethod -Uri 'http://127.0.0.1:3000/api/missions' -TimeoutSec 5
if ($missions.missions.Count -ne 44) { throw 'Missions-API unvollständig.' }
$milestones = ($missions.missions | ForEach-Object { $_.milestones }).Count
if ($milestones -lt 300) { throw "Nur $milestones Meilensteine erkannt." }
Pass "Missions-API: 44 Missionen / $milestones Meilensteine"
Write-Host 'Core-Verifikation vollständig erfolgreich.' -ForegroundColor Cyan
