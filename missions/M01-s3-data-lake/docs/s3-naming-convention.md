# M01 – S3-Namenskonvention

## Zweck

Diese Konvention definiert die Object-Key-Struktur für den lokalen Northstar-Commerce-Data-Lake in Floci S3 und das entsprechende AWS-Pendant Amazon S3.

Ziele:

- konsistente und vorhersehbare Object Keys,
- eindeutige Trennung der Data-Lake-Zonen,
- einfache Suche über Prefixe,
- nachvollziehbare Ingestion-Zeitpunkte,
- Vorbereitung auf Partitionierung und spätere Athena-/Glue-Nutzung,
- reproduzierbare und idempotente Verarbeitung.

---

## Grundstruktur

```text
<zone>/<dataset>/ingestion_date=YYYY-MM-DD/<dataset>_<UTC-timestamp>.<extension>
```

Beispiel:

```text
raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

Die vollständige S3-URI lautet:

```text
s3://northstar-data-lake/raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

---

## Data-Lake-Zonen

### Raw

```text
raw/<dataset>/...
```

Enthält unveränderte Quelldaten.

Regeln:

- Inhalt nach erfolgreichem Upload nicht fachlich verändern.
- Originalformat und Originalwerte erhalten.
- Keine Bereinigung oder Transformation in der Raw-Zone.
- Änderungen unter demselben Key müssen über ETag oder eine andere Prüfsumme erkannt werden.

Beispiel:

```text
raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

### Curated

```text
curated/<dataset>/...
```

Enthält validierte, bereinigte oder transformierte Daten für Analysen und nachgelagerte Verarbeitung.

Beispiel:

```text
curated/orders/processing_date=2026-07-19/orders_20260719T101500Z.parquet
```

Die konkrete Curated-Struktur wird in späteren Missionen erweitert, insbesondere für Parquet, Partitionierung und Athena.

### Quarantine

```text
quarantine/<dataset>/...
```

Enthält technisch oder fachlich ungültige Eingabedaten.

Beispiele für Quarantänegründe:

- leere Datei,
- ungültiges Encoding,
- fehlende Pflichtspalten,
- nicht parsebare Datensätze,
- falsches Schema.

Beispiel:

```text
quarantine/orders/ingestion_date=2026-07-19/orders_20260719T110000Z_invalid.csv
```

### Manifests

```text
manifests/<dataset>/...
```

Enthält technischen Verarbeitungsstatus und Idempotenzinformationen.

Beispiel:

```text
manifests/orders/orders_20260719T094506Z.json
```

Ein Manifest kann unter anderem enthalten:

```json
{
  "bucket": "northstar-data-lake",
  "object_key": "raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv",
  "etag": "example-etag",
  "size_bytes": 298,
  "record_count": 6,
  "processed_at": "2026-07-19T10:45:00+00:00",
  "status": "INGESTED"
}
```

---

## Benennungsregeln

### 1. Kleinschreibung

Bucket-Namen, Zonen und Dataset-Namen werden ausschließlich kleingeschrieben.

Korrekt:

```text
raw/orders/
```

Nicht verwenden:

```text
Raw/Orders/
```

### 2. Keine Leerzeichen

Object Keys enthalten keine Leerzeichen.

Für zusammengesetzte Begriffe werden bevorzugt Bindestriche verwendet.

Korrekt:

```text
customer-orders
```

Nicht verwenden:

```text
customer orders
```

### 3. Dataset-Namen

Dataset-Namen beschreiben die fachliche Entität im Plural.

Beispiele:

```text
orders
customers
payments
shipments
```

### 4. Partition-ähnliche Prefixe

Technische Datumsbereiche verwenden das Muster:

```text
<partition_name>=<partition_value>
```

Beispiel:

```text
ingestion_date=2026-07-19
```

Dieses Hive-kompatible Muster erleichtert die spätere Verwendung mit AWS Glue und Amazon Athena.

### 5. Zeitstempel

Dateinamen verwenden UTC-Zeitstempel im kompakten ISO-8601-Format:

```text
YYYYMMDDTHHMMSSZ
```

Beispiel:

```text
20260719T094506Z
```

Das abschließende `Z` kennzeichnet UTC.

### 6. Dateiname

Der Dateiname folgt dem Muster:

```text
<dataset>_<UTC-timestamp>.<extension>
```

Beispiel:

```text
orders_20260719T094506Z.csv
```

### 7. Dateierweiterungen

Zulässige Erweiterungen richten sich nach dem tatsächlichen Dateiformat.

Beispiele:

```text
.csv
.ndjson
.json
.parquet
```

Eine Datei darf nicht nur durch Umbenennen eine andere Erweiterung erhalten.

### 8. Object Keys sind vollständig qualifiziert

Ein Dateiname allein identifiziert kein S3-Object eindeutig.

Die Identität eines Objekts ergibt sich aus:

```text
Bucket + vollständiger Object Key
```

Beispiel:

```text
Bucket: northstar-data-lake
Key:    raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

### 9. Prefixe sind keine echten Ordner

Amazon S3 und Floci S3 verwenden einen flachen Namespace.

Die sichtbare Ordnerstruktur entsteht nur durch gemeinsame Zeichenfolgen am Anfang der Object Keys.

Beispiel-Prefix:

```text
raw/orders/
```

### 10. Folder Marker vermeiden

0-Byte-Folder-Marker sind für die Verarbeitung nicht erforderlich.

Falls eine GUI solche Objekte erzeugt, dürfen sie nicht als Quelldateien verarbeitet werden.

Eine Pipeline muss daher mindestens prüfen:

- Object Key,
- Object-Größe,
- Dateityp,
- erwartetes Dataset.

---

## Idempotenzregel

Für M01 wird der ETag des Quellobjekts im Manifest gespeichert.

```text
aktueller ETag == gespeicherter ETag
→ SKIP

aktueller ETag != gespeicherter ETag
→ PROCESS
```

Das Manifest wird ausschließlich nach erfolgreicher Verarbeitung aktualisiert.

```text
Validierung erfolgreich
→ Manifest aktualisieren

Validierung fehlgeschlagen
→ Manifest unverändert lassen
```

Hinweis für echtes AWS:

Ein S3-ETag ist nicht in jedem Fall eine einfache MD5-Prüfsumme, insbesondere bei Multipart-Uploads oder bestimmten Verschlüsselungsarten. Produktionslösungen können zusätzlich S3 Checksums, Version IDs oder fachliche Idempotency Keys verwenden.

---

## Verbindliche M01-Beispiele

### CSV-Quelldatei

```text
raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

### NDJSON-Quelldatei

```text
raw/orders/ingestion_date=2026-07-19/orders_20260719T101500Z.ndjson
```

### Manifest

```text
manifests/orders/orders_20260719T094506Z.json
```

### Zukünftiges Curated-Objekt

```text
curated/orders/processing_date=2026-07-19/orders_20260719T101500Z.parquet
```

### Quarantäneobjekt

```text
quarantine/orders/ingestion_date=2026-07-19/orders_20260719T110000Z_invalid.csv
```

---

## Prüfliste für neue Object Keys

Vor einem Upload ist zu prüfen:

- [ ] richtige Data-Lake-Zone gewählt,
- [ ] Dataset kleingeschrieben,
- [ ] keine Leerzeichen im Key,
- [ ] Datums-Prefix im Format `name=YYYY-MM-DD`,
- [ ] UTC-Zeitstempel im Dateinamen,
- [ ] Dateierweiterung entspricht dem Inhalt,
- [ ] vollständiger Object Key ist eindeutig,
- [ ] Manifest-Key kann eindeutig abgeleitet werden,
- [ ] Folder Marker wird nicht als Datendatei verarbeitet.

---

## AWS-DEA-C01-Transfer

Diese Konvention unterstützt mehrere prüfungsrelevante Konzepte:

- Prefixe strukturieren S3-Objekte, sind aber keine echten Verzeichnisse.
- Hive-kompatible Partition-Prefixe unterstützen Glue- und Athena-Workloads.
- Raw- und Curated-Zonen trennen unveränderte Quellen von analysierbaren Daten.
- ETags oder Checksums unterstützen Change Detection und Idempotenz.
- Das Manifest darf nur den zuletzt erfolgreich verarbeiteten Zustand repräsentieren.
- Konsistente Object Keys verbessern Betrieb, Fehlersuche und Data Governance.
