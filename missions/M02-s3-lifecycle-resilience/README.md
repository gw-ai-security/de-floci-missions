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
- Storage Classes anhand von Zugriffsmuster, Resilienz, Kosten und Abrufzeit auswählen
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
│   ├── backup-restore-runbook.md
│   └── replication-architecture.md
├── evidence/
│   ├── 01-versioning-delete-marker.md
│   └── 02-lifecycle-configuration.md
├── policies/
│   └── lifecycle-version-history.json
├── scripts/
└── tests/
```

## Arbeitsregeln

1. Produktive Artefakte aus Mission 01 werden nicht für Experimente überschrieben.
2. Tests verwenden den Prefix `mission-02/` oder einen klar benannten Test-Bucket.
3. Jede Änderung wird vor und nach der Ausführung überprüft.
4. Floci-Ergebnisse werden von AWS-Theorie und echten AWS-Garantien getrennt dokumentiert.
5. Zugangsdaten, lokale Konfigurationsdateien und temporäre Dateien werden nicht committed.
6. JSON- und Markdown-Dateien werden als UTF-8 ohne BOM gespeichert, wenn sie von CLI-Werkzeugen verarbeitet werden.

## Fortschritt

- [x] Ausgangszustand des Buckets erfassen
- [x] Versioning auf `northstar-data-lake` aktivieren
- [x] Mehrere Versionen desselben Objekts erzeugen
- [x] Frühere Version gezielt abrufen und als neue aktuelle Version wiederherstellen
- [x] Delete Marker erzeugen, untersuchen und entfernen
- [x] Lifecycle-Konfiguration definieren, anwenden und zurücklesen
- [ ] Storage-Class-Entscheidung vollständig dokumentieren
- [x] Replikationsarchitektur theoretisch entwerfen
- [x] Backup- und Restore-Runbook erstellen und praktisch testen
- [x] Failure Injection für Überschreiben und versehentliches Löschen durchführen
- [ ] Object Lock und Verschlüsselung fachlich einordnen
- [ ] Optional: S3 Select an CSV oder JSON testen, sofern lokal unterstützt
- [ ] Abschließenden DEA-C01-Transfer und Missions-Recap erstellen

## Nachgewiesener technischer Stand

### Versioning

Der Bucket `northstar-data-lake` besitzt aktiviertes Versioning:

```json
{
  "Status": "Enabled"
}
```

Für den Key `mission-02/versioning/orders.csv` wurden drei Datenversionen erzeugt. Eine ältere Version wurde gezielt abgerufen und durch erneuten Upload als neue aktuelle Version wiederhergestellt. Ein normales `DeleteObject` erzeugte einen Delete Marker; nach dessen gezielter Entfernung wurde die vorherige aktuelle Datenversion wieder sichtbar.

### Lifecycle

Die Regel `m02-version-history-management` ist für den Prefix `mission-02/versioning/` aktiviert:

- nicht aktuelle Versionen nach 30 Tagen zu `STANDARD_IA` verschieben
- nicht aktuelle Versionen nach 90 Tagen endgültig löschen
- verwaiste Delete Marker entfernen

Floci meldete `TransitionDefaultMinimumObjectSize: all_storage_classes_128K`. Die kleinen Testobjekte liegen unter 128 KB. Daher ist die gespeicherte Regel nachgewiesen, nicht jedoch eine reale zeitgesteuerte Transition.

### Backup und Replikation

Das Restore-Runbook trennt zwei Recovery-Fälle:

- Delete Marker entfernen, ohne eine neue Datenversion zu erzeugen
- ältere Version lesen und erneut hochladen, wodurch eine neue aktuelle Version entsteht

Die theoretische Zielarchitektur verwendet Cross-Region Replication in ein separates AWS-Konto. Replikation wird ausdrücklich nicht als vollständiger Backup-Ersatz behandelt.

## Grenzen des bisherigen Nachweises

In Floci wurden Versioning, Versionabruf, Restore, Delete Marker und Lifecycle-Konfiguration praktisch geprüft. Noch nicht praktisch nachgewiesen sind insbesondere:

- reale Lifecycle-Ausführung nach Ablauf der konfigurierten Tage
- reale Storage-Class-Transitionen und Abrufkosten
- Same-Region- oder Cross-Region-Replikation
- Cross-Account-IAM- und KMS-Konfiguration
- S3 Replication Time Control
- Object Lock und produktive Compliance-Garantien
- reale AWS-Dauerhaftigkeit, Verfügbarkeit und Kosten

## Nächster Arbeitsschritt

Als Nächstes wird die Storage-Class-Entscheidung für aktuelle Daten, nicht aktuelle Versionen, selten genutzte Daten und Archivdaten dokumentiert. Dabei werden `STANDARD`, `STANDARD_IA`, `ONEZONE_IA` sowie die Glacier-Klassen anhand von Zugriffshäufigkeit, Mindestaufbewahrung, Resilienz, Abruflatenz und Kostenrisiken verglichen.
