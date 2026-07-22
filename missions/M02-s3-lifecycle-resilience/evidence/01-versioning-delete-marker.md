# Evidence 01 – S3 Versioning und Delete Marker

## Testumgebung

- Emulator: Floci
- AWS-Pendant: Amazon S3
- Bucket: `northstar-data-lake`
- Object Key: `mission-02/versioning/orders.csv`
- Versioning: `Enabled`
- Testdatum: 2026-07-20

## Erzeugte Versionen

### Version 1

- VersionId: `ef0dcb29-df05-45da-b82d-c38740645c3d`
- ETag: `e26ed4ce4a80d28a19d8903a2ca4250a`
- Größe: 57 Bytes
- Inhalt: `M02-001` im Status `CREATED`

### Version 2

- VersionId: `e7d72c3f-23cc-4b23-b8c9-7bef9bd0468a`
- ETag: `80f641ebcbe99cbe8eb653a8472f6695`
- Größe: 84 Bytes
- Inhalt: `M02-001` im Status `PROCESSED` und `M02-002` im Status `CREATED`

### Version 3 – Restore

- VersionId: `55bc7d3d-6cc2-4bc7-81ad-bc719e6d099b`
- ETag: `e26ed4ce4a80d28a19d8903a2ca4250a`
- Größe: 57 Bytes
- `IsLatest: true`
- Inhalt entspricht Version 1

## Delete-Marker-Test

Ein normales `DeleteObject` ohne `VersionId` erzeugte:

- `DeleteMarker: true`
- VersionId: `1f81c53f-bf12-4f18-88c8-509bfa9aa102`

Ein anschließendes `GetObject` ohne `VersionId` lieferte `NoSuchKey`. Die drei Datenversionen blieben weiterhin vorhanden.

Der Delete Marker wurde anschließend gezielt über seine `VersionId` gelöscht. Dadurch wurde Version 3 wieder sichtbar, ohne eine neue Datenversion zu erzeugen.

## Fachliche Erkenntnisse

1. Ein `PUT` unter demselben Key erzeugt bei aktiviertem Versioning eine neue Version.
2. Ein `GET` ohne `VersionId` liefert die aktuelle Version.
3. Ein `GET` mit `VersionId` liefert exakt die angegebene Version.
4. Ein Restore durch erneuten Upload erzeugt eine neue aktuelle Version.
5. Ein normales `DeleteObject` ohne `VersionId` erzeugt einen Delete Marker.
6. Das Entfernen des Delete Markers macht die vorherige Version wieder sichtbar.
7. Versioning ist kein vollständiger Ersatz für Backup, Retention oder Object Lock.

## DEA-C01 Exam Transfer

- `DeleteObject` ohne `VersionId` erzeugt in einem versionierten Bucket einen Delete Marker.
- `DeleteObject` mit `VersionId` löscht die konkrete Version dauerhaft.
- Nicht aktuelle Versionen verursachen weiterhin Speicherkosten.
- Lifecycle-Regeln müssen aktuelle und nicht aktuelle Versionen getrennt behandeln.
