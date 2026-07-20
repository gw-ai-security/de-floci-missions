# DEA-C01 Floci Hands-on Missions

Lokale, kostenfreie Data-Engineering-Laborplattform für den Missionenplan **M00 bis M43**. Floci stellt AWS-kompatible APIs bereit, die offizielle Floci UI zeigt lokale AWS-Ressourcen, und die eigene Mission-Control-Web-UI hält den Lernfortschritt persistent fest.

## Projektstand

**Stand:** 20. Juli 2026

| Bereich | Status |
|---|---|
| Plattform-Core | eingerichtet und für S3-Missionen nutzbar |
| M01 – S3 Data Lake Fundamentals | abgeschlossen; Artefakte unter [`missions/M01-s3-data-lake/`](missions/M01-s3-data-lake/) |
| M02 – S3 Lifecycle, Versioning und Resilienz | aktuelle Mission |
| M02-Workspace | wird zu Beginn der Mission unter `missions/M02-s3-lifecycle-resilience/` angelegt |

Der Fortschritt in Mission Control bleibt die operative Fortschrittsanzeige. Die README-Dateien dokumentieren zusätzlich den versionierten Stand des Repositorys.

## Aktuelle Mission: M02

M02 erweitert den in M01 aufgebauten Bucket `northstar-data-lake` um Schutz- und Lifecycle-Mechanismen.

**Schwerpunkte:**

- S3 Versioning und Version IDs
- Delete Marker und Wiederherstellung
- Lifecycle Rules: Transition und Expiration
- Storage-Class-Entscheidungen
- Replication als Resilienzmechanismus, aber nicht als Backup-Ersatz
- Object Lock, Verschlüsselung sowie RPO/RTO
- Backup-/Restore-Runbook und Failure Injection

**Lokale Laufzeit:** nur der Core; kein zusätzliches Compose-Profil erforderlich.

**Wichtige Grenze:** M02 ist als Emulationsklasse A/B eingeordnet. Versionierungs- und grundlegende S3-Operationen können lokal praktisch geprüft werden. Reale Storage-Class-Übergänge, Glacier-Abrufzeiten, Multi-Region-Replikation, Object-Lock-Compliance und vollständige AWS-Security-Semantik müssen im AWS-Reality-Check getrennt bewertet werden.

Die verbindlichen Aufgaben stehen im [`DEA-C01 Floci Hands-on Missionenplan`](content/DEA-C01_Floci_Hands-on_Missionenplan.md).

## Schnellstart unter Windows

Voraussetzungen: Windows 10/11, Docker Desktop mit WSL2/Linux-Containern, PowerShell 7 und Git.

```powershell
Copy-Item .env.example .env
.\scripts\doctor.ps1
.\scripts\start-core.ps1
```

Danach öffnen:

- **Mission Control:** http://localhost:3000 — Missionen ausklappen und jeden Meilenstein abhaken
- **Floci UI:** http://localhost:4500 — echte lokal emulierte AWS-Ressourcen untersuchen
- **Floci API:** http://localhost:4566 — AWS CLI, Boto3, SDKs und IaC

Die Missions-UI berechnet automatisch `Offen`, `In Arbeit` und `Erledigt`. Eine Mission wird erst als erledigt markiert, wenn alle zugehörigen Meilensteine abgehakt sind. Der Zustand liegt im benannten Volume `mission-progress` und übersteht Container-Neustarts.

## Erster AWS-Aufruf

Das gepinnte Floci-Compat-Image enthält AWS CLI und den Wrapper `awslocal`:

```powershell
docker compose exec floci awslocal sts get-caller-identity
docker compose exec floci awslocal s3api list-buckets
```

Für eine vollständige Werkzeug-Shell:

```powershell
docker compose --profile tools run --rm toolbox bash
```

Anwendungscode verwendet den Endpoint aus der Umgebung und keine proprietäre Floci-API:

```text
Host:        AWS_ENDPOINT_URL=http://localhost:4566
Container:   AWS_ENDPOINT_URL=http://floci:4566
Region:      eu-central-1
Credentials: test / test (nur lokal)
```

## Profile

Schwere Komponenten starten niemals automatisch. Beispiele:

```powershell
.\scripts\start-profile.ps1 -Profile lab
.\scripts\start-profile.ps1 -Profile spark
.\scripts\start-profile.ps1 -Profile cdc
.\scripts\start-profile.ps1 -Profile airflow
```

Verfügbare Profile: `tools`, `lab`, `spark`, `cdc`, `airflow`, `flink`, `vector`, `rag`, `bi`, `observability`. Details und Adressen stehen in [Compose-Profile](docs/platform/compose-profiles.md).

## Stop, Reset und Cleanup

```powershell
# Container stoppen, Daten behalten
.\scripts\stop.ps1

# Projektbezogene Container und Volumes nach Bestätigung löschen
.\scripts\reset.ps1

# Zusätzlich selbst gebaute dea-floci/* Images entfernen
.\scripts\cleanup.ps1
```

Die Skripte verwenden keine globalen `docker system prune`- oder `docker volume prune`-Operationen und greifen keine fremden Compose-Projekte an.

## Verifikation

```powershell
node --test mission-tracker/test/missions.test.mjs tests/contracts/mission-plan.test.mjs
docker compose config --quiet
.\scripts\verify-core.ps1
.\scripts\verify-profiles.ps1
```

`verify-core.ps1` prüft Health, beide UIs, AWS CLI/STS, einen temporären S3-Write/Read mit Cleanup, Persistenz über einen Floci-Neustart sowie alle 44 Missionen. Optionale Profile werden mit `-Start` tatsächlich gebaut und minimal ausgeführt.

## Projektführung

- Source of Truth: `content/DEA-C01_Floci_Hands-on_Missionenplan.md`
- Infrastrukturzuordnung: `docs/platform/mission-infrastructure-matrix.md`
- Plattformbetrieb: `docs/platform/`
- Eigene Lösungen: `missions/MXX-name/`
- Eigene IaC-Artefakte: `infra/`
- Tests: `tests/`

Der Core provisioniert absichtlich keine Missions-Buckets, Queues, Tabellen, Funktionen, Rollen oder Datenbanken. Diese Ressourcen entstehen beim Lernen über GUI, CLI/SDK und IaC.

## Nächster technischer Schritt

Vor Änderungen an `northstar-data-lake` wird in M02 zuerst der Ist-Zustand erfasst:

```powershell
.\scripts\verify-core.ps1 -SkipRestart
docker compose exec floci awslocal s3api get-bucket-versioning --bucket northstar-data-lake
docker compose exec floci awslocal s3api list-object-versions --bucket northstar-data-lake --prefix raw/orders/
```

Erst danach wird Versioning aktiviert. So bleibt nachvollziehbar, welche Objekte bereits vor der Versionierung existierten und welches Verhalten Floci tatsächlich unterstützt.