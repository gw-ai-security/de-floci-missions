# M01 – S3 Data Lake Fundamentals

## Status

**Abgeschlossen am 20. Juli 2026.**

Der Abschluss wurde bestätigt und anhand der versionierten Artefakte geprüft: Beispieldaten, Manifest-Dateien, sieben Boto3-Lernskripte, S3-Namenskonvention und Architektur-/Failure-Injection-Dokumentation sind vorhanden.

## Überblick

Diese Mission bildet die Grundlage für einen lokalen, AWS-kompatiblen Data Lake mit **Floci S3**.

**Business-Szenario:** Northstar Commerce erhält täglich Bestelldaten und benötigt einen kostengünstigen, skalierbaren Raw Data Lake.

| Zuordnung | Wert |
|---|---|
| Floci-Service | Storage / S3 |
| AWS-Pendant | Amazon S3 |
| Exam Mapping | DEA-C01 – 1.1.2, 2.1.1, 2.1.2, 2.3.6 |
| Emulationsklasse | A – wesentliches lokales Data Plane |
| Dauer laut Plan | 4–6 Stunden |

## Erreichte Lernziele

Nach Abschluss der Mission kann ich:

- einen S3-Bucket als Data-Lake-Speicher anlegen,
- Raw-, Curated-, Quarantine- und Manifest-Zonen über Object Keys und Prefixe strukturieren,
- CSV- und NDJSON-Dateien hochladen und herunterladen,
- Objektmetadaten mit `HeadObject` lesen,
- Objekte mit `ListObjectsV2` nach Prefix untersuchen,
- Objektinhalte mit `GetObject` lesen,
- mit Python und Boto3 auf Floci S3 zugreifen,
- ETags in einem Manifest speichern und vergleichen,
- unveränderte und veränderte Quelldateien unterscheiden,
- eine idempotente Ingestion-Entscheidung implementieren,
- das Manifest erst nach erfolgreicher Validierung aktualisieren,
- typische Fehler wie falsche Keys, leere Dateien und Encoding-Probleme analysieren.

## Verzeichnisstruktur

```text
M01-s3-data-lake/
├── data/          # versionierte CSV- und NDJSON-Beispieldaten
├── docs/
│   ├── architecture.md
│   └── s3-naming-convention.md
├── manifests/     # Beispiel-Manifeste
├── scripts/       # nummerierte Python-/Boto3-Lernschritte
├── README.md
└── .gitignore
```

## Lokale Umgebung

| Einstellung | Wert |
|---|---|
| Floci API vom Host | `http://localhost:4566` |
| Floci API aus Containern | `http://floci:4566` |
| Floci UI | `http://localhost:4500` |
| Mission Control | `http://localhost:3000` |
| Region | `eu-central-1` |
| lokale Dummy-Credentials | `test` / `test` |

Die Credentials sind ausschließlich für die lokale Emulationsumgebung vorgesehen.

## Data-Lake-Struktur

Bucket:

```text
northstar-data-lake
```

Logische Zonen:

```text
s3://northstar-data-lake/raw/orders/
s3://northstar-data-lake/curated/orders/
s3://northstar-data-lake/quarantine/orders/
s3://northstar-data-lake/manifests/orders/
```

Verwendeter Source Key:

```text
raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

Verwendeter Manifest Key:

```text
manifests/orders/orders_20260719T094506Z.json
```

S3 besitzt keinen echten Verzeichnisbaum. Die sichtbaren „Ordner“ entstehen durch gemeinsame Präfixe in den Object Keys.

## Implementierte Lernskripte

| Skript | Zweck | Status |
|---|---|---|
| `01_head_object_test.py` | ETag, Größe, Zeitpunkt und Content Type mit `HeadObject` lesen | erledigt |
| `02_get_object_test.py` | Objektinhalt mit `GetObject` lesen | erledigt |
| `03_etag_check.py` | aktuellen Source-ETag ermitteln | erledigt |
| `04_manifest_read.py` | gespeicherten ETag aus dem Manifest lesen | erledigt |
| `05_compare_etags.py` | `SKIP` oder `PROCESS` aus dem ETag-Vergleich ableiten | erledigt |
| `06_update_manifest.py` | Manifest mit aktuellem ETag und technischem Status aktualisieren | erledigt |
| `07_idempotent_ingestion.py` | vollständige idempotente Ingestion mit Validierung und Commit-after-success | erledigt |

Die Skripte bleiben bewusst in einzelne Lernschritte getrennt. `07_idempotent_ingestion.py` ist die konsolidierte Abschlussimplementierung.

## Idempotenzlogik

```text
HeadObject auf Source
        ↓
aktuellen ETag lesen
        ↓
Manifest mit GetObject lesen
        ↓
gespeicherten ETag ermitteln
        ↓
Current ETag == Stored ETag?
        ├── Ja  → SKIP
        └── Nein → PROCESS
                    ↓
              Datei laden
                    ↓
              Inhalt validieren
                    ↓
              Manifest schreiben
```

Entscheidungsregel:

```text
current_etag == stored_etag
→ Quelle ist unverändert
→ Verarbeitung überspringen

