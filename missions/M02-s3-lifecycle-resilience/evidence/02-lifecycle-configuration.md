# Evidence 02 – S3 Lifecycle-Konfiguration

## Testumgebung

- Emulator: Floci
- AWS-Pendant: Amazon S3
- Bucket: `northstar-data-lake`
- Prefix: `mission-02/versioning/`

## Ausgangszustand

`GetBucketLifecycleConfiguration` lieferte:

```text
NoSuchLifecycleConfiguration
```

Damit war zunächst keine Lifecycle-Konfiguration vorhanden.

## Konfigurierte Regel

- Rule ID: `m02-version-history-management`
- Status: `Enabled`
- Filter-Prefix: `mission-02/versioning/`
- nicht aktuelle Versionen:
  - Transition nach 30 Tagen zu `STANDARD_IA`
  - endgültige Löschung nach 90 Tagen
- verwaiste Delete Marker:
  - automatische Entfernung aktiviert

## Verifikation

Die Konfiguration wurde über `GetBucketLifecycleConfiguration` erfolgreich zurückgelesen.

Floci meldete zusätzlich:

```text
TransitionDefaultMinimumObjectSize: all_storage_classes_128K
```

Die vorhandenen Testobjekte sind kleiner als 128 KB. Daher wurde nur die Konfiguration, nicht eine reale Transition nachgewiesen.

## Fachliche Erkenntnisse

1. Aktuelle und nicht aktuelle Versionen werden durch getrennte Lifecycle-Aktionen behandelt.
2. `NoncurrentVersionExpiration` löscht ältere Versionen dauerhaft.
3. Versioning verhindert keine absichtliche Lifecycle-Löschung.
4. Eine akzeptierte Konfiguration beweist noch keine tatsächlich ausgeführte Transition.
5. Storage-Class-Wechsel, Zeitabläufe und Kosten müssen in echtem AWS separat validiert werden.

## DEA-C01 Exam Transfer

- `Transition` verschiebt aktuelle Versionen.
- `NoncurrentVersionTransition` verschiebt ältere Versionen.
- `Expiration` behandelt aktuelle Versionen beziehungsweise Delete Marker.
- `NoncurrentVersionExpiration` löscht frühere Versionen.
- Lifecycle ist Kostenoptimierung, beeinflusst aber gleichzeitig die Wiederherstellbarkeit.
