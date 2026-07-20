# Mission 02 – S3 Lifecycle & Resilience

**Status:** In Bearbeitung  
**AWS-Dienste:** Amazon S3, S3 Versioning, Lifecycle Configuration, S3 Glacier Storage Classes, Replication, Object Lock, Server-Side Encryption  
**Lokale Umgebung:** Floci (`floci/floci:1.5.33-compat`)

## Missionsziel

In dieser Mission wird der bestehende Data Lake aus Mission 01 gegen versehentliches Löschen, Überschreiben und ungeeignete Aufbewahrungsregeln abgesichert. Dabei werden S3-Versionierung, Delete Marker, Lifecycle-Regeln, Storage Classes sowie Backup-, Restore- und Resilience-Entscheidungen untersucht.

## Lernziele

- S3-Versionierung aktivieren und Objektversionen gezielt abrufen
- Delete Marker und permanente Löschung einzelner Versionen unterscheiden
- Lifecycle-Transition und Lifecycle-Expiration korrekt einsetzen
- Storage Classes anhand Zugriffsmuster, Resilienz, Kosten und Abrufzeit auswählen
- Replikation von Backup unterscheiden
- RPO und RTO für einen Data-Lake-Workload begründen
- Grenzen der lokalen Floci-Emulation gegenüber echtem AWS dokumentieren

## Verzeichnisstruktur

```text
M02-s3-lifecycle-resilience/
├── README.md
├── data/
│   ├── input/
│   └── recovered/
├── docs/
├── evidence/
├── policies/
├── scripts/
└── tests/
```

## Arbeitsregeln

1. Produktive Artefakte aus Mission 01 werden nicht für Experimente überschrieben.
2. Tests verwenden den Prefix `mission-02/` oder einen klar benannten Test-Bucket.
3. Jede Änderung wird vor und nach der Ausführung überprüft.
4. Floci-Ergebnisse werden von AWS-Theorie und echten AWS-Garantien getrennt dokumentiert.
5. Zugangsdaten, lokale Konfigurationsdateien und temporäre Dateien werden nicht committed.

## Geplante Arbeitsschritte

- [x] Ausgangszustand des Buckets erfassen
- [x] Versioning auf `northstar-data-lake` aktivieren
- [ ] Mehrere Versionen desselben Objekts erzeugen
- [ ] Frühere Version gezielt abrufen und wiederherstellen
- [ ] Delete Marker untersuchen
- [ ] Lifecycle-Konfiguration definieren und validieren
- [ ] Storage-Class-Entscheidung dokumentieren
- [ ] Replikations- und Backup-Architektur entwerfen
- [ ] Restore-Runbook erstellen und testen
- [ ] Failure-Injection-Ergebnisse dokumentieren
- [ ] Exam-Transfer abschließen

## Aktueller technischer Stand

Der Bucket `northstar-data-lake` besitzt aktiviertes Versioning:

```json
{
  "Status": "Enabled"
}
```

Bestehende Objekte aus der Zeit vor der Aktivierung besitzen weiterhin die Version ID `null`. Neue Schreibvorgänge sollen eindeutige Version IDs erzeugen.
