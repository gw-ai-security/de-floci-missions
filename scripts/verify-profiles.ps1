[CmdletBinding()]
param(
    [ValidateSet('tools','lab','spark','cdc','airflow','flink','vector','rag','bi','observability','all')]
    [string]$Profile = 'all',
    [switch]$Start,
    [switch]$StopAfter
)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$profiles = if ($Profile -eq 'all') { 'tools','lab','spark','cdc','airflow','flink','vector','rag','bi','observability' } else { @($Profile) }
foreach ($item in $profiles) {
    docker compose --profile $item config --quiet
    if ($LASTEXITCODE -ne 0) { throw "Compose-Profil ungültig: $item" }
    Write-Host "[PASS] $item config" -ForegroundColor Green
    if (-not $Start) { continue }
    docker compose --profile $item up --build -d
    if ($LASTEXITCODE -ne 0) { throw "Start fehlgeschlagen: $item" }
    Start-Sleep -Seconds 5
    switch ($item) {
        'tools' { docker compose --profile tools run --rm toolbox aws --version }
        'lab' { Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:8888/' -TimeoutSec 15 | Out-Null }
        'spark' { Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:8082/' -TimeoutSec 15 | Out-Null }
        'cdc' { Invoke-RestMethod 'http://127.0.0.1:8084/connectors' -TimeoutSec 15 | Out-Null }
        'airflow' { Invoke-RestMethod 'http://127.0.0.1:8080/health' -TimeoutSec 30 | Out-Null }
        'flink' { Invoke-RestMethod 'http://127.0.0.1:8081/overview' -TimeoutSec 15 | Out-Null }
        'vector' { docker compose exec -T vector-db psql -U vectors -d vectors -c 'CREATE EXTENSION IF NOT EXISTS vector; SELECT vector_dims(ARRAY[1,2,3]::vector);' | Out-Null }
        'rag' { $result = Invoke-RestMethod 'http://127.0.0.1:8090/health' -TimeoutSec 10; if ($result.mode -ne 'deterministic-mock') { throw 'RAG mode mismatch' } }
        'bi' { Invoke-RestMethod 'http://127.0.0.1:3001/api/health' -TimeoutSec 60 | Out-Null }
        'observability' { Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:9090/-/healthy' -TimeoutSec 15 | Out-Null; Invoke-RestMethod 'http://127.0.0.1:3002/api/health' -TimeoutSec 30 | Out-Null }
    }
    Write-Host "[PASS] $item minimal function" -ForegroundColor Green
    if ($StopAfter) { docker compose --profile $item down }
}
