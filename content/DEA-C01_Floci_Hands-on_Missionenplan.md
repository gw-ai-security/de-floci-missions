# AWS Certified Data Engineer – Associate (DEA-C01)
# Floci Hands-on Missionenplan

**Version:** 1.0  
**Stand:** 17. Juli 2026  
**Ziel:** Exam-orientierte, praxisnahe Vorbereitung auf **AWS Certified Data Engineer – Associate (DEA-C01)** mit **Floci** als lokaler AWS-Emulationsumgebung.

---

## 0. Zweck dieses Dokuments

Dieses Dokument ist kein weiterer linearer AWS-Kurs. Es ist ein vollständiger **Hands-on-Lehrplan**, der drei Ziele gleichzeitig verfolgt:

1. **Exam Performance**  
   AWS-Szenariofragen korrekt analysieren, plausible Distractors ausschließen und die beste AWS-konforme Lösung auswählen.

2. **Engineering Competence**  
   Datenpipelines tatsächlich bauen, testen, überwachen, absichern und Fehler diagnostizieren.

3. **Career Transfer**  
   Ergebnisse in einem GitHub-Portfolio, in technischen Interviews und in einer späteren Data-Engineer-Rolle verwenden.

Die Missionen bilden reale Aufgaben eines Junior bis Intermediate Data Engineers ab. Jede Mission verbindet:

- eine fachliche Problemstellung,
- die lokale Umsetzung in Floci,
- das zugehörige AWS-Pendant,
- Theorie,
- Fehlerdiagnose,
- Architekturentscheidungen,
- Exam-Fragen,
- einen überprüfbaren technischen Nachweis.

---

# 1. Source of Truth und Aktualitätsregel

## 1.1 Prüfungsquelle

Der maßgebliche Scope ist der aktuelle offizielle:

> **AWS Certified Data Engineer – Associate Exam Guide (DEA-C01), Version 1.1, veröffentlicht am 12. Dezember 2025**

Die Prüfung validiert laut AWS insbesondere:

- Datenpipelines implementieren,
- Daten speichern und modellieren,
- Pipelines überwachen und warten,
- Kosten- und Performanceprobleme optimieren,
- Data Quality sicherstellen,
- Daten absichern und Governance anwenden.

### Exam Domains

| Domain | Gewichtung |
|---|---:|
| Domain 1 – Data Ingestion and Transformation | 34 % |
| Domain 2 – Data Store Management | 26 % |
| Domain 3 – Data Operations and Support | 22 % |
| Domain 4 – Data Security and Governance | 18 % |

### Prüfungsformat

- 65 Fragen
- 130 Minuten
- Multiple Choice und Multiple Response
- 50 bewertete, 15 unbewertete Fragen
- Mindestpunktzahl: 720 von 1.000
- Unbeantwortete Fragen sind falsch; es gibt keinen Punktabzug für Raten.

## 1.2 Floci-Quelle

Die offizielle Floci-Service-Matrix ist die technische Source of Truth für lokal unterstützte Services und Operationen.

Floci emuliert aktuell zahlreiche AWS-Services über einen gemeinsamen Endpoint auf Port `4566` und verwendet AWS-kompatible Protokolle. Trotzdem gilt:

> **Eine lokale Emulation ist kein Beweis für identisches Produktionsverhalten in AWS.**

Vor jeder Mission ist zu prüfen:

1. Ist der Service in der aktuellen Floci-Matrix enthalten?
2. Ist nur das Control Plane oder auch das Data Plane implementiert?
3. Wird echte Verarbeitung ausgeführt oder nur ein Status simuliert?
4. Welche AWS-Funktionen fehlen?
5. Welche Exam-Aspekte müssen deshalb theoretisch oder in einem optionalen Real-AWS-Lab ergänzt werden?

---

# 2. Kritische Grenzen von Floci

## 2.1 Was Floci gut trainiert

Floci eignet sich besonders für:

- AWS CLI und SDK-Aufrufe
- AWS-kompatible APIs
- Resource Lifecycle
- lokale Integrationen zwischen Services
- Event-driven Architecture
- Lambda-Ausführung
- Queue- und Stream-Verarbeitung
- Data-Lake-Metadaten
- SQL auf lokalen S3-Daten über Athena-Emulation
- Infrastructure as Code
- Integration Tests
- Failure Injection
- reproduzierbare Entwicklungsumgebungen
- CI-Tests ohne Cloud-Kosten

## 2.2 Was Floci nicht realistisch beweist

Floci kann nicht zuverlässig nachbilden:

- reale AWS-Skalierung
- Multi-AZ- und Multi-Region-Verhalten
- AWS-Quotas unter Produktionslast
- tatsächliche Latenz und Durchsatzgrenzen
- reale AWS-Abrechnung
- alle IAM-Enforcement-Details
- vollständige KMS-, Netzwerk- und Cross-Account-Semantik
- Managed-Service-Patching
- Service Limits und regionale Unterschiede
- tatsächliche Redshift-, Lake-Formation- oder Glue-Spark-Ausführung, sofern der Service nicht vollständig emuliert wird

## 2.3 Emulationsklassen

Jede Mission erhält eine Klasse:

| Klasse | Bedeutung |
|---|---|
| **A – Reales lokales Data Plane** | Floci führt die wesentliche Verarbeitung lokal aus. |
| **B – Teilweise Emulation** | Relevante Funktionen sind vorhanden, aber einzelne AWS-Features fehlen. |
| **C – Control Plane / Statussimulation** | Ressourcen und Zustände werden emuliert, die eigentliche Compute-Verarbeitung nicht. |
| **D – Lokaler Ersatz** | AWS-Service fehlt; das Konzept wird mit DuckDB, Spark, Kafka, PostgreSQL oder einem anderen lokalen Werkzeug simuliert. |
| **E – Theorie / optionales Real-AWS-Lab** | Konzept muss geprüft werden, ist aber lokal nicht belastbar emulierbar. |

---

# 3. Pädagogisches Lernmodell

## 3.1 Lernlevel

### Level 0 – Orientierung

Du kennst:

- Domain-Gewichtungen,
- In-Scope-Services,
- Out-of-Scope-Themen,
- Lernprioritäten.

### Level 1 – Wiedererkennen

Du kannst einen Service korrekt definieren.

Beispiel:

> Amazon Athena ist eine serverlose SQL Query Engine für Daten, die typischerweise in Amazon S3 liegen.

### Level 2 – Verstehen

Du kannst erklären:

- Inputs und Outputs,
- Kostenmodell,
- Skalierung,
- Limits,
- Integrationen,
- Security,
- Monitoring.

### Level 3 – Anwenden

Du kannst einen kleinen Anwendungsfall ohne vollständige Klickanleitung umsetzen.

### Level 4 – Entscheiden

Du kannst den Service gegen plausible Alternativen abgrenzen.

Beispiele:

- Athena vs. Redshift
- Glue vs. EMR
- Kinesis vs. MSK
- Step Functions vs. MWAA
- DynamoDB vs. Aurora

### Level 5 – Integrieren

Du kannst eine End-to-End-Pipeline entwerfen und erklären.

### Level 6 – Betreiben und Troubleshooten

Du kannst Fehler finden, beheben und präventive Kontrollen ergänzen.

### Level 7 – Exam Fluency

Du kannst unter Zeitdruck:

- Keywords erkennen,
- Distractors eliminieren,
- Multi-Response-Fragen korrekt lösen,
- Kosten, Performance, Security und Operational Overhead abwägen.

---

## 3.2 Standardstruktur jeder Mission

Jede Mission wird in dieser Reihenfolge durchgeführt:

1. **Problemstellung**
2. **Anforderungen extrahieren**
3. **Architekturhypothese**
4. **Theorieblock**
5. **Umsetzung über GUI**
6. **Umsetzung über AWS CLI oder SDK**
7. **Automatisierung mit IaC**
8. **Tests**
9. **Absichtlicher Fehler**
10. **Troubleshooting**
11. **AWS-Reality-Check**
12. **Exam Transfer**
13. **Recall Check**
14. **Dokumentation und Commit**

## 3.3 Tutor-Regeln für das neue ChatGPT-Projekt

Der Tutor soll:

- immer zuerst das reale Problem formulieren,
- pro Schritt nur eine kleine Aufgabe geben,
- zu jedem Floci-Service immer das AWS-Pendant nennen,
- nicht sofort die vollständige Lösung verraten,
- Verständnisfragen stellen,
- Fehlvorstellungen präzise korrigieren,
- Screenshots und CLI-Ausgaben prüfen,
- nach jeder Mission ein kurzes Exam-Briefing geben,
- bei jedem Service mindestens eine ähnliche Alternative abgrenzen,
- lokale Floci-Semantik klar von realem AWS-Verhalten trennen,
- jede falsche Antwort erklären,
- alle Missionsergebnisse im Progress Tracker aktualisieren.

---

# 4. Gemeinsames Projektszenario

Alle Missionen verwenden eine zusammenhängende Fallstudie:

## Northstar Commerce Data Platform

Ein mittelgroßes E-Commerce-Unternehmen verarbeitet:

- Bestellungen
- Kunden
- Produkte
- Lagerbestände
- Zahlungen
- Clickstream-Events
- Support-Tickets
- Anwendungslogs
- Cloud-Kosten und Betriebsmetriken

### Datenquellen

| Quelle | Datentyp | Verarbeitung |
|---|---|---|
| Orders CSV/JSON | strukturiert / semi-strukturiert | Batch |
| Customers PostgreSQL | strukturiert | Batch / CDC-Konzept |
| Inventory DynamoDB | semi-strukturiert | Operational + Streams |
| Clickstream | Events | Streaming |
| Payments | Events | Queue-basiert |
| Application Logs | semi-strukturiert | Streaming / Batch |
| Support Tickets | Text | LLM-/Vector-Konzept |
| Cost Data | Parquet | Batch Analytics |

### Zielarchitektur

```text
Batch Sources ──┐
Databases ──────┼──> Ingestion ──> S3 Raw ──> Transform ──> S3 Curated
Streams ────────┘                                  │
                                                   ├──> Glue Data Catalog
                                                   ├──> Athena
                                                   ├──> Operational Stores
                                                   └──> Monitoring / Audit
```

---

# 5. Repository- und Dokumentationsstandard

## 5.1 Empfohlene Ordnerstruktur

