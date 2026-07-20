# Mission Workspaces

Dieses Verzeichnis enthält ausschließlich die selbst erarbeiteten Artefakte der begonnenen Missionen. Die verbindlichen Aufgaben, Theorieblöcke, Failure-Injection-Szenarien und Exam-Zuordnungen stehen im zentralen [`DEA-C01 Floci Hands-on Missionenplan`](../content/DEA-C01_Floci_Hands-on_Missionenplan.md).

## Aktueller Stand

**Stand:** 20. Juli 2026

| Mission | Workspace | Status |
|---|---|---|
| M01 – S3 Data Lake Fundamentals | [`M01-s3-data-lake/`](M01-s3-data-lake/) | abgeschlossen |
| M02 – S3 Lifecycle, Versioning und Resilienz | `M02-s3-lifecycle-resilience/` | aktuelle Mission; Workspace noch anzulegen |

Der Fortschritt in der Web-UI auf Port `3000` wird separat im Docker-Volume `mission-progress` gespeichert. Der hier dokumentierte Status beschreibt den versionierten Repository-Stand.

## Ordnerstandard

Für jede begonnene Mission wird ein eigener Ordner nach diesem Muster angelegt:

```text
MXX-kurzer-technischer-name/
├── README.md
├── data/          # kleine, bewusst versionierte Beispieldaten
├── docs/          # Architektur, Runbooks, ADRs und Troubleshooting
├── manifests/     # technische Kontroll- und Statusartefakte
├── scripts/       # CLI-, SDK- oder Hilfsskripte
└── tests/         # missionsspezifische Tests, falls erforderlich
```

Nicht jede Mission benötigt alle Unterordner. Leere Strukturen werden nicht ohne fachlichen Zweck angelegt.

## Dokumentationsregeln

Ein Missions-README muss mindestens enthalten:

- Business-Szenario und Lernziele,
- Floci-Service und exaktes AWS-Pendant,
- lokale Einschränkungen der Emulation,
- verwendete Ressourcen und Object Keys,
- Skripte und deren Zweck,
- nachvollziehbaren Fortschritts- beziehungsweise Abschlussstatus,
- Failure Injection und Troubleshooting,
- AWS-Exam-Transfer,
- Definition of Done.

Nur tatsächlich erarbeitete oder bewusst vorbereitete Artefakte werden versioniert. Lokale Secrets, große generierte Datenmengen, temporäre Downloads und Laufzeitzustände gehören nicht in Git.

## Nächster Workspace

Zu Beginn von M02 wird angelegt:

```text
missions/M02-s3-lifecycle-resilience/
```

Der M02-Workspace soll auf dem bestehenden Bucket `northstar-data-lake` aufbauen und zunächst den unveränderten Ausgangszustand dokumentieren, bevor Versioning oder Lifecycle-Regeln gesetzt werden.