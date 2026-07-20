# Compose-Profile

| Profil | Zweck | Hostadresse | Missionen |
|---|---|---|---|
| Core (ohne Profil) | Floci, offizielle UI, Mission Control | 3000, 4500, 4566 | M00–M43 Basis |
| `tools` | AWS CLI v2, Boto3, SAM, CDK, OpenTofu, kubectl, Helm, Datenwerkzeuge | Shell | M00, M32, M33 |
| `lab` | Jupyter, Pandas, Polars, PyArrow, DuckDB | http://localhost:8888 | M04, M34–M38 |
| `spark` | Spark Master/Worker, S3A, Parquet, Iceberg | http://localhost:8082 | M22, M36, M40 |
| `cdc` | PostgreSQL WAL, Debezium, dediziertes Redpanda | Connect API 8084 | DMS-Ersatzübungen |
| `airflow` | LocalExecutor, Webserver, Scheduler | http://localhost:8080 | MWAA-Ersatz |
| `flink` | Stateful Streaming, Checkpoints | http://localhost:8081 | Flink-Ersatz |
| `vector` | PostgreSQL + pgvector | intern | M37 |
| `rag` | deterministische Mock-Embeddings, keine Modelldownloads | http://localhost:8090 | M38 |
| `bi` | Metabase | http://localhost:3001 | einfache BI-Validierung |
| `observability` | Prometheus, Grafana, cAdvisor | 9090, 3002 | lokale Plattformmetriken |

Der CDC-Broker ist nur DMS-Ersatz und ersetzt nicht die Floci-MSK-Mission. Prometheus/Grafana beobachten Docker; Floci CloudWatch bleibt das AWS-Lernobjekt.