current_etag != stored_etag
→ Quelle ist neu oder verändert
→ verarbeiten und Manifest erst nach Erfolg aktualisieren
```

Das Manifest folgt dem **Commit-after-success-Muster**. Bei fehlendem Objekt, leerer Datei, unbrauchbarem Inhalt, ungültigem Encoding oder fehlenden Datenzeilen wird der erfolgreiche Verarbeitungszustand nicht überschrieben.

## Abschlussnachweis

### Kernaufgaben

- [x] Bucket `northstar-data-lake` angelegt
- [x] Zonen `raw`, `curated`, `quarantine` und `manifests` geplant
- [x] CSV- und NDJSON-Beispieldaten erstellt
- [x] Objekte hochgeladen
- [x] Metadaten mit `HeadObject` geprüft
- [x] Prefixe mit `ListObjectsV2` untersucht
- [x] Datei mit `GetObject` heruntergeladen
- [x] Datei mit Python/Boto3 gelesen
- [x] ETag in einem Manifest gespeichert
- [x] ETags programmatisch verglichen
- [x] idempotente Ingestion mit `SKIP` und `PROCESS` umgesetzt
- [x] Manifest-Update nach erfolgreicher Verarbeitung umgesetzt

### Deliverables

- [x] S3-Namenskonvention: [`docs/s3-naming-convention.md`](docs/s3-naming-convention.md)
- [x] Manifest-Beispiele: [`manifests/`](manifests/)
- [x] finales Ingestion-Skript: [`scripts/07_idempotent_ingestion.py`](scripts/07_idempotent_ingestion.py)
- [x] Architekturdiagramm und Ablaufbeschreibung: [`docs/architecture.md`](docs/architecture.md)

### Failure Injection und Fehlerbehandlung

Die folgenden Fälle sind im Code beziehungsweise im Architektur- und Troubleshooting-Nachweis abgedeckt:

- [x] falscher oder fehlender Source Key
- [x] 0-Byte-Datei
- [x] Datei ohne Datenzeilen
- [x] gleicher Key mit verändertem Inhalt
- [x] unveränderte Datei
- [x] UTF-8-BOM beim JSON-/CSV-Decoding
- [x] ungültiges Encoding vor dem Manifest-Commit
- [x] 0-Byte Folder Marker als ungeeignete Datenquelle

## Troubleshooting: UTF-8-BOM

**Symptom:**

```text
json.decoder.JSONDecodeError:
Unexpected UTF-8 BOM (decode using utf-8-sig)
```

**Ursache:** S3 speichert Bytes unverändert. Ein erfolgreicher Download beweist weder gültiges JSON noch korrektes Encoding.

**Verwendete Lösung:**

```python
manifest_content = response["Body"].read().decode("utf-8-sig")
```

**Data-Engineering-Lerneffekt:** Transporterfolg und Datenqualität sind getrennte Prüfungen. Encoding, Schema, Pflichtfelder und fachliche Validität müssen explizit geprüft werden.

## AWS-Exam-Transfer

### `HeadObject` vs. `GetObject`

- `HeadObject`: Metadaten lesen, ohne den Objektinhalt herunterzuladen
- `GetObject`: Objektinhalt lesen oder herunterladen

### Object-Identität

Ein S3-Objekt wird adressiert durch:

```text
Bucket + vollständiger Object Key
```

Der Dateiname allein ist nicht eindeutig.

### Prefixe

Ein Prefix ist ein gemeinsamer Anfang mehrerer Object Keys. Es handelt sich nicht um ein echtes Verzeichnis.

### ETag-Grenze

Ein ETag ist in echtem Amazon S3 nicht immer eine einfache MD5-Prüfsumme, insbesondere bei Multipart-Uploads oder bestimmten Verschlüsselungsarten. Robuste Produktionslösungen können zusätzlich verwenden:

- S3 Checksum-Felder,
- Version IDs,
- fachliche Idempotency Keys,
- ein persistentes Processing Ledger.

### S3 als Data-Lake-Basis

Amazon S3 ist eine typische Speicherschicht für Data Lakes und integriert sich unter anderem mit AWS Glue, Amazon Athena, Amazon EMR und AWS Lake Formation.

## Kritische technische Einordnung

Die M01-Skripte sind nachvollziehbare Lernartefakte, aber noch keine produktionsreife Ingestion Library. Endpoint, Bucket und Object Keys sind teilweise hardcodiert; automatisierte Tests, strukturierte Logs, Konfigurationsvalidierung, Quarantine Writes und produktive IAM-/KMS-Kontrollen folgen in späteren Missionen.

Das ist für M01 akzeptabel, weil der Scope auf S3-Grundlagen, Metadatenzugriff und Idempotenzentscheidung begrenzt war. Eine vorzeitige Generalisierung hätte den Lernzweck verschlechtert.

## Definition of Done

M01 gilt als abgeschlossen, weil:

- die S3-Grundoperationen praktisch umgesetzt sind,
- CSV- und NDJSON-Daten versioniert vorliegen,
- Manifest und ETag-Vergleich funktionieren,
- eine konsolidierte idempotente Ingestion vorhanden ist,
- Validierungsfehler das Manifest nicht fälschlich aktualisieren,
- Namenskonvention und Architektur dokumentiert sind,
- Failure-Injection-Szenarien und AWS-Grenzen beschrieben sind,
- die zentralen Exam-Entscheidungen erklärt werden können.

## Übergang zu M02

M02 baut auf demselben Bucket auf und ergänzt:

- S3 Versioning,
- Version IDs und frühere Objektversionen,
- Delete Marker und Restore,
- Lifecycle Transition und Expiration,
- Storage-Class-Entscheidungen,
- Replikations-, Backup- und Resilienzdesign,
- Object Lock, Verschlüsselung sowie RPO/RTO.

Vor der ersten Änderung wird der aktuelle Bucket-Zustand erfasst. Der M01-Workspace wird funktional nicht weiter ausgebaut, außer ein späterer Refactoring- oder Fehlerbefund macht eine gezielte Korrektur erforderlich.