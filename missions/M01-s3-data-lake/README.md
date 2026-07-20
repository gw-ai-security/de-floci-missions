# M01 – S3 Data Lake Fundamentals

## Überblick

Diese Mission bildet die Grundlage für einen lokalen, AWS-kompatiblen Data Lake mit **Floci S3**.

**Business-Szenario:**  
Northstar Commerce erhält täglich Bestelldaten und benötigt einen kostengünstigen, skalierbaren Raw Data Lake.

**Floci-Service:** Storage / S3  
**AWS-Pendant:** Amazon S3  
**Exam Mapping:** DEA-C01 – 1.1.2, 2.1.1, 2.1.2, 2.3.6  
**Geplante Dauer:** 4–6 Stunden

---

## Lernziele

Nach Abschluss der Mission kann ich:

- einen S3-Bucket als Data-Lake-Speicher anlegen,
- Raw-, Curated- und Quarantine-Zonen über Object Keys und Prefixe strukturieren,
- CSV- und NDJSON-Dateien hochladen und herunterladen,
- Objektmetadaten mit `HeadObject` lesen,
- Objekte mit `ListObjectsV2` nach Prefix untersuchen,
- Objektinhalte mit `GetObject` lesen,
- mit Python und Boto3 auf Floci S3 zugreifen,
- ETags in einem Manifest speichern,
- unveränderte und veränderte Quelldateien unterscheiden,
- eine idempotente Ingestion-Entscheidung implementieren,
- typische Fehler wie falsche Keys, leere Dateien und Encoding-Probleme analysieren.

---

## Verzeichnisstruktur

```text
M01-s3-data-lake/
├── data/          # Lokale Beispieldaten wie CSV und NDJSON
├── docs/          # Lernnotizen, Architektur und Troubleshooting
├── manifests/     # Lokal versionierte Beispiel-Manifeste
├── scripts/       # Python-/Boto3-Skripte
├── README.md
└── .gitignore
```

Nur selbst erarbeitete Missionsartefakte werden in diesem Ordner versioniert. Die verbindlichen Aufgaben stehen im zentralen Missionenplan des Projekts.

---

## Lokale Umgebung

### Endpoints und Zugangsdaten

| Einstellung | Wert |
|---|---|
| Floci API vom Host | `http://localhost:4566` |
| Floci API aus Containern | `http://floci:4566` |
| Floci UI | `http://localhost:4500` |
| Mission Control | `http://localhost:3000` |
| Region | `eu-central-1` |
| Access Key | `test` |
| Secret Key | `test` |

Die Zugangsdaten sind ausschließlich für die lokale Emulationsumgebung vorgesehen.

### Voraussetzungen

- Windows 10 oder 11
- Docker Desktop mit WSL2/Linux-Containern
- PowerShell 7
- Python 3
- Boto3
- gestartete Floci-Core-Umgebung

Boto3 installieren:

```powershell
python -m pip install boto3
```

---

## Data-Lake-Struktur

Bucket:

```text
northstar-data-lake
```

Geplante Zonen:

```text
s3://northstar-data-lake/raw/orders/
s3://northstar-data-lake/curated/orders/
s3://northstar-data-lake/quarantine/orders/
s3://northstar-data-lake/manifests/orders/
```

Beispiel eines partitionierten Object Keys:

```text
raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
```

### Bedeutung der Zonen

- **Raw:** unveränderte Quelldaten
- **Curated:** validierte und transformierte Daten
- **Quarantine:** fehlerhafte oder nicht verarbeitbare Datensätze
- **Manifests:** Verarbeitungsstatus und technische Kontrollinformationen

S3 besitzt keinen echten Verzeichnisbaum. Die sichtbaren „Ordner“ entstehen durch gemeinsame Präfixe in den Object Keys.

---

## Aktuell verwendete Objekte

### Quelldatei

```text
Bucket: northstar-data-lake
Key:    raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv
ETag:   e164166585e43b349d331c7803de041d
```

### Manifest

```text
Bucket: northstar-data-lake
Key:    manifests/orders/orders_20260719T094506Z.json
```

Beispielinhalt:

```json
{
  "bucket": "northstar-data-lake",
  "object_key": "raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv",
  "etag": "e164166585e43b349d331c7803de041d",
  "size_bytes": 214,
  "processed_at": "2026-07-19T10:30:00Z",
  "status": "INGESTED"
}
```

Der im Manifest gespeicherte ETag gehört zur CSV-Quelldatei. Der ETag des Manifest-Objects selbst ist ein separater Wert.

---

## Skripte

Die bisherigen Lernskripte werden unter `scripts/` abgelegt.

| Skript | Zweck | Status |
|---|---|---|
| `head_object_test.py` | Metadaten eines S3-Objects lesen | erledigt |
| `get_object_test.py` | Inhalt eines S3-Objects lesen | erledigt |
| `etag_check.py` | aktuellen ETag der CSV lesen | erledigt |
| `manifest_read.py` | gespeicherten ETag aus dem Manifest lesen | erledigt |
| `compare_etags.py` | aktuellen und gespeicherten ETag vergleichen | in Arbeit |
| `idempotent_upload.py` | Upload bzw. Verarbeitung nur bei Änderungen | offen |

Die Skriptnamen können später konsolidiert werden. Während der Lernphase bleiben die einzelnen Schritte getrennt, damit jeder API-Aufruf nachvollziehbar ist.

---

## Ausführung

In den Skriptordner wechseln:

```powershell
cd C:\dev\de-floci-missions\missions\M01-s3-data-lake\scripts
```