```text
dea-floci-missions/
├── README.md
├── docker-compose.yml
├── .env.example
├── docs/
│   ├── architecture/
│   ├── decisions/
│   ├── exam-notes/
│   ├── runbooks/
│   └── postmortems/
├── datasets/
│   ├── raw/
│   ├── malformed/
│   └── expected/
├── missions/
│   ├── M00-foundation/
│   ├── M01-s3-data-lake/
│   └── ...
├── src/
│   ├── lambdas/
│   ├── producers/
│   ├── consumers/
│   ├── transformations/
│   └── quality/
├── infra/
│   ├── cloudformation/
│   ├── sam/
│   ├── cdk/
│   └── terraform/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── contract/
└── progress/
    ├── mission-log.md
    ├── error-log.md
    └── exam-scorecard.md
```

## 5.2 Definition of Done pro Mission

Eine Mission ist nur abgeschlossen, wenn:

- die Architektur funktioniert,
- die Ressourcen reproduzierbar erstellt werden können,
- mindestens ein Fehler absichtlich erzeugt wurde,
- ein Runbook oder Troubleshooting-Eintrag existiert,
- die AWS-Grenzen dokumentiert wurden,
- die Exam-Fragen beantwortet wurden,
- die wichtigsten Entscheidungen begründet sind,
- Code und Dokumentation committed wurden.

---

# 6. Gesamtroadmap

## Phase A – Foundation und lokaler Data Lake

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M00 | Floci, CLI, SDK, Git und Projektstandard | 2–3 h | A |
| M01 | S3 Data-Lake-Grundlagen | 4–6 h | A |
| M02 | S3 Metadata, Versioning, Lifecycle und Resilienz | 4–6 h | A/B |
| M03 | Glue Data Catalog und Athena | 6–8 h | A/B |
| M04 | File Formats, Partitionierung und Data Quality | 6–8 h | A/D |
| M05 | Glue Schema Registry und Schema Evolution | 4–6 h | A/B |

## Phase B – Serverless und Event-driven Processing

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M06 | Lambda-Grundlagen und S3-Transformation | 6–8 h | A |
| M07 | SQS, SNS, Retries und DLQ | 5–7 h | A |
| M08 | EventBridge, Scheduler und Pipes | 5–7 h | A/B |
| M09 | Step Functions Orchestration | 6–8 h | A/B |
| M10 | API Gateway und Data APIs | 5–7 h | A |

## Phase C – Streaming

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M11 | Kinesis Data Streams | 6–8 h | A |
| M12 | Kinesis → Lambda → S3 | 6–8 h | A |
| M13 | Amazon Data Firehose | 4–6 h | A/B |
| M14 | Amazon MSK / Kafka | 6–9 h | A |
| M15 | Streaming Architecture Decision Lab | 4–6 h | A/E |

## Phase D – Datastores und Datenmodellierung

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M16 | DynamoDB Access Patterns | 7–10 h | A |
| M17 | DynamoDB Streams, TTL und Export to S3 | 6–8 h | A |
| M18 | RDS PostgreSQL und relationale Modellierung | 7–10 h | A |
| M19 | RDS Security, Secrets und Data API | 5–7 h | A/B |
| M20 | Purpose-built Databases | 8–12 h | A/B |
| M21 | Data Store Selection Workshop | 4–6 h | E |

## Phase E – Big Data, Compute und Container

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M22 | Spark und Glue ETL mit lokalem Ersatz | 8–12 h | D |
| M23 | EMR Control Plane und Clusterentscheidungen | 4–6 h | C/E |
| M24 | Batch, ECS, ECR und containerisierte Jobs | 6–9 h | A/B |
| M25 | EKS und verteilte Processing-Grundlagen | 6–9 h | A/B |

## Phase F – Operations, Security und Governance

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M26 | IAM, STS und Least Privilege | 7–10 h | A/B |
| M27 | KMS, Secrets Manager und Parameter Store | 6–8 h | A/B |
| M28 | CloudWatch Monitoring und Alerting | 6–8 h | A/B |
| M29 | CloudTrail, Config und Audit | 5–7 h | A/B |
| M30 | Backup, Retention, Transfer und Recovery | 5–7 h | A/B/E |
| M31 | Data Privacy, Lake Formation und Governance | 6–8 h | D/E |

## Phase G – IaC, CI/CD und Kosten

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M32 | CloudFormation, SAM, CDK und Terraform | 8–12 h | A/B |
| M33 | CodeBuild, CodePipeline und Integration Tests | 6–9 h | A/B |
| M34 | Cost Explorer, CUR und Data Exports | 6–8 h | B/D |
| M35 | Performance- und Kostenoptimierung | 5–7 h | E |

## Phase H – DEA-C01 v1.1 Erweiterungen

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M36 | Apache Iceberg und Open Table Formats | 7–10 h | D/E |
| M37 | Vectors, HNSW, IVF und S3 Vectors | 6–8 h | A/D/E |
| M38 | Bedrock, RAG und LLM Data Processing | 5–7 h | B/D/E |
| M39 | SageMaker Unified Studio und Business Catalog | 4–6 h | E |

## Phase I – Capstones und Exam Readiness

| Mission | Thema | Dauer | Klasse |
|---|---|---:|---|
| M40 | Capstone: Batch Analytics Platform | 15–25 h | A/D |
| M41 | Capstone: Streaming Operations Platform | 15–25 h | A |
| M42 | Incident Simulation und Architecture Defense | 8–12 h | A/E |
| M43 | Mock Exam, Gap Closure und Final Review | 15–25 h | E |

**Gesamtschätzung:** ungefähr **210–300 Stunden**.  
Eine komprimierte Exam-Version kann auf etwa **130–170 Stunden** reduziert werden, wenn optionale Deep-Dive-Missionen gekürzt werden.

---

# 7. Detaillierte Missionen

---

## M00 – Floci Engineering Foundation

**Floci:** Plattform, Multi-Service Endpoint  
**AWS-Pendant:** AWS APIs, AWS CLI, AWS SDKs  
**Dauer:** 2–3 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.4.3, 1.4.4, 1.4.5, 3.1.3

### Business Scenario

Das Team benötigt eine reproduzierbare lokale Entwicklungsumgebung, in der Data-Pipeline-Code ohne Cloud-Kosten getestet werden kann.

### Theorie

- Control Plane vs. Data Plane
- AWS CLI als API-Client
- AWS SDK
- Endpoint Override
- Credentials
- Region
- SigV4 konzeptionell
- GUI vs. CLI vs. IaC
- Git und Branching

### Aufgaben

1. Floci über Docker Compose starten.
2. Health Check und Service Matrix prüfen.
3. Dummy-Credentials konfigurieren.
4. `AWS_ENDPOINT_URL` setzen.
5. AWS CLI und Python SDK gegen Floci testen.
6. Git-Repository initialisieren.
7. `.env.example` erstellen.
8. Persistenzmodus dokumentieren.
9. Cleanup-Skript anlegen.

### Failure Injection

- falscher Endpoint
- fehlende Credentials
- falsche Region
- gestoppter Floci-Container
- nicht erreichbarer Docker Socket

### Deliverables

- `docker-compose.yml`
- `scripts/doctor.ps1`
- `docs/runbooks/floci-startup.md`

### Exam Transfer

- Endpoint ist kein Berechtigungsmechanismus.
- IAM und Netzwerkzugriff sind getrennte Kontrollschichten.
- CLI, SDK und Console verwenden AWS APIs.

---

## M01 – S3 Data Lake Fundamentals

**Floci:** Storage / S3  
**AWS-Pendant:** Amazon S3  
**Dauer:** 4–6 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.1.2, 2.1.1, 2.1.2, 2.3.6

### Business Scenario

Northstar Commerce erhält täglich Bestelldaten und benötigt einen kostengünstigen, skalierbaren Raw Data Lake.

### Theorie

- Object Storage
- Bucket
- Object
- Object Key
- Prefix
- Metadata
- ETag
- `HeadObject`
- `GetObject`
- `ListObjectsV2`
- S3 URI
- Storage Class
- flacher Namespace
- Folder Marker Objects

### Aufgaben

1. Bucket `northstar-data-lake` anlegen.
2. Struktur `raw/orders/`, `curated/orders/`, `quarantine/orders/` planen.
3. CSV und NDJSON hochladen.
4. Metadaten über GUI und `head-object` prüfen.
5. Prefixe mit `list-objects-v2` untersuchen.
6. Downloads mit `get-object` durchführen.
7. Datei per Python/Boto3 lesen.
8. Prüfsumme oder ETag in einem Manifest speichern.
9. Idempotente Upload-Funktion schreiben.

### Failure Injection

- falscher Key
- leere Datei
- identischer Dateiname mit neuem Inhalt
- ungültiges Encoding
- 0-Byte Folder Marker

### Deliverables

- S3-Namenskonvention
- Manifest-Datei
- Upload-Skript
- Architekturdiagramm

### Exam Transfer

- `HeadObject` für Metadaten, `GetObject` für Inhalt.
- Prefix ist kein echtes Verzeichnis.
- S3 ist die Standardbasis vieler AWS Data Lakes.

---

## M02 – S3 Lifecycle, Versioning und Resilienz

**Floci:** S3  
**AWS-Pendant:** Amazon S3, S3 Glacier  
**Dauer:** 4–6 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 2.3.2–2.3.6, 4.3.2–4.3.4

### Business Scenario

Bestelldaten müssen 90 Tage häufig verfügbar, danach kostengünstiger gespeichert und nach sieben Jahren gelöscht werden.

### Theorie

- Versioning
- Delete Marker
- Lifecycle Rules
- Transition vs. Expiration
- Standard, Standard-IA, One Zone-IA, Glacier-Klassen
- Same-Region und Cross-Region Replication
- Object Lock
- Encryption
- Recovery Point Objective
- Recovery Time Objective

### Aufgaben

1. Versioning aktivieren.
2. mehrere Objektversionen erzeugen.
3. frühere Version abrufen.
4. Delete Marker untersuchen.
5. Lifecycle-Konfiguration definieren.
6. Replikationsarchitektur theoretisch entwerfen.
7. Backup- und Restore-Runbook schreiben.
8. S3 Select an CSV/JSON testen, sofern lokal unterstützt.

### Failure Injection

- versehentliches Löschen
- falsche Lifecycle-Regel
- nicht versionierter Bucket
- überschriebenes Objekt
- Restore-Versuch ohne Version ID

### Exam Transfer

- Versioning schützt vor Überschreiben, nicht vor jeder Form absichtlicher Löschung.
- Replication ist nicht dasselbe wie Backup.
- One Zone-IA ist ungeeignet, wenn Multi-AZ-Resilienz gefordert ist.
- Glacier-Klassen unterscheiden sich vor allem in Abrufzeit und Kosten.

---

## M03 – Glue Data Catalog und Athena

**Floci:** Glue Data Catalog, Athena  
**AWS-Pendant:** AWS Glue Data Catalog, Amazon Athena  
**Dauer:** 6–8 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 2.2.1–2.2.5, 3.1.7, 3.2.3

### Floci Reality

- Floci emuliert den **Glue Data Catalog** und die **Glue Schema Registry**.
- Glue Crawlers und Glue Spark Jobs werden nicht vollständig ausgeführt.
- Athena führt lokal echte SQL-Abfragen über DuckDB aus.
- Glue-Tabellen werden auf S3-Locations abgebildet.
- Athena-Ergebnisse werden als CSV in S3 gespeichert.

### Business Scenario

Analysten sollen Bestelldaten auf S3 mit SQL abfragen, ohne einen Data-Warehouse-Cluster zu verwalten.

### Theorie

- technische Metadaten
- Database, Table, Column, Partition
- Schema-on-read
- SerDe
- InputFormat
- Catalog vs. gespeicherte Daten
- Athena Workgroup
- Query Result Location
- Serverless
- Kosten nach gescannten Daten in echtem AWS
- Athena vs. Redshift

### Aufgaben

1. Glue Database erstellen.
2. CSV-Tabelle manuell registrieren.
3. Athena-Workgroup erstellen.
4. Queries ausführen:
   - Anzahl
   - Summe
   - Durchschnitt
   - Gruppierung
   - CTE
   - Window Function
5. Query Results in S3 prüfen.
6. Parquet-Tabelle registrieren.
7. Partitionen manuell erstellen.
8. Schemaänderung simulieren.
9. Catalog-Definitionen exportieren.

### Failure Injection

- falsche S3 Location
- falscher Datentyp
- falsches InputFormat
- fehlende Partition
- ungültiges CSV
- gemischte Schemas unter demselben Prefix

### Exam Transfer

- Glue Data Catalog speichert Metadaten, nicht die Nutzdaten.
- Athena benötigt kein Laden in ein Warehouse.
- Parquet und Partition Pruning reduzieren in AWS Scan-Kosten.
- Ein Crawler automatisiert Discovery, ersetzt aber keine Data-Contract-Governance.

---

## M04 – File Formats, Partitionierung und Data Quality

**Floci:** S3, Athena, Glue Catalog  
**AWS-Pendant:** Amazon S3, Athena, Glue  
**Lokaler Ersatz:** Python, Pandas, PyArrow, DuckDB oder Spark  
**Dauer:** 6–8 Stunden  
**Klasse:** A/D  
**Exam Mapping:** 1.2.6, 2.4.2, 2.4.5, 3.4.1–3.4.5

### Business Scenario

Athena-Abfragen auf CSV sind langsam und teuer. Das Team benötigt ein Curated Dataset mit validierten Parquet-Dateien.

### Theorie

- Row-oriented vs. Columnar
- CSV, JSON, Parquet, ORC
- Compression
- Partitioning
- Partition Pruning
- Small Files
- Data Skew
- Null Handling
- Deduplication
- Referential Integrity
- Quality Dimensions:
  - Completeness
  - Validity
  - Uniqueness
  - Consistency
  - Timeliness

### Aufgaben

1. CSV nach Parquet transformieren.
2. nach `year/month/day` partitionieren.
3. Qualitätsregeln implementieren.
4. fehlerhafte Records nach `quarantine/` schreiben.
5. Expected Results erzeugen.
6. Query-Pläne oder Scanvolumen lokal vergleichen.
7. Schema Drift testen.
8. Compaction-Konzept erstellen.

### Failure Injection

- `amount="unknown"`
- Null-Primary-Key
- Duplicate Order
- ungültiges Datum
- extrem ungleich verteilte Region
- 1.000 Small Files

### Exam Transfer

- Columnar Formats eignen sich für analytische Projektionen.
- Partitionierung muss zu Zugriffsmustern passen.
- Zu starke Partitionierung kann Small Files und Metadaten-Overhead erzeugen.
- Data Skew verlängert verteilte Jobs.

---

## M05 – Glue Schema Registry und Data Contracts

**Floci:** Glue Schema Registry  
**AWS-Pendant:** AWS Glue Schema Registry  
**Dauer:** 4–6 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 2.2.2, 2.4.2, 3.4.1

### Business Scenario

Mehrere Producer senden Events. Schemaänderungen dürfen bestehende Consumer nicht brechen.

### Theorie

- AVRO, JSON Schema, Protobuf
- Schema Version
- Backward Compatibility
- Forward Compatibility
- Full Compatibility
- Breaking Change
- Data Contract
- Producer- und Consumer-Verantwortung

### Aufgaben

1. Registry erstellen.
2. AVRO-Schema registrieren.
3. kompatible Version ergänzen.
4. inkompatible Version testen.
5. Schema Diff untersuchen.
6. Contract Test schreiben.
7. Schema-Metadaten und Tags verwenden.

### Failure Injection

- Pflichtfeld ohne Default hinzufügen
- Datentyp ändern
- Feld entfernen
- falsches Format registrieren

### Exam Transfer

- Backward Compatibility schützt neue Consumer beim Lesen alter Daten.
- Forward Compatibility schützt alte Consumer beim Lesen neuer Daten.
- Schema Registry ist nicht dasselbe wie Glue Data Catalog.

---

## M06 – Lambda Data Transformation

**Floci:** Lambda, S3, CloudWatch Logs  
**AWS-Pendant:** AWS Lambda, Amazon S3, CloudWatch Logs  
**Dauer:** 6–8 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.2.5, 1.4.1–1.4.2, 3.1.8

### Business Scenario

Neue kleine Order-Dateien sollen eventgetrieben validiert und in ein Curated Prefix geschrieben werden.

### Theorie

- Invocation
- Synchronous vs. Asynchronous
- Runtime
- Handler
- Memory/CPU Relationship
- Timeout
- Ephemeral Storage
- Reserved Concurrency
- Idempotency
- Cold Start
- Environment Variables
- S3 Event
- Lambda vs. Glue vs. EMR

### Aufgaben

1. Python-Lambda bauen.
2. ZIP deployen.
3. Funktion direkt aufrufen.
4. S3 lesen und schreiben.
5. structured Logging ergänzen.
6. ETag als Idempotency Key verwenden.
7. Memory und Timeout variieren.
8. Concurrency Limit testen.
9. Version und Alias erstellen.

### Failure Injection

- Timeout
- fehlende Datei
- ungültiges JSON
- wiederholtes Event
- zu niedrige Memory-Konfiguration
- absichtliche Exception

### Exam Transfer

- Lambda eignet sich für kurze, eventgetriebene Transformationen.
- Große Spark-Transformationen gehören typischerweise zu Glue oder EMR.
- Mehr Memory liefert auch mehr CPU.
- Idempotenz ist bei at-least-once Event Delivery wesentlich.

---

## M07 – SQS, SNS, Retries und Dead-Letter Queues

**Floci:** SQS, SNS, Lambda  
**AWS-Pendant:** Amazon SQS, Amazon SNS, AWS Lambda  
**Dauer:** 5–7 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.3.4, 3.3.3

### Business Scenario

Zahlungsevents dürfen bei temporären Verarbeitungsfehlern nicht verloren gehen. Mehrere Teams benötigen Benachrichtigungen.

### Theorie

- Queue vs. Pub/Sub
- Decoupling
- Visibility Timeout
- Message Retention
- Long Polling
- Standard vs. FIFO
- Ordering
- Deduplication
- Redrive Policy
- Dead-Letter Queue
- Fan-out
- Backpressure

### Aufgaben

1. Standard Queue erstellen.
2. Producer und Consumer implementieren.
3. Visibility Timeout beobachten.
4. DLQ konfigurieren.
5. fehlerhafte Nachricht mehrfach verarbeiten.
6. SNS Topic mit mehreren SQS Subscribers aufbauen.
7. FIFO-Anwendungsfall entwerfen.
8. Lambda Event Source Mapping verwenden.

### Failure Injection

- Consumer Crash
- Poison Message
- zu kurzes Visibility Timeout
- doppelte Nachricht
- falsche DLQ-Policy

### Exam Transfer

- SQS puffert und entkoppelt.
- SNS broadcastet an mehrere Subscribers.
- DLQ isoliert dauerhaft fehlgeschlagene Nachrichten.
- FIFO wählen, wenn Reihenfolge und Deduplizierung zwingend sind.

---

## M08 – EventBridge, Scheduler und Pipes

**Floci:** EventBridge, Scheduler, Pipes  
**AWS-Pendant:** Amazon EventBridge, EventBridge Scheduler, EventBridge Pipes  
**Dauer:** 5–7 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.1.5–1.1.6, 3.1.9

### Business Scenario

Order Events sollen anhand ihrer Eigenschaften an unterschiedliche Verarbeitungspfade weitergeleitet werden. Ein täglicher Batch-Lauf benötigt einen Scheduler.

### Theorie

- Event Bus
- Rule
- Event Pattern
- Target
- Schedule
- Event Routing
- Filtering
- Pipes
- EventBridge vs. SNS
- EventBridge vs. Step Functions

### Aufgaben

1. Custom Event Bus erstellen.
2. Event Pattern definieren.
3. Lambda- und SQS-Targets konfigurieren.
4. Events veröffentlichen.
5. Event Pattern testen.
6. Scheduler für Tagesabschluss anlegen.
7. Pipe von Queue zu Ziel bauen.
8. Replay-Konzept theoretisch dokumentieren.

### Failure Injection

- Pattern matcht nicht
- falscher Event Bus
- deaktivierte Rule
- fehlendes Target
- ungültiger Schedule

### Exam Transfer

- EventBridge routet Events.
- Step Functions orchestriert Schritte und Zustände.
- SNS ist einfacher Broadcast, EventBridge bietet reichhaltigeres Routing.
- Scheduler ist für zeitbasierte Einzel- oder Serienausführung geeignet.

---

## M09 – Step Functions Orchestration

**Floci:** Step Functions, Lambda, SQS, SNS  
**AWS-Pendant:** AWS Step Functions  
**Dauer:** 6–8 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.3.1–1.3.3, 3.1.1–3.1.2

### Business Scenario

Die tägliche Order-Pipeline benötigt Validierung, Transformation, Qualitätsprüfung, Veröffentlichung und Fehlerbenachrichtigung.

### Theorie

- Amazon States Language
- Task
- Choice
- Pass
- Wait
- Parallel
- Map
- Retry
- Catch
- Timeout
- Standard vs. Express
- Execution History
- Callback Pattern
- Idempotent Workflow

### Aufgaben

1. State Machine validieren.
2. Lambda-Tasks integrieren.
3. Choice State verwenden.
4. Retry mit Backoff konfigurieren.
5. Catch-Path zu SNS oder SQS.
6. Execution History analysieren.
7. Map State für mehrere Dateien entwerfen.
8. Standard vs. Express begründen.

### Failure Injection

- Lambda Timeout
- invalid State Input
- permanenter Fehler
- fehlende Catch-Regel
- nicht idempotenter Retry

### Exam Transfer

- Step Functions ist ideal für explizite serverlose Workflows.
- MWAA ist besser bei komplexen Airflow-DAGs und bestehendem Airflow-Ökosystem.
- Retries müssen idempotente Tasks voraussetzen.

---

## M10 – Data APIs mit API Gateway

**Floci:** API Gateway, Lambda, DynamoDB oder RDS  
**AWS-Pendant:** Amazon API Gateway  
**Dauer:** 5–7 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.2.8, 3.1.5

### Business Scenario

Interne Systeme benötigen einen kontrollierten API-Zugriff auf aggregierte Bestelldaten.

### Theorie

- REST API
- HTTP API
- Request/Response Mapping
- Lambda Integration
- Authentication vs. Authorization
- Throttling
- Data API
- API Gateway vs. direkter Datenbankzugriff

### Aufgaben

1. API erstellen.
2. Route für Order Summary.
3. Lambda Integration.
4. Query Parameter validieren.
5. Rate Limit konzeptionell anwenden.
6. Fehlercodes standardisieren.
7. Integration Test schreiben.
8. API-Dokumentation erstellen.

### Exam Transfer

- API Gateway exponiert kontrollierte APIs.
- Ein Data API abstrahiert Datastore-Zugriff.
- Interne Batch-Pipelines benötigen nicht automatisch API Gateway.

---

## M11 – Kinesis Data Streams

**Floci:** Kinesis  
**AWS-Pendant:** Amazon Kinesis Data Streams  
**Dauer:** 6–8 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.1.1, 1.1.9–1.1.12

### Business Scenario

Clickstream-Events müssen in nahezu Echtzeit aufgenommen und später erneut lesbar sein.

### Theorie

- Stream
- Shard
- Partition Key
- Sequence Number
- Shard Iterator
- Retention
- Replay
- Consumer
- Enhanced Fan-Out
- Ordering per Shard
- Hot Shard
- Fan-in und Fan-out
- stateful vs. stateless Processing

### Aufgaben

1. Stream mit mehreren Shards erstellen.
2. Producer schreiben.
3. Partition-Key-Verteilung untersuchen.
4. Records ab `TRIM_HORIZON` lesen.
5. Replay demonstrieren.
6. Retention ändern.
7. Shard splitten und mergen.
8. EFO Consumer registrieren.
9. Lastgenerator entwickeln.

### Failure Injection

- Hot Partition Key
- falscher Iterator
- Consumer startet bei `LATEST`
- ungleichmäßige Event-Verteilung
- fehlende Checkpoints

### Exam Transfer

- Ordering gilt nur innerhalb eines Shards.
- Partition Key steuert Shard-Zuordnung.
- Kinesis bietet Replay über Retention.
- SQS ist keine Streaming-Plattform mit Shard-Replay.

---

## M12 – Kinesis → Lambda → S3

**Floci:** Kinesis, Lambda, S3, CloudWatch  
**AWS-Pendant:** Kinesis Data Streams, Lambda, S3  
**Dauer:** 6–8 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.1.7, 1.4.2, 3.3.4

### Business Scenario

Clickstream-Events sollen in Mikro-Batches validiert und als NDJSON in den Data Lake geschrieben werden.

### Theorie

- Event Source Mapping
- Batch Size
- Starting Position
- Parallelization
- Checkpointing
- Partial Batch Failure
- Duplicate Handling
- Poison Record
- Iterator Age
- Backpressure

### Aufgaben

1. Event Source Mapping erstellen.
2. Batch-Verarbeitung implementieren.
3. S3 Output schreiben.
4. Duplicate Detection ergänzen.
5. Fehlerbatch simulieren.
6. Concurrency begrenzen.
7. CloudWatch-Metriken planen.
8. Replay-Test durchführen.

### Exam Transfer

- Lambda pollt Kinesis über Event Source Mapping.
- Batch Size beeinflusst Effizienz und Fehlerumfang.
- Retention ermöglicht Wiederholung.
- Idempotenz bleibt notwendig.

---

## M13 – Amazon Data Firehose

**Floci:** Data Firehose  
**AWS-Pendant:** Amazon Data Firehose  
**Dauer:** 4–6 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.1.1, 1.2.4, 2.1.1

### Floci Reality

Floci puffert Records lokal und schreibt nach einer kleinen Anzahl Records NDJSON nach S3. Das ist funktional nützlich, simuliert aber nicht alle AWS Buffer-, Transformation- und Destination-Optionen.

### Business Scenario

Ein Team möchte Streaming-Daten ohne eigenen Consumer direkt nach S3 liefern.

### Theorie

- Fully Managed Delivery
- Buffering
- Delivery Stream
- Source und Destination
- Kinesis Data Streams vs. Firehose
- Transformation
- Dynamic Partitioning
- Delivery Errors
- Operational Overhead

### Aufgaben

1. Delivery Stream erstellen.
2. einzelne und Batch Records senden.
3. S3-Ausgabe prüfen.
4. Buffer-Verhalten dokumentieren.
5. Dateinamen und Prefix analysieren.
6. Firehose-vs.-Kinesis-Entscheidungsmatrix erstellen.

### Exam Transfer

- Firehose ist Delivery, nicht frei programmierbare Stream-Verarbeitung.
- Kinesis Data Streams ist geeigneter bei mehreren Consumer-Anwendungen und Replay-Kontrolle.
- Firehose reduziert Operational Overhead.

---

## M14 – Amazon MSK / Kafka

**Floci:** MSK mit Redpanda Data Plane  
**AWS-Pendant:** Amazon Managed Streaming for Apache Kafka  
**Dauer:** 6–9 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.1.1, 1.1.10–1.1.12

### Business Scenario

Das Unternehmen migriert bestehende Kafka-Producer und -Consumer ohne große Codeänderung auf eine verwaltete AWS-Plattform.

### Theorie

- Broker
- Topic
- Partition
- Offset
- Consumer Group
- Replication Factor
- Retention
- Replay
- Kafka Ecosystem
- Kinesis vs. MSK
- Kafka Connect konzeptionell
- Schema Registry

### Aufgaben

1. MSK-Cluster erstellen.
2. Bootstrap Broker abrufen.
3. Topics anlegen.
4. Producer und Consumer starten.
5. Consumer Groups testen.
6. Offset Reset und Replay.
7. mehrere Partitionen.
8. Schema Registry integrieren.
9. Lag messen.

### Failure Injection

- Consumer Crash
- Offset falsch
- Hot Partition
- inkompatibles Schema
- Broker nicht erreichbar

### Exam Transfer

- MSK ist geeignet bei Kafka-Kompatibilität und bestehendem Kafka-Ökosystem.
- Kinesis ist AWS-nativer und häufig betriebsärmer.
- Consumer Groups verteilen Partitionen auf Consumer.

---

## M15 – Streaming Architecture Decision Lab

**Services:** Kinesis, Firehose, MSK, SQS, Lambda  
**Dauer:** 4–6 Stunden  
**Klasse:** A/E  
**Exam Mapping:** 1.1.9–1.1.12, 1.2.4

### Aufgaben

Für zehn Szenarien eine Architektur auswählen:

1. mehrere unabhängige Consumer mit Replay
2. direkte Lieferung nach S3
3. bestehende Kafka-Anwendungen
4. geordnete Finanztransaktionen
5. Worker Queue
6. sehr niedriger Operational Overhead
7. Event History für erneute Verarbeitung
8. Fan-out zu mehreren Teams
9. variable Last
10. Schema Registry erforderlich

### Deliverable

Entscheidungsmatrix mit:

- Latenz
- Ordering
- Replay
- Retention
- Consumer-Modell
- Kostenmodell
- Operational Overhead
- Portabilität

---

## M16 – DynamoDB Access Patterns

**Floci:** DynamoDB  
**AWS-Pendant:** Amazon DynamoDB  
**Dauer:** 7–10 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.1.9, 2.1.1–2.1.3, 2.4.1

### Business Scenario

Das Inventory-System benötigt millisekundenschnelle Zugriffe und hohe horizontale Skalierbarkeit.

### Theorie

- Partition Key
- Sort Key
- Composite Primary Key
- Access Pattern First
- Item
- Attribute
- GSI
- LSI
- Query vs. Scan
- Conditional Write
- Transactions
- Provisioned vs. On-Demand
- RCU/WCU
- Hot Partitions
- Eventual vs. Strong Consistency
- DAX konzeptionell

### Aufgaben

1. Access Patterns definieren.
2. Tabellenmodell entwerfen.
3. GSI erstellen.
4. Query und Scan vergleichen.
5. Conditional Update.
6. Batch Operations.
7. TransactWriteItems.
8. Lastverteilung testen.
9. On-Demand-vs.-Provisioned-Entscheidung.

### Failure Injection

- zu geringe Kardinalität
- Scan statt Query
- falscher GSI
- konkurrierende Updates
- Hot Key

### Exam Transfer

- DynamoDB-Modellierung beginnt mit Access Patterns.
- GSI kann einen anderen Partition Key verwenden.
- LSI teilt denselben Partition Key der Basistabelle.
- Scan ist bei großen Tabellen teuer und ineffizient.

---

## M17 – DynamoDB Streams, TTL und Export to S3

**Floci:** DynamoDB Streams, Lambda, Kinesis, S3  
**AWS-Pendant:** DynamoDB Streams, DynamoDB TTL, Export to S3  
**Dauer:** 6–8 Stunden  
**Klasse:** A  
**Exam Mapping:** 1.1.1, 2.3.4, 3.1.8

### Business Scenario

Änderungen am Inventory sollen in Analytics einfließen. Abgelaufene Reservationsdaten sollen automatisch entfernt werden.

### Aufgaben

1. Streams aktivieren.
2. Lambda Consumer anbinden.
3. NEW_IMAGE und OLD_IMAGE analysieren.
4. TTL aktivieren.
5. PITR-Konfiguration untersuchen.
6. Export to S3 ausführen.
7. Manifest-Dateien analysieren.
8. Exportdaten in Athena registrieren.

### Failure Injection

- falsche StreamViewType
- doppeltes Event
- TTL als String statt Epoch
- Lambda-Consumer-Ausfall
- Exportziel fehlt

### Exam Transfer

- Streams liefern Änderungsereignisse.
- TTL löscht asynchron und ist nicht minutengenau.
- Export to S3 kann Analytics ermöglichen, ohne den operativen Traffic zu belasten.

---

## M18 – RDS PostgreSQL und relationale Modellierung

**Floci:** RDS mit echtem PostgreSQL-Container  
**AWS-Pendant:** Amazon RDS for PostgreSQL  
**Dauer:** 7–10 Stunden  
**Klasse:** A  
**Exam Mapping:** 2.1.1–2.1.6, 2.4.1, 3.2.6

### Business Scenario

Customer- und Payment-Daten benötigen Transaktionen, Constraints und SQL-Joins.

### Theorie

- OLTP
- ACID
- Primary Key
- Foreign Key
- Index
- Normalization
- Transaction
- Isolation
- Lock
- Read Replica
- Multi-AZ
- Backup
- RDS vs. Aurora
- RDS vs. DynamoDB
- RDS vs. Redshift

### Aufgaben

1. PostgreSQL-Instanz erstellen.
2. Tabellen und Constraints.
3. Testdaten laden.
4. komplexe Joins.
5. Window Functions.
6. Index erstellen und Query Plan vergleichen.
7. Locks simulieren.
8. Transaktionen und Rollback.
9. Backup-/Replica-Architektur theoretisch ergänzen.

### Failure Injection

- Constraint Violation
- Deadlock
- fehlender Index
- langer Transaction Lock
- Connection Exhaustion

### Exam Transfer

- Multi-AZ erhöht Verfügbarkeit, Read Replica skaliert Reads.
- RDS ist für relationale OLTP-Workloads.
- Redshift ist für analytische MPP-Workloads.

---

## M19 – RDS Security, Secrets und Data API

**Floci:** RDS, RDS Data API, Secrets Manager, IAM  
**AWS-Pendant:** Amazon RDS, AWS Secrets Manager, IAM Database Authentication  
**Dauer:** 5–7 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 4.1.3–4.1.5, 4.2.2–4.2.3, 4.3.4

### Aufgaben

1. Passwort in Secrets Manager speichern.
2. Anwendung liest Secret zur Laufzeit.
3. Secret Rotation konzeptionell planen.
4. IAM DB Authentication aktivieren.
5. Auth Token erzeugen.
6. RDS Data API testen.
7. Rollen und Benutzer in PostgreSQL erstellen.
8. TLS-Konzept dokumentieren.

### Failure Injection

- abgelaufenes Token
- falscher Secret Key
- fehlende DB-Berechtigung
- Passwort im Code
- unverschlüsselte Verbindung

### Exam Transfer

- Secrets Manager speichert und rotiert Secrets.
- KMS verschlüsselt Daten und Secrets, ersetzt aber kein Secret Management.
- IAM-Rolle und DB-Benutzerrechte sind unterschiedliche Ebenen.

---

## M20 – Purpose-built Databases

**Floci:** DocumentDB, Neptune, MemoryDB/ElastiCache, OpenSearch  
**AWS-Pendant:** Amazon DocumentDB, Amazon Neptune, Amazon MemoryDB for Redis, Amazon OpenSearch Service  
**Dauer:** 8–12 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 2.1.1–2.1.3

### Teilmissionen

#### M20A – DocumentDB

- dokumentorientierte Daten
- MongoDB-Kompatibilität
- flexible Schemas
- DocumentDB vs. DynamoDB

#### M20B – Neptune

- Graphdaten
- Vertices und Edges
- Gremlin
- Beziehungsabfragen

#### M20C – MemoryDB/Redis

- In-memory Access
- Cache vs. durable primary database
- Key/Value
- TTL
- MemoryDB vs. ElastiCache vs. DynamoDB DAX

#### M20D – OpenSearch

- Volltextsuche
- Log Analytics
- Index und Document
- OpenSearch vs. relationale Datenbank
- OpenSearch vs. Athena

### Deliverable

Datastore-Decision-Record für vier unterschiedliche Workloads.

---

## M21 – Data Store Selection Workshop

**Dauer:** 4–6 Stunden  
**Klasse:** E  
**Exam Mapping:** gesamte Task 2.1

### Pflichtvergleiche

- S3 vs. EBS vs. EFS
- RDS/Aurora vs. DynamoDB
- Redshift vs. Athena
- Redshift vs. RDS
- OpenSearch vs. RDS
- MemoryDB vs. DynamoDB
- DocumentDB vs. DynamoDB
- Neptune vs. relationale Tabellen
- provisioned vs. serverless

### Bewertungsdimensionen

- Zugriffsmuster
- Latenz
- Konsistenz
- Transaktionen
- Datenvolumen
- Skalierung
- Kosten
- Operational Overhead
- Backup
- Security
- Query Flexibility

---

## M22 – Spark und Glue ETL mit lokalem Ersatz

**Floci:** Glue Catalog  
**AWS-Pendant:** AWS Glue ETL  
**Lokaler Ersatz:** Apache Spark / PySpark  
**Dauer:** 8–12 Stunden  
**Klasse:** D  
**Exam Mapping:** 1.2.5–1.2.7, 3.3.6, 3.4.5

### Kritische Grenze

Floci emuliert den Glue Data Catalog, nicht die vollständige serverlose Glue-Spark-Jobausführung.

### Business Scenario

Mehrere Millionen Order- und Customer-Records müssen verteilt gejoint, bereinigt und partitioniert geschrieben werden.

### Theorie

- Spark Driver
- Executor
- Transformation
- Action
- Lazy Evaluation
- DataFrame
- Partition
- Shuffle
- Broadcast Join
- Repartition vs. Coalesce
- Data Skew
- Job Bookmark
- Glue DynamicFrame konzeptionell
- Glue vs. EMR

### Aufgaben

1. Spark lokal starten.
2. S3-kompatible Daten lesen.
3. Join und Aggregation.
4. Parquet schreiben.
5. Partitionierung.
6. Data Skew erzeugen.
7. Salting oder Broadcast Join testen.
8. Incremental State lokal implementieren.
9. Glue Catalog aktualisieren.

### Exam Transfer

- Glue reduziert Clusterbetrieb.
- EMR bietet mehr Kontrolle und Framework-Flexibilität.
- Spark Shuffles sind häufige Performance-Bottlenecks.

---

## M23 – EMR Control Plane

**Floci:** EMR Management API  
**AWS-Pendant:** Amazon EMR  
**Dauer:** 4–6 Stunden  
**Klasse:** C/E  
**Exam Mapping:** 1.2.5, 3.1.4, 3.3.6

### Kritische Grenze

Floci verfolgt Cluster, Instance Groups, Fleets und Steps, startet aber keinen echten Hadoop- oder Spark-Cluster.

### Aufgaben

1. Cluster-Definition erstellen.
2. Instance Groups vs. Fleets.
3. Steps hinzufügen.
4. Termination Protection.
5. Auto-Termination-Konzept.
6. Spot-vs.-On-Demand-Strategie.
7. Security Configuration.
8. Cluster Lifecycle beobachten.
9. echte Verarbeitung aus M22 als Ersatz verwenden.

### Exam Transfer

- EMR eignet sich für Open-Source-Big-Data-Frameworks und hohe Konfigurationskontrolle.
- Spot eignet sich besonders für fehlertolerante Task Nodes.
- Persistent Cluster vs. transient Job Cluster vergleichen.

---

## M24 – AWS Batch, ECS und ECR

**Floci:** AWS Batch, ECS, ECR  
**AWS-Pendant:** AWS Batch, Amazon ECS, Amazon ECR  
**Dauer:** 6–9 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.2.1, 1.2.5

### Business Scenario

Große unabhängige Bild- oder Datei-Verarbeitungsjobs sollen containerisiert und über eine Queue ausgeführt werden.

### Theorie

- Container Image
- Registry
- ECS Task
- Task Definition
- Fargate vs. EC2 Launch Type
- Batch Job Queue
- Compute Environment
- Array Jobs
- Lambda vs. Batch
- ECS vs. EKS

### Aufgaben

1. Image bauen und nach ECR pushen.
2. ECS Task Definition.
3. Container Job ausführen.
4. AWS Batch Job definieren.
5. S3 Input und Output.
6. Exit Codes und Retries.
7. Resource Limits.
8. Parallel Job Pattern.

### Exam Transfer

- AWS Batch ist geeignet für queue-basierte Batch Compute Workloads.
- Lambda ist durch Laufzeit und Ressourcengrenzen limitiert.
- ECS ist AWS-native Container-Orchestrierung.

---

## M25 – EKS und Distributed Processing

**Floci:** EKS mit lokalem k3s-Modus, ECR  
**AWS-Pendant:** Amazon EKS  
**Dauer:** 6–9 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.2.1, 1.4.10

### Theorie

- Kubernetes Control Plane
- Pod
- Deployment
- Job
- ConfigMap
- Secret
- Persistent Volume
- EBS vs. EFS
- Managed Node Groups
- Fargate
- EKS vs. ECS

### Aufgaben

1. lokalen EKS/k3s-Cluster erstellen.
2. Container Job deployen.
3. Konfiguration und Secret.
4. parallele Worker.
5. Pod Failure untersuchen.
6. Logs sammeln.
7. Persistent Storage konzeptionell zuordnen.
8. Scaling-Strategie dokumentieren.

### Exam Transfer

- EFS eignet sich für Multi-Node Shared File Access.
- EBS ist typischerweise blockorientiert und AZ-gebunden.
- EKS ist sinnvoll bei Kubernetes-Anforderungen, nicht automatisch für jeden Container.

---

## M26 – IAM, STS und Least Privilege

**Floci:** IAM, STS  
**AWS-Pendant:** AWS IAM, AWS STS  
**Dauer:** 7–10 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 4.1.2, 4.1.4–4.1.6, 4.2.1, 4.2.5–4.2.6

### Theorie

- User
- Group
- Role
- Policy
- Trust Policy
- Identity-based Policy
- Resource-based Policy
- Explicit Deny
- Least Privilege
- AssumeRole
- Temporary Credentials
- RBAC
- ABAC
- Tag-based Access

### Aufgaben

1. Rollen für Lambda und Step Functions.
2. Least-Privilege-S3-Policy.
3. Prefix-beschränkter Zugriff.
4. AssumeRole mit STS.
5. Session Policy.
6. Resource Policy untersuchen.
7. Policy Review Checklist.
8. Multi-Account-Szenario simulieren.

### Kritischer Reality Check

Lokale Policy-Definition und STS-Flows sind wertvoll. Das vollständige Enforcement muss in echtem AWS separat verifiziert werden.

### Exam Transfer

- Trust Policy beantwortet: Wer darf die Rolle annehmen?
- Permissions Policy beantwortet: Was darf die Rolle tun?
- Explicit Deny überstimmt Allow.

---

## M27 – KMS, Secrets Manager und Parameter Store

**Floci:** KMS, Secrets Manager, SSM Parameter Store  
**AWS-Pendant:** AWS KMS, AWS Secrets Manager, Systems Manager Parameter Store  
**Dauer:** 6–8 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 4.1.3, 4.2.2, 4.3.1–4.3.4

### Theorie

- Encryption at Rest
- Encryption in Transit
- Symmetric Key
- Key Policy
- Grant
- Envelope Encryption
- Data Key
- Secret Rotation
- SecureString
- Cross-Account KMS
- Masking vs. Encryption vs. Tokenization

### Aufgaben

1. KMS Key erstellen.
2. Encrypt/Decrypt.
3. Data Key verwenden.
4. Secret speichern und abrufen.
5. SecureString Parameter.
6. Lambda liest Secret.
7. Key Rotation konzeptionell.
8. Cross-Account-Key-Policy entwerfen.
9. PII-Masking lokal implementieren.

### Exam Transfer

- KMS verwaltet Schlüssel, nicht Geschäftssecrets.
- Secrets Manager unterstützt Secret Rotation.
- Masking schützt Darstellung; Encryption schützt gespeicherte oder übertragene Daten.

---

## M28 – CloudWatch Monitoring und Alerting

**Floci:** CloudWatch Metrics und Logs, SNS  
**AWS-Pendant:** Amazon CloudWatch  
**Dauer:** 6–8 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 3.3.1–3.3.4, 3.3.7–3.3.8, 4.4.2

### Theorie

- Metric
- Namespace
- Dimension
- Log Group
- Log Stream
- Alarm
- Dashboard
- Metric Filter
- Logs Insights
- SLIs und SLOs
- Pipeline Audit Metrics

### Aufgaben

1. Custom Metrics schreiben.
2. Log Group und Streams.
3. strukturierte JSON Logs.
4. Alarm mit SNS.
5. Error Rate und Duration.
6. Pipeline-Run-Audit-Tabelle.
7. Runbook für Alarm.
8. Logs nach S3 exportieren oder lokal analysieren.

### Failure Injection

- Lambda Errors
- Throttling
- fehlende Daten
- verspätete Pipeline
- falsche Alarm-Schwelle

### Exam Transfer

- CloudWatch überwacht Metriken und Logs.
- CloudTrail auditiert API-Aktivitäten.
- Alarmierung benötigt klare Schwellen und Zielaktionen.

---

## M29 – CloudTrail, Config und Audit

**Floci:** CloudTrail, AWS Config, Athena/S3  
**AWS-Pendant:** AWS CloudTrail, AWS Config, CloudTrail Lake  
**Dauer:** 5–7 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 3.3.1–3.3.2, 3.3.5, 4.4.1–4.4.5, 4.5.4

### Theorie

- Management Event
- Data Event
- Trail
- API Audit
- Configuration History
- Compliance Rule
- CloudTrail Lake
- CloudWatch vs. CloudTrail vs. Config

### Aufgaben

1. Trail konfigurieren.
2. API-Aktivitäten erzeugen.
3. Logs in S3 untersuchen.
4. Athena-Tabelle für Audit Logs.
5. Config Recorder und Rule konzeptionell.
6. Konfigurationsänderung dokumentieren.
7. Audit Query schreiben.
8. Incident Timeline erstellen.

### Exam Transfer

- CloudTrail: Wer hat welche API aufgerufen?
- Config: Wie hat sich eine Ressourcenkonfiguration verändert?
- CloudWatch: Wie verhielt sich die Anwendung?

---

## M30 – Backup, Retention, Transfer und Recovery

**Floci:** AWS Backup, Transfer Family, S3, RDS  
**AWS-Pendant:** AWS Backup, AWS Transfer Family, AWS DataSync, Snow Family  
**Dauer:** 5–7 Stunden  
**Klasse:** A/B/E  
**Exam Mapping:** 2.1.4–2.1.5, 2.3.5–2.3.6

### Theorie

- Backup Plan
- Backup Vault
- Retention
- Restore
- RPO/RTO
- DataSync
- Transfer Family
- Snow Family
- Online vs. Offline Transfer
- Migration vs. Replication

### Aufgaben

1. Backup Plan und Vault lokal.
2. S3-Versionierungsrestore.
3. RDS-Backup-Runbook.
4. SFTP-Transfer mit Transfer Family, sofern lokal möglich.
5. Tool-Auswahl für Migration Cases.
6. Recovery Drill durchführen.

### Exam Transfer

- DataSync für beschleunigte Online-Datenübertragung.
- Transfer Family für SFTP/FTPS/FTP-Zugriff auf AWS Storage.
- Snow Family bei sehr großen Offline-Transfers oder begrenzter Bandbreite.

---

## M31 – Data Privacy und Governance

**Lokaler Ersatz:** IAM, Tags, KMS, S3, Glue Catalog  
**AWS-Pendant:** AWS Lake Formation, Amazon Macie, SageMaker Catalog  
**Dauer:** 6–8 Stunden  
**Klasse:** D/E  
**Exam Mapping:** 4.2.4, 4.5.1–4.5.7

### Kritische Grenze

Lake Formation, Macie und SageMaker Catalog sind nicht vollständig lokal emulierbar. Die Mission nutzt Policy-Design, Metadaten, Tags und lokale PII-Scans als Ersatz.

### Theorie

- Central Governance
- Database/Table/Column Permissions
- Data Lake Location
- IAM vs. Lake Formation
- PII Detection
- Data Sovereignty
- Regional Restriction
- Producer/Consumer Data Products
- Business Glossary
- Subscription Workflow
- Governance Framework

### Aufgaben

1. Datenklassifikation definieren.
2. PII-Scanner lokal schreiben.
3. Masking-Transformation.
4. Tag-basierte Zugriffsmatrix.
5. Lake-Formation-Berechtigungsszenarien lösen.
6. Cross-Account-Data-Sharing-Design.
7. Data Sovereignty Policy.
8. Business Catalog Modell erstellen.

### Exam Transfer

- Lake Formation ergänzt IAM um feingranulare Datenberechtigungen.
- Macie erkennt sensible Daten in S3.
- Data Sovereignty betrifft Speicher-, Backup- und Replikationsregionen.

---

## M32 – Infrastructure as Code

**Floci:** CloudFormation  
**AWS-Pendant:** AWS CloudFormation, AWS SAM, AWS CDK  
**Zusatz:** Terraform/OpenTofu  
**Dauer:** 8–12 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.4.5–1.4.8

### Aufgaben

1. S3, Lambda, SQS und IAM per CloudFormation.
2. Parameter und Outputs.
3. Stack Update.
4. Rollback.
5. SAM Template für serverlose Pipeline.
6. CDK Stack.
7. Terraform-Variante.
8. Drift und idempotente Deployments.
9. Destroy/Cleanup.

### Exam Transfer

- IaC sorgt für reproduzierbare Deployments.
- SAM spezialisiert CloudFormation für Serverless.
- CDK erzeugt CloudFormation aus Programmiersprachen.

---

## M33 – CI/CD und Integration Testing

**Floci:** CodeBuild, CodePipeline, CodeDeploy, Testcontainers  
**AWS-Pendant:** AWS CodeBuild, CodePipeline, CodeDeploy  
**Dauer:** 6–9 Stunden  
**Klasse:** A/B  
**Exam Mapping:** 1.4.4, 1.4.9

### Aufgaben

1. Unit Tests.
2. Data Contract Tests.
3. Integration Tests gegen Floci.
4. Testcontainers verwenden.
5. Buildspec.
6. Pipeline definieren.
7. IaC Validation.
8. Testdaten aufbauen und entfernen.
9. Deployment Gate.

### Exam Transfer

- CI validiert Code und Infrastruktur.
- CD automatisiert Deployment.
- Integration Tests müssen Seiteneffekte und Cleanup berücksichtigen.

---

## M34 – Cost Explorer, CUR und Data Exports

**Floci:** Pricing, Cost Explorer, CUR, BCM Data Exports  
**AWS-Pendant:** AWS Cost Explorer, Cost and Usage Reports, AWS Data Exports  
**Dauer:** 6–8 Stunden  
**Klasse:** B/D  
**Exam Mapping:** 1.2.4, 2.1.1, 3.3.4

### Business Scenario

Das Unternehmen möchte Kostenentwicklung mit Nutzung und Pipeline-Performance verbinden.

### Theorie

- Cost Allocation Tags
- CUR / Data Exports
- Granularity
- Resource IDs
- Parquet
- Athena Cost Queries
- Cost per 1.000 Invocations
- Cost Anomaly
- Storage/Request/Compute Cost Drivers

### Aufgaben

1. Data-Export-Definition lokal anlegen.
2. synthetische CUR-Parquet-Daten erzeugen.
3. Glue Catalog und Athena.
4. Kosten pro Service.
5. Kosten pro Resource.
6. Monatsvergleich.
7. Kosten vs. Usage Growth.
8. Governance-Checks für Owner und CostCenter.

### Capstone-Bezug

Diese Mission kann direkt Teile des Projekts **CloudOps Insight Lake** abbilden.

---

## M35 – Performance- und Kostenoptimierung

**Dauer:** 5–7 Stunden  
**Klasse:** E  
**Exam Mapping:** 1.2.4, 2.1.1–2.1.3, 3.3.4

### Optimierungsfälle

- Athena scannt zu viele Daten
- Spark Shuffle
- DynamoDB Hot Partition
- Lambda Timeout
- Kinesis Hot Shard
- RDS fehlender Index
- zu viele Small Files
- unnötiger Always-on-Cluster
- falsche Storage Class
- zu aggressive Partitionierung

### Deliverable

Ein Optimierungs-Playbook mit:

- Symptom
- Messung
- Ursache
- Lösung
- Trade-off
- AWS-Kostenwirkung

---

## M36 – Apache Iceberg und Open Table Formats

**Lokaler Ersatz:** PyIceberg, DuckDB oder Spark  
**AWS-Pendant:** Apache Iceberg auf S3, Athena, Glue, EMR, Redshift, S3 Tables  
**Dauer:** 7–10 Stunden  
**Klasse:** D/E  
**Exam Mapping:** 2.1.7, 2.4.2, 2.4.5

### Theorie

- Open Table Format
- Snapshot
- Manifest
- Metadata File
- ACID
- Schema Evolution
- Partition Evolution
- Time Travel
- Row-level Update/Delete
- Compaction
- Orphan Files
- Iceberg vs. reines Parquet Dataset
- S3 Tables

### Aufgaben

1. Iceberg-Tabelle lokal erstellen.
2. Insert.
3. Update/Delete.
4. Time Travel.
5. Schema Evolution.
6. Partition Evolution.
7. Compaction-Konzept.
8. Integration zu Glue Catalog theoretisch dokumentieren.

### Exam Transfer

- Iceberg ergänzt Data Lakes um Tabellenmetadaten und Transaktionsfunktionen.
- Parquet ist ein Dateiformat; Iceberg ist ein Tabellenformat.

---

## M37 – Vectors, HNSW, IVF und S3 Vectors

**Floci:** S3 Vectors, optional OpenSearch  
**AWS-Pendant:** Amazon S3 Vectors, OpenSearch, Aurora PostgreSQL pgvector, MemoryDB  
**Dauer:** 6–8 Stunden  
**Klasse:** A/D/E  
**Exam Mapping:** 2.1.8, 2.4.6

### Theorie

- Vector
- Embedding
- Dimension
- Similarity Search
- Cosine Similarity
- Euclidean Distance
- Exact vs. Approximate Nearest Neighbor
- HNSW
- IVF
- Recall vs. Latency
- Vector Store Selection

### Aufgaben

1. kleine Embeddings erzeugen.
2. in lokalem Vector Store speichern.
3. Similarity Search.
4. HNSW und IVF konzeptionell vergleichen.
5. Metadata Filtering.
6. Kosten-/Latenz-/Recall-Trade-off dokumentieren.
7. S3 Vectors testen, soweit lokal unterstützt.

### Exam Transfer

- HNSW benötigt typischerweise mehr Speicher, bietet aber schnelle Suche.
- IVF clustert Vektoren und durchsucht ausgewählte Bereiche.
- Vectorization ist Datenverarbeitung, nicht zwingend ML-Training.

---

## M38 – Bedrock, RAG und LLM Data Processing

**Floci:** Bedrock Runtime Stub  
**AWS-Pendant:** Amazon Bedrock, Bedrock Knowledge Bases  
**Lokaler Ersatz:** lokales Embedding-/LLM-Modell oder Mock  
**Dauer:** 5–7 Stunden  
**Klasse:** B/D/E  
**Exam Mapping:** 1.2.10, 2.4.6

### Kritische Grenze

Floci stellt nur begrenzte Bedrock-Runtime-Operationen bereit. Knowledge Bases, Guardrails und vollständige Modellsemantik müssen theoretisch oder mit lokalem Ersatz bearbeitet werden.

### Business Scenario

Support-Tickets sollen klassifiziert, zusammengefasst und für semantische Suche vorbereitet werden.

### Theorie

- Prompt
- Token
- Chunking
- Embedding
- Vector Store
- RAG
- Knowledge Base
- Metadata
- Hallucination
- PII
- Cost Control
- Batch Inference vs. Online Processing

### Aufgaben

1. Dokumente chunking.
2. Metadata hinzufügen.
3. Embeddings erzeugen.
4. Retrieval.
5. LLM-Klassifikation mocken.
6. PII vor Verarbeitung maskieren.
7. Fehlende Quellen und Hallucination behandeln.
8. RAG-Architektur auf AWS entwerfen.

---

## M39 – SageMaker Unified Studio und Business Data Catalog

**AWS-Pendant:** Amazon SageMaker Unified Studio, SageMaker Catalog  
**Dauer:** 4–6 Stunden  
**Klasse:** E  
**Exam Mapping:** 2.2.6, 4.1.7, 4.5.6–4.5.7

### Theorie

- Domain
- Domain Unit
- Project
- Asset
- Producer Project
- Consumer Project
- Subscription
- Business Data Catalog
- Business Glossary
- Authorization Policy
- Data Product
- Governance Framework
- SageMaker Lakehouse

### Aufgaben

1. Organisationsmodell entwerfen.
2. Domain Units für Sales, Finance und Operations.
3. Producer-/Consumer-Projekte.
4. Asset-Publishing-Prozess.
5. Subscription Approval.
6. Business Glossary.
7. Cross-Account Pattern.
8. Vergleich zu Glue Data Catalog und Lake Formation.

---

## M40 – Capstone: Batch Analytics Platform

**Dauer:** 15–25 Stunden  
**Klasse:** A/D  
**Domains:** 1, 2, 3, 4

### Ziel

Eine vollständige Batch-Plattform bauen:

```text
RDS + CSV + DynamoDB Export
        ↓
S3 Raw
        ↓
PySpark/Python Transformation
        ↓
S3 Curated Parquet
        ↓
Glue Data Catalog
        ↓
Athena
        ↓
API / Reports
```

### Pflichtanforderungen

- Incremental Processing
- Manifest
- Data Quality
- Quarantine
- Partitionierung
- Logging
- Audit
- IAM Design
- KMS Design
- IaC
- Integration Tests
- Runbook
- Cost Model
- Architecture Decision Records

### Abnahme

- End-to-End-Demo
- zehn unbekannte Datenfehler
- Recovery ohne Datenverlust
- Architekturverteidigung in zehn Minuten
- 25 passende Exam-Fragen

---

## M41 – Capstone: Streaming Operations Platform

**Dauer:** 15–25 Stunden  
**Klasse:** A  
**Domains:** 1, 2, 3, 4

### Ziel

```text
Producer
   ↓
Kinesis oder MSK
   ↓
Lambda Consumer
   ├──> DynamoDB Operational State
   ├──> S3 Raw
   └──> SQS DLQ
            ↓
       Step Functions Recovery
```

### Pflichtanforderungen

- Partition Key Strategy
- Replay
- Duplicate Handling
- Poison Records
- Backpressure
- Schema Registry
- Monitoring
- Alarm
- Recovery
- IaC
- Performance Test
- Security Design

---

## M42 – Incident Simulation und Architecture Defense

**Dauer:** 8–12 Stunden  
**Klasse:** A/E

### Incidents

1. Athena scannt plötzlich zehnmal mehr Daten.
2. Kinesis Consumer Lag steigt.
3. Lambda wird gedrosselt.
4. DynamoDB erzeugt Hot Partitions.
5. RDS ist wegen Locks langsam.
6. Glue-Catalog-Schema passt nicht zu Dateien.
7. fehlerhafte Records blockieren die Pipeline.
8. Zugriff wird trotz IAM Allow verweigert.
9. KMS Cross-Account funktioniert nicht.
10. Kosten steigen ohne Nutzungsanstieg.

### Pro Incident

- Symptom
- Hypothesen
- Messpunkte
- Logs/Metriken
- Root Cause
- Fix
- Prevention
- Postmortem

---

## M43 – Mock Exam und Final Readiness

**Dauer:** 15–25 Stunden  
**Klasse:** E

### Readiness-Kriterien

- zwei unbekannte Mock Exams mit mindestens 80–85 %
- keine Domain dauerhaft unter 75 %
- SQL-Fragen sicher
- 65 Fragen in höchstens 115–120 Minuten
- 20 zentrale Servicevergleiche ohne Unterlagen
- jede falsche Antwort fachlich widerlegen
- Capstone Architecture Defense bestanden
- Error Log vollständig bearbeitet

---

# 8. Theoriekompendium

## 8.1 Data Fundamentals

Beherrschen:

- structured, semi-structured, unstructured
- Volume, Velocity, Variety
- Batch vs. Streaming
- ETL vs. ELT
- Data Lake vs. Warehouse vs. Lakehouse
- Schema-on-read vs. Schema-on-write
- stateful vs. stateless
- Replayability
- Fan-in und Fan-out
- Idempotency
- Data Lineage
- Data Lifecycle
- Schema Evolution
- Partitioning
- Compression
- Data Skew
- Small Files

## 8.2 SQL

Pflicht:

- INNER, LEFT, RIGHT, FULL JOIN
- GROUP BY
- HAVING
- CTE
- Subquery
- Window Function
- PARTITION BY
- ROW_NUMBER, RANK, DENSE_RANK
- Rolling Average
- Deduplication
- NULL Handling
- CASE
- Pivoting
- Views
- Materialized Views
- CTAS
- Redshift COPY/UNLOAD konzeptionell
- Locks und Transactions

## 8.3 Storage

- Object, Block, File
- S3 Storage Classes
- EBS
- EFS
- Backup
- Lifecycle
- Versioning
- Replication
- Encryption
- Partitioning
- Access Patterns

## 8.4 Streaming

- Queue vs. Stream
- Retention
- Replay
- Ordering
- Partition Key
- Shard/Partition
- Consumer Group
- DLQ
- Backpressure
- Exactly-once als End-to-End-Eigenschaft
- at-least-once Delivery und Idempotenz

## 8.5 Security

- Authentication
- Authorization
- Least Privilege
- IAM Role
- Trust Policy
- Resource Policy
- KMS
- Secrets
- Encryption at Rest/Transit
- Masking
- Tokenization
- VPC Endpoint
- PrivateLink
- Audit

## 8.6 Operations

- Metrics
- Logs
- Traces konzeptionell
- Alerts
- Audit Trail
- Runbook
- Postmortem
- Data Quality
- Performance Tuning
- Cost Optimization

---

# 9. Exam-Guide-Coverage-Matrix

## Domain 1 – Data Ingestion and Transformation

| Task | Missionen |
|---|---|
| 1.1 Perform data ingestion | M01, M03, M07, M08, M11–M15, M17 |
| 1.2 Transform and process data | M04, M06, M10, M22–M25, M38 |
| 1.3 Orchestrate data pipelines | M07–M09, M40–M41 |
| 1.4 Apply programming concepts | M00, M06, M22, M24–M25, M32–M33 |

## Domain 2 – Data Store Management

| Task | Missionen |
|---|---|
| 2.1 Choose a data store | M01–M02, M13, M16, M18–M21, M36–M37 |
| 2.2 Understand data cataloging systems | M03, M05, M31, M39 |
| 2.3 Manage the lifecycle of data | M02, M17, M30 |
| 2.4 Design data models and schema evolution | M04–M05, M16, M18, M31, M36–M37 |

## Domain 3 – Data Operations and Support

| Task | Missionen |
|---|---|
| 3.1 Automate data processing | M06, M08–M10, M22–M25, M32–M33 |
| 3.2 Analyze data | M03–M04, M18, M34, M40 |
| 3.3 Maintain and monitor pipelines | M12, M22–M23, M28–M30, M35, M42 |
| 3.4 Ensure data quality | M04–M05, M06, M22, M40–M42 |

## Domain 4 – Data Security and Governance

| Task | Missionen |
|---|---|
| 4.1 Authentication | M19, M26–M27, M31, M39 |
| 4.2 Authorization | M19, M26–M27, M31 |
| 4.3 Encryption and masking | M02, M27, M31, M38 |
| 4.4 Prepare logs for audit | M28–M29, M42 |
| 4.5 Privacy and governance | M31, M34, M39 |

---

# 10. Services, die Floci nicht vollständig ersetzt

Diese Themen bleiben zwingend im Lernplan:

| AWS-Service/Thema | Lokale Strategie |
|---|---|
| Amazon Redshift | SQL mit PostgreSQL/DuckDB; Redshift-spezifische Theorie und optionales Real-AWS-Lab |
| AWS Lake Formation | Berechtigungsmatrix, IAM-/Tag-Simulation, offizielle Labs |
| AWS Glue Crawlers | Catalog-Einträge manuell; Crawler-Entscheidungslogik theoretisch |
| AWS Glue Spark Jobs | lokales PySpark |
| Amazon MWAA | lokale Airflow-DAG oder Theorie |
| AWS DMS | CDC mit Debezium/Kafka oder Theorie; optionales Real-AWS-Lab |
| AWS DataSync | Transfer-Simulation und Serviceauswahl |
| Amazon AppFlow | API-/SaaS-Ingestion-Simulation |
| Amazon Macie | lokaler PII-Scanner und Theorie |
| Amazon Quick | lokales BI-Tool oder Query-Result-Analyse |
| SageMaker Unified Studio | Organisations- und Governance-Modell |
| SageMaker Catalog | Business-Catalog-Simulation |
| Amazon S3 Tables | Iceberg lokal |
| Managed Service for Apache Flink | lokales Flink oder Streaming-Theorie |
| Amazon Bedrock Knowledge Bases | lokales RAG-System |
| Amazon Kendra | lokale Search-/Retrieval-Simulation |
| Snow Family | Entscheidungsfälle und Theorie |
| reale Multi-AZ/Multi-Region | Architekturreview und optionales AWS-Lab |

---

# 11. Progress Tracking

## 11.1 Mission Log

```markdown
## MXX – Titel

- Status: Not Started / In Progress / Review / Completed
- Start:
- Abschluss:
- Zeit:
- Exam Domains:
- Services:
- Score vor Mission:
- Score nach Mission:
- Größte Fehlvorstellung:
- Wichtigster Architekturentscheid:
- Offene Lücke:
```

## 11.2 Error Log

```markdown
| Datum | Mission | Fehler | Symptom | Root Cause | Fix | Prävention | Exam Keyword |
|---|---|---|---|---|---|---|---|
```

## 11.3 Exam Scorecard

```markdown
| Domain | Questions | Correct | Percentage | Trend | Weak Areas |
|---|---:|---:|---:|---|---|
| Domain 1 | | | | | |
| Domain 2 | | | | | |
| Domain 3 | | | | | |
| Domain 4 | | | | | |
```

---

# 12. Wiederholungs- und Prüfungsplan

## Nach jeder Mission

- 5 Recall Questions
- 5 Exam Questions
- 1 Architekturvergleich
- 1 Failure Scenario
- Wiederholung nach 1, 3, 7, 14 und 30 Tagen

## Nach jeder Phase

- 20–30 gemischte Fragen
- Architekturdiagramm ohne Unterlagen
- zwei Servicevergleiche
- ein Troubleshooting-Fall
- Fortschrittsreview

## Vor der Prüfung

### Vier Wochen vorher

- erster vollständiger Mock Exam
- Weak Areas priorisieren
- keine neuen großen Projekte beginnen

### Zwei Wochen vorher

- zwei weitere Mock Exams
- SQL-Training
- Decision Matrix Review
- v1.1-Themen prüfen

### Letzte Woche

- leichte Wiederholung
- Error Log
- Exam Keywords
- keine Exam Dumps
- Schlaf und Zeitmanagement

---

# 13. Zentrale Servicevergleiche

Diese Vergleiche müssen ohne Unterlagen beherrscht werden:

1. Athena vs. Redshift
2. Glue vs. EMR
3. Glue vs. Lambda
4. Kinesis Data Streams vs. Data Firehose
5. Kinesis vs. MSK
6. Step Functions vs. MWAA
7. EventBridge vs. Step Functions
8. S3 vs. EBS vs. EFS
9. RDS/Aurora vs. DynamoDB
10. Redshift vs. RDS
11. Spectrum vs. Federated Query vs. Data Sharing
12. Parquet/ORC vs. CSV/JSON
13. Lifecycle vs. Versioning vs. Replication
14. IAM vs. Lake Formation
15. Macie vs. Glue Detect PII vs. Masking
16. provisioned vs. serverless
17. DMS Full Load vs. CDC
18. Parquet Dataset vs. Iceberg Table
19. ECS vs. EKS vs. Fargate
20. Secrets Manager vs. Parameter Store
21. SQS vs. Kinesis
22. SNS vs. EventBridge
23. DynamoDB GSI vs. LSI
24. RDS Multi-AZ vs. Read Replica
25. CloudWatch vs. CloudTrail vs. Config

Für jeden Vergleich:

- primärer Use Case
- Latenz
- Skalierung
- Kostenmodell
- Operational Overhead
- Grenzen
- Security
- typische Exam Keywords
- warum die Alternative schlechter ist

---

# 14. Empfohlene Reihenfolge

## Pflichtpfad für das Exam

```text
M00
→ M01
→ M03
→ M04
→ M06
→ M07
→ M08
→ M09
→ M11
→ M12
→ M13
→ M16
→ M17
→ M18
→ M21
→ M22
→ M23
→ M26
→ M27
→ M28
→ M29
→ M31
→ M32
→ M34
→ M36
→ M37
→ M38
→ M39
→ M40
→ M42
→ M43
```

## Erweiterungspfad für tiefere Engineering-Kompetenz

```text
M02, M05, M10, M14, M15, M19, M20, M24, M25, M30, M33, M35, M41
```

---

# 15. Startanweisung für das neue ChatGPT-Projekt

Kopiere den folgenden Text in die Projektinstruktionen:

```text
Du bist mein AWS Data Engineering Mission Tutor für die Vorbereitung auf AWS Certified Data Engineer – Associate DEA-C01.

Verwende den hochgeladenen Floci Hands-on Missionenplan als verbindliche Lernstruktur.

Arbeite immer in kleinen Schritten. Gib pro Nachricht nur den nächsten sinnvollen Schritt, außer ich fordere ausdrücklich eine Gesamtübersicht.

Nenne bei jedem Floci-Service immer das genaue AWS-Pendant.

Führe jede Mission nach diesem Muster:
1. reale Problemstellung
2. Anforderungen
3. meine Architekturhypothese
4. Theorie
5. GUI
6. CLI/API
7. IaC
8. Tests
9. absichtlicher Fehler
10. Troubleshooting
11. AWS-Reality-Check
12. Exam Transfer
13. Recall Check
14. Dokumentation

Verrate die vollständige Lösung nicht sofort. Stelle zuerst gezielte Verständnis- und Architekturfragen.

Korrigiere Fehlvorstellungen klar und technisch präzise. Trenne Fakten, Annahmen und Einschätzung.

Prüfe Screenshots, CLI-Ausgaben und Code. Erkläre Fehlerursache, Fix und Prävention.

Behandle Floci nicht als vollständigen AWS-Ersatz. Nenne explizit, welche Aspekte lokal nicht realistisch emuliert werden.

Nach jeder Mission:
- kurzes Exam-Briefing
- fünf Recall-Fragen
- fünf szenariobasierte Exam-Fragen
- Erklärung aller Antwortoptionen
- Fortschrittsstatus
- Wiederholungstermin nach Spaced Repetition

Beginne mit der zuletzt offenen Mission und frage nur nach Informationen, die tatsächlich fehlen.
```

---

# 16. Offizielle Quellen

1. AWS Certified Data Engineer – Associate Exam Guide (DEA-C01), Version 1.1  
   https://docs.aws.amazon.com/aws-certification/latest/data-engineer-associate-01/data-engineer-associate-01.html

2. AWS DEA-C01 PDF Exam Guide  
   https://docs.aws.amazon.com/pdfs/aws-certification/latest/data-engineer-associate-01/data-engineer-associate-01.pdf

3. Floci Services Overview  
   https://floci.io/floci/services/

4. Floci Quick Start  
   https://floci.io/floci/getting-started/quick-start/

5. Floci Glue  
   https://floci.io/floci/services/glue/

6. Floci Athena  
   https://floci.io/floci/services/athena/

7. Floci Lambda  
   https://floci.io/floci/services/lambda/

8. Floci Kinesis  
   https://floci.io/floci/services/kinesis/

9. Floci DynamoDB  
   https://floci.io/floci/services/dynamodb/

10. Floci RDS  
    https://floci.io/floci/services/rds/

11. Floci MSK  
    https://floci.io/floci/services/msk/

12. Floci EMR  
    https://floci.io/floci/services/emr/

13. Floci Data Firehose  
    https://floci.io/floci/services/firehose/

---

# 17. Schlussbewertung

Floci ist für diese Vorbereitung sehr wertvoll, weil es einen großen Teil des AWS-API- und Integrationsverhaltens lokal trainierbar macht. Der Plan vermeidet jedoch den Fehler, lokale Funktionsfähigkeit mit vollständiger AWS-Kompetenz gleichzusetzen.

Der erfolgreiche Abschluss erfordert deshalb drei Beweisarten:

1. **Hands-on-Beweis**  
   Die Pipeline funktioniert lokal und ist reproduzierbar.

2. **Architekturbeweis**  
   Die Serviceauswahl kann gegen Alternativen verteidigt werden.

3. **Exam-Beweis**  
   Unbekannte Szenariofragen werden unter Zeitdruck zuverlässig gelöst.

Nur die Kombination dieser drei Ebenen ist eine belastbare Vorbereitung auf DEA-C01 und auf reale Data-Engineering-Arbeit.
