# Bekannte Grenzen

- Floci ist kein vollständiges AWS und beweist keine Produktionsskalierung, Quotas, Multi-AZ, Multi-Region, Latenz oder reale Abrechnung.
- UI-Abdeckung und Floci-Serviceabdeckung sind nicht identisch.
- IAM-, KMS-, Netzwerk- und Cross-Account-Verhalten kann von AWS abweichen.
- Glue Spark wird durch lokales Spark ersetzt; Glue Crawler und Jobs sind nicht vollständig ausgeführt.
- EMR ist überwiegend Control Plane; Redshift und Lake Formation bleiben Ersatzübung/Theorie beziehungsweise optionales Real-AWS-Lab.
- Kostenmodelle, SageMaker Unified Studio, Lake Formation, Bedrock Knowledge Bases und Managed-Service-Betrieb sind lokal begrenzt.
- Die RAG-API erzeugt deterministische Lernvektoren, keine semantisch hochwertigen Modell-Embeddings.
- Die Airflow-Smoke-DAG ist Infrastrukturprüfung und keine Missionslösung.
- EKS, OpenSearch, MSK, RDS und weitere dynamische Engines benötigen zusätzliche Images, RAM und freie Portbereiche.

Die aktuelle Floci-Service-Matrix ist maßgeblich: https://floci.io/floci/services/
