# Portmatrix

| Port/Range | Komponente | Bindung |
|---:|---|---|
| 3000 | Mission Control | 127.0.0.1 |
| 4500 | offizielle Floci UI | 127.0.0.1 |
| 4566 | Floci AWS API | 127.0.0.1 |
| 5100–5199 | dynamische ECR Registry | durch Floci-Child-Container |
| 6500–6599 | dynamische EKS API Server | durch Floci-Child-Container |
| 7000–7099 | dynamische RDS Proxies | durch Floci-Child-Container |
| 9400–9499 | dynamische OpenSearch Proxies | durch Floci-Child-Container |
| 8888 | JupyterLab | 127.0.0.1 |
| 7077 / 8082 / 8083 | Spark RPC/Master/Worker UI | 127.0.0.1 |
| 8080 | Airflow | 127.0.0.1 |
| 8081 | Flink | 127.0.0.1 |
| 8084 | Debezium Connect API | 127.0.0.1 |
| 8090 | RAG API | 127.0.0.1 |
| 3001 | Metabase | 127.0.0.1 |
| 3002 / 9090 | Grafana / Prometheus | 127.0.0.1 |

MSK/Redpanda-Ports werden ebenfalls dynamisch vergeben. Diese Bereiche werden **nicht** am Core-Container veröffentlicht; die von Floci erzeugten Child-Container binden bei Bedarf einen einzelnen Port. `doctor.ps1` nennt bei statischen Konflikten den Port und den belegenden Prozess. Profilports können in `.env` angepasst werden.

Offizielle Floci-Portkonfiguration: https://floci.io/floci/configuration/environment-variables/
