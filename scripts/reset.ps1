[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param([switch]$Force)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$containers = @(docker ps -a --filter network=dea_floci_net --format '{{.ID}}|{{.Names}}')
$projectVolumes = @(docker volume ls --filter label=com.docker.compose.project=dea-floci-missions --format '{{.Name}}')
Write-Host 'Container im Projektnetz:'; $containers | ForEach-Object { Write-Host "  $_" }
Write-Host 'Projekt-Volumes:'; $projectVolumes | ForEach-Object { Write-Host "  $_" }
if (-not $Force -and -not $PSCmdlet.ShouldContinue('Missions- und Profildaten werden unwiderruflich gelöscht.', 'DEA Floci Lab zurücksetzen?')) { return }
docker compose --profile '*' down --volumes --remove-orphans
if ($LASTEXITCODE -ne 0) { throw 'Compose reset fehlgeschlagen.' }
Write-Host 'Projektzustand wurde zurückgesetzt. Fremde Docker-Projekte wurden nicht verändert.' -ForegroundColor Green
