[CmdletBinding()]
param([switch]$Force)
& "$PSScriptRoot/reset.ps1" -Force:$Force
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
$images = @(docker images --filter reference='dea-floci/*' --format '{{.Repository}}:{{.Tag}}')
if ($images.Count -gt 0 -and ($Force -or $PSCmdlet.ShouldContinue(($images -join "`n"), 'Lokale Projekt-Build-Images ebenfalls entfernen?'))) { docker image rm $images }
