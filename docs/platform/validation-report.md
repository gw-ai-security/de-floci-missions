# Validierungsbericht

Stand: 17. Juli 2026, Windows 11 / Docker Desktop 4.81.0 / Docker Engine 29.6.1 / Compose 5.2.0.

## Erfolgreich ausgeführt

- `docker compose config --quiet` für Core und alle Profile
- Node Parser-, Contract- und Syntaxprüfungen
- Secret-Pattern-Scan ohne echte AWS-Credentials
- Core-Build und Start mit drei gesunden Containern
- Floci `/_floci/health`
- offizielle Floci UI HTTP 200
- Mission Control Health, 44 Missionen und 399 Meilensteine
- AWS CLI/STS gegen Floci
- temporärer S3-Bucket, Upload, HeadObject und vollständiges Cleanup
- Floci-SSM-Zustand über Containerneustart persistent
- einzelner Meilenstein über Mission-Tracker-Neustart persistent; Ausgangszustand wiederhergestellt
- alle Meilensteine einer Mission gesetzt ⇒ Status `completed`; Ausgangszustand wiederhergestellt
- RAG-Profil gebaut, Healthcheck und deterministischer Modus geprüft
- Vector-Profil gestartet, pgvector-Extension erstellt und Vektordimension abgefragt
- Doctor: 0 Fehler, 0 Warnungen

## Nicht vollständig ausgeführt

- Die Browser-Control-Verbindung konnte ihre lokale Session nicht initialisieren (`failed to write kernel assets`). Die UI wurde deshalb über HTTP/API, JavaScript-Syntax und Interaktionszustände der API geprüft, aber in diesem Lauf nicht per automatisiertem Screenshot abgenommen.
- Der gepinnte Flink-Image-Download blieb auf der lokalen Registry-Verbindung in zwei Versuchen länger als die Testzeit hängen. Das Profil ist Compose-valide; der reale JobManager-REST-Test wurde nicht als erfolgreich markiert.
- Die übrigen schweren Profile (`tools`, `lab`, `spark`, `cdc`, `airflow`, `bi`, `observability`) sind konfigurationsvalidiert und besitzen ausführbare Minimaltests in `scripts/verify-profiles.*`, wurden in diesem Lauf aber nicht vollständig heruntergeladen und gestartet.
- Dynamische Floci-Workflows für Lambda, RDS, MSK, OpenSearch, ECR und EKS benötigen zusätzliche große Runtime-Images und wurden in diesem fokussierten Core/UI-Lauf nicht ausgeführt.

## Reproduzierbare Nachprüfung

```powershell
.\scripts\verify-core.ps1
.\scripts\verify-profiles.ps1 -Profile flink -Start
.\scripts\verify-profiles.ps1 -Profile all -Start
```

Kein nicht ausgeführter Test wird als bestanden ausgegeben. Der laufende Core ist für Mission M00 und den Fortschritts-Workflow bereit.
