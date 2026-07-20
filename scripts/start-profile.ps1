[CmdletBinding()]
param([Parameter(Mandatory)][ValidateSet('tools','lab','spark','cdc','airflow','flink','vector','rag','bi','observability')][string]$Profile)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path .env)) { throw 'Zuerst .env.example nach .env kopieren und lokale Passwörter setzen.' }
docker compose --profile $Profile up --build -d
if ($LASTEXITCODE -ne 0) { throw "Profil $Profile konnte nicht gestartet werden." }
docker compose --profile $Profile ps
