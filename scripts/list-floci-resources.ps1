$ErrorActionPreference = 'Continue'
Write-Host 'Floci-Container im Projektnetz' -ForegroundColor Cyan
docker ps -a --filter network=dea_floci_net --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
Write-Host "`nVon Floci markierte Volumes" -ForegroundColor Cyan
docker volume ls --filter label=floci=true
Write-Host "`nBelegte Floci-Portbereiche" -ForegroundColor Cyan
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { ($_.LocalPort -ge 5100 -and $_.LocalPort -le 5199) -or ($_.LocalPort -ge 6500 -and $_.LocalPort -le 7099) -or ($_.LocalPort -ge 9400 -and $_.LocalPort -le 9499) } | Sort-Object LocalPort | Format-Table LocalAddress,LocalPort,OwningProcess