Beispiele:

```powershell
python .\head_object_test.py
python .\get_object_test.py
python .\etag_check.py
python .\manifest_read.py
python .\compare_etags.py
```

---

## Idempotenzlogik

Ziel der Mission ist eine Ingestion, die dieselbe unveränderte Datei nicht mehrfach verarbeitet.

```text
aktuellen ETag der Quelldatei lesen
                ↓
gespeicherten ETag aus Manifest lesen
                ↓
             vergleichen
          ┌─────┴─────┐
          │           │
        gleich      verschieden
          │           │
         SKIP       PROCESS
```

Entscheidungsregel:

```text
current_etag == stored_etag
→ Quelle ist unverändert
→ Verarbeitung überspringen

current_etag != stored_etag
→ Quelle wurde geändert
→ Datei erneut verarbeiten und Manifest aktualisieren
```

Diese Logik reduziert doppelte Verarbeitung bei wiederholten Aufrufen oder mehrfach zugestellten Events.

> Hinweis: In echtem Amazon S3 ist ein ETag nicht in jedem Fall eine einfache MD5-Prüfsumme, zum Beispiel bei Multipart-Uploads oder bestimmten Verschlüsselungsarten. Für robuste Produktionslösungen können zusätzliche Checksums, Version IDs oder fachliche Idempotency Keys erforderlich sein.

---

## Bisheriger Fortschritt

### Kernaufgaben

- [x] Bucket `northstar-data-lake` angelegt
- [x] Zonen `raw`, `curated` und `quarantine` geplant
- [x] CSV- und NDJSON-Beispieldaten erstellt
- [x] Objekte hochgeladen
- [x] Metadaten mit `HeadObject` geprüft
- [x] Prefixe mit `ListObjectsV2` untersucht
- [x] Datei mit `GetObject` heruntergeladen
- [x] Datei mit Python/Boto3 gelesen
- [x] ETag in einem Manifest gespeichert
- [ ] ETags programmatisch vergleichen
- [ ] idempotente Upload-/Ingestion-Funktion fertigstellen

### Deliverables

- [ ] S3-Namenskonvention dokumentieren
- [x] Manifest-Datei erstellen
- [ ] finales Upload-/Ingestion-Skript erstellen
- [ ] Architekturdiagramm erstellen

### Failure Injection

- [x] UTF-8-BOM beim JSON-Parsing untersucht
- [x] 0-Byte Folder Marker erkannt
- [ ] falschen Object Key testen
- [ ] leere Datei testen
- [ ] denselben Key mit geändertem Inhalt testen
- [ ] weitere ungültige Encodings testen

---

## Troubleshooting

### `JSONDecodeError: Unexpected UTF-8 BOM`

**Symptom**

```text
json.decoder.JSONDecodeError:
Unexpected UTF-8 BOM (decode using utf-8-sig)
```

**Ursache**

Das JSON-Object enthält am Anfang ein UTF-8 Byte Order Mark (BOM). S3 speichert Bytes unverändert und validiert nicht, ob ein Object gültiges JSON enthält.

**Lösung**

Statt:

```python
manifest_content = response["Body"].read().decode("utf-8")
```

verwenden:

```python
manifest_content = response["Body"].read().decode("utf-8-sig")
```

**Data-Engineering-Lerneffekt**

Ein erfolgreicher S3-Download bedeutet nicht, dass der Inhalt fachlich oder technisch valide ist. Encoding, Schema und Datenqualität müssen in der Pipeline geprüft werden.

---

## AWS-Exam-Transfer

### `HeadObject` oder `GetObject`

- `HeadObject`: Metadaten lesen, ohne den Objektinhalt herunterzuladen
- `GetObject`: Objektinhalt lesen oder herunterladen

### Prefixe

Ein Prefix ist ein gemeinsamer Anfang mehrerer Object Keys. Es handelt sich nicht um ein echtes Verzeichnis.

### Object-Identität

Ein S3-Object wird durch die Kombination aus Bucket und vollständig qualifiziertem Object Key adressiert:

```text
Bucket + Object Key
```

Der Dateiname allein ist nicht eindeutig.

### S3 als Data-Lake-Basis

Amazon S3 ist eine typische Speicherschicht für Data Lakes, weil es skalierbaren Object Storage bereitstellt und sich mit Diensten wie Glue, Athena, EMR und Lake Formation integrieren lässt.

---

## Nächste Schritte

1. `compare_etags.py` ausführen und das Ergebnis `SAME` verifizieren.
2. CSV-Inhalt unter demselben Key verändern und `CHANGED` verifizieren.
3. aus dem Vergleich eine Entscheidung `SKIP` oder `PROCESS` ableiten.
4. Manifest nach erfolgreicher Verarbeitung aktualisieren.
5. Fehlerfälle dokumentieren.
6. Namenskonvention und Architekturdiagramm ergänzen.
7. Mission-Control-Meilensteine abschließen.
8. Änderungen mit Git versionieren.

---

## Definition of Done

M01 ist abgeschlossen, wenn:

- alle neun Kernaufgaben umgesetzt sind,
- mindestens mehrere Failure-Injection-Szenarien reproduziert und dokumentiert wurden,
- Manifest, finales Skript, Namenskonvention und Architekturdiagramm vorhanden sind,
- die Idempotenzentscheidung mit unverändertem und verändertem Inhalt getestet wurde,
- die wichtigsten Exam-Entscheidungen erklärt werden können,
- alle zugehörigen Meilensteine in Mission Control abgehakt sind.
