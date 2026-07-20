# Image Lock

Stand: 17. Juli 2026. Keine Core- oder Profildefinition verwendet `latest`. Images wurden über die offiziellen Registry APIs beziehungsweise Releases auf Existenz geprüft.

| Komponente | Image | Version/Digest | Lizenz | Zweck | Quelle |
|---|---|---|---|---|---|
| Floci | `floci/floci` | `1.5.33-compat`, `sha256:2303…be751` | MIT | AWS-Emulator | https://github.com/floci-io/floci/releases/tag/1.5.33 |
| Floci UI | `floci/floci-ui` | `0.2.0`, `sha256:03a2…24d9` | MIT | Ressourcen-UI | https://github.com/floci-io/floci-ui |
| Mission Tracker | `node` | `22.17.0-alpine3.22` | MIT (Node.js) | Fortschritts-UI | https://hub.docker.com/_/node |
| Toolbox/RAG | `python` | `3.12.11-slim-bookworm` | PSF | Clients/Testwerkzeuge | https://hub.docker.com/_/python |
| Jupyter | `quay.io/jupyter/datascience-notebook` | `python-3.12.10` | BSD-3-Clause | Notebook-Lab | https://github.com/jupyter/docker-stacks |
| Spark | `apache/spark` | `3.5.6-python3` | Apache-2.0 | Spark/Iceberg | https://hub.docker.com/r/apache/spark |
| PostgreSQL | `postgres` | `16.9-alpine3.21` | PostgreSQL | CDC/Airflow | https://hub.docker.com/_/postgres |
| Redpanda | `redpandadata/redpanda` | `v25.1.9` | BSL/Apache-2.0-Komponenten | CDC-Broker | https://docs.redpanda.com/current/get-started/quick-start/ |
| Debezium | `quay.io/debezium/connect` | `3.1.2.Final` | Apache-2.0 | CDC Connect | https://debezium.io/releases/3.1/ |
| Airflow | `apache/airflow` | `2.10.5-python3.12` | Apache-2.0 | MWAA-Ersatz | https://airflow.apache.org/docs/docker-stack/ |
| Flink | `flink` | `1.20.2-scala_2.12-java17` | Apache-2.0 | Streaming-Ersatz | https://hub.docker.com/_/flink |
| pgvector | `pgvector/pgvector` | `0.8.0-pg16` | PostgreSQL | Vektorsuche | https://github.com/pgvector/pgvector |
| Metabase | `metabase/metabase` | `v0.54.8` | AGPL-3.0 | lokales BI | https://www.metabase.com/docs/latest/installation-and-operation/running-metabase-on-docker |
| Prometheus | `prom/prometheus` | `v3.5.0` | Apache-2.0 | Metriken | https://prometheus.io/docs/prometheus/latest/installation/ |
| Grafana | `grafana/grafana` | `12.0.2` | AGPL-3.0 | Dashboards | https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/ |
| cAdvisor | `gcr.io/cadvisor/cadvisor` | `v0.52.1` | Apache-2.0 | Container-Metriken | https://github.com/google/cadvisor |

Von Floci dynamisch verwendete Images sind im Compose explizit auf PostgreSQL `16.9`, Redpanda `25.1.9`, OpenSearch `2.19.1`, k3s `1.32.6`, Registry `2.8.3` und floci-duck `0.2.0` festgelegt.
