# Ressourcenbedarf

| Profil | RAM Minimum | RAM empfohlen | CPU | Speicher | Hinweise |
|---|---:|---:|---:|---:|---|
| Core | 2 GB | 4 GB | 2 | 2 GB | dynamische Services erhöhen Bedarf |
| tools | 1 GB | 2 GB | 1 | 3–5 GB | großes Werkzeugimage |
| lab | 2 GB | 4 GB | 2 | 3 GB | Notebook-Daten separat |
| spark | 4 GB | 8 GB | 4 | 5 GB | Worker standardmäßig 2 GB |
| cdc | 3 GB | 5 GB | 3 | 4 GB | PostgreSQL + Redpanda + Connect |
| airflow | 3 GB | 5 GB | 3 | 4 GB | LocalExecutor statt Celery |
| flink | 2 GB | 4 GB | 2 | 2 GB | Checkpoints persistent |
| vector | 1 GB | 2 GB | 1 | 2 GB | nur eine Vektordatenbank |
| rag | 256 MB | 512 MB | 1 | <1 GB | keine großen Modelle |
| bi | 1 GB | 2 GB | 2 | 1–3 GB | nur bei Bedarf |
| observability | 2 GB | 4 GB | 2 | 3–10 GB | Retention beobachten |

Nicht alle Profile gleichzeitig auf einem normalen Laptop starten. EKS, OpenSearch und MSK nach Übungen löschen.
