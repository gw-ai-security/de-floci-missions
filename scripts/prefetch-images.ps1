$ErrorActionPreference = 'Continue'
Set-Location (Split-Path -Parent $PSScriptRoot)
$images = @(docker compose --profile '*' config --images | Sort-Object -Unique | Where-Object { $_ -notlike 'dea-floci/*' })
foreach ($image in $images) { Write-Host "Pull $image" -ForegroundColor Cyan; docker pull $image; if ($LASTEXITCODE -ne 0) { throw "Image nicht verfügbar: $image" } }
