# Mission-Infrastruktur-Matrix

> Generiert aus `content/DEA-C01_Floci_Hands-on_Missionenplan.md` mit `node scripts/generate-mission-matrix.mjs`. Der Missionenplan bleibt die fachliche Source of Truth.

| Mission | benötigte Services | Floci-Komponente | Zusatzcontainer | Startprofil | lokale Einschränkungen |
|---|---|---|---|---|---|
| M00 – Floci Engineering Foundation | AWS APIs, AWS CLI, AWS SDKs / Plattform, Multi-Service Endpoint | Plattform, Multi-Service Endpoint | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M01 – S3 Data Lake Fundamentals | Amazon S3 / Storage / S3 | Storage / S3 | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M02 – S3 Lifecycle, Versioning und Resilienz | Amazon S3, S3 Glacier / S3 | S3 | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M03 – Glue Data Catalog und Athena | AWS Glue Data Catalog, Amazon Athena / Glue Data Catalog, Athena | Glue Data Catalog, Athena | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M04 – File Formats, Partitionierung und Data Quality | Amazon S3, Athena, Glue / S3, Athena, Glue Catalog | S3, Athena, Glue Catalog | keiner | `core` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M05 – Glue Schema Registry und Data Contracts | AWS Glue Schema Registry / Glue Schema Registry | Glue Schema Registry | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M06 – Lambda Data Transformation | AWS Lambda, Amazon S3, CloudWatch Logs / Lambda, S3, CloudWatch Logs | Lambda, S3, CloudWatch Logs | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M07 – SQS, SNS, Retries und Dead-Letter Queues | Amazon SQS, Amazon SNS, AWS Lambda / SQS, SNS, Lambda | SQS, SNS, Lambda | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M08 – EventBridge, Scheduler und Pipes | Amazon EventBridge, EventBridge Scheduler, EventBridge Pipes / EventBridge, Scheduler, Pipes | EventBridge, Scheduler, Pipes | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M09 – Step Functions Orchestration | AWS Step Functions / Step Functions, Lambda, SQS, SNS | Step Functions, Lambda, SQS, SNS | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M10 – Data APIs mit API Gateway | Amazon API Gateway / API Gateway, Lambda, DynamoDB oder RDS | API Gateway, Lambda, DynamoDB oder RDS | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M11 – Kinesis Data Streams | Amazon Kinesis Data Streams / Kinesis | Kinesis | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M12 – Kinesis → Lambda → S3 | Kinesis Data Streams, Lambda, S3 / Kinesis, Lambda, S3, CloudWatch | Kinesis, Lambda, S3, CloudWatch | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M13 – Amazon Data Firehose | Amazon Data Firehose / Data Firehose | Data Firehose | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M14 – Amazon MSK / Kafka | Amazon Managed Streaming for Apache Kafka / MSK mit Redpanda Data Plane | MSK mit Redpanda Data Plane | Floci erzeugt Redpanda dynamisch | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M15 – Streaming Architecture Decision Lab | Streaming Architecture Decision Lab | Floci Core | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M16 – DynamoDB Access Patterns | Amazon DynamoDB / DynamoDB | DynamoDB | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M17 – DynamoDB Streams, TTL und Export to S3 | DynamoDB Streams, DynamoDB TTL, Export to S3 / DynamoDB Streams, Lambda, Kinesis, S3 | DynamoDB Streams, Lambda, Kinesis, S3 | keiner | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M18 – RDS PostgreSQL und relationale Modellierung | Amazon RDS for PostgreSQL / RDS mit echtem PostgreSQL-Container | RDS mit echtem PostgreSQL-Container | Floci erzeugt PostgreSQL dynamisch | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M19 – RDS Security, Secrets und Data API | Amazon RDS, AWS Secrets Manager, IAM Database Authentication / RDS, RDS Data API, Secrets Manager, IAM | RDS, RDS Data API, Secrets Manager, IAM | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M20 – Purpose-built Databases | Amazon DocumentDB, Amazon Neptune, Amazon MemoryDB for Redis, Amazon OpenSearch Service / DocumentDB, Neptune, MemoryDB/ElastiCache, OpenSearch | DocumentDB, Neptune, MemoryDB/ElastiCache, OpenSearch | Floci erzeugt DB-Container dynamisch | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M21 – Data Store Selection Workshop | Data Store Selection Workshop | Floci Core | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M22 – Spark und Glue ETL mit lokalem Ersatz | AWS Glue ETL / Glue Catalog | Glue Catalog | Spark Master + Worker | `spark` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M23 – EMR Control Plane | Amazon EMR / EMR Management API | EMR Management API | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M24 – AWS Batch, ECS und ECR | AWS Batch, Amazon ECS, Amazon ECR / AWS Batch, ECS, ECR | AWS Batch, ECS, ECR | Floci erzeugt ECS/Batch-Container | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M25 – EKS und Distributed Processing | Amazon EKS / EKS mit lokalem k3s-Modus, ECR | EKS mit lokalem k3s-Modus, ECR | Floci erzeugt k3s dynamisch | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M26 – IAM, STS und Least Privilege | AWS IAM, AWS STS / IAM, STS | IAM, STS | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M27 – KMS, Secrets Manager und Parameter Store | AWS KMS, AWS Secrets Manager, Systems Manager Parameter Store / KMS, Secrets Manager, SSM Parameter Store | KMS, Secrets Manager, SSM Parameter Store | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M28 – CloudWatch Monitoring und Alerting | Amazon CloudWatch / CloudWatch Metrics und Logs, SNS | CloudWatch Metrics und Logs, SNS | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M29 – CloudTrail, Config und Audit | AWS CloudTrail, AWS Config, CloudTrail Lake / CloudTrail, AWS Config, Athena/S3 | CloudTrail, AWS Config, Athena/S3 | keiner | `core` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M30 – Backup, Retention, Transfer und Recovery | AWS Backup, AWS Transfer Family, AWS DataSync, Snow Family / AWS Backup, Transfer Family, S3, RDS | AWS Backup, Transfer Family, S3, RDS | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M31 – Data Privacy und Governance | AWS Lake Formation, Amazon Macie, SageMaker Catalog | Floci Core | keiner | `core` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M32 – Infrastructure as Code | AWS CloudFormation, AWS SAM, AWS CDK / CloudFormation | CloudFormation | keiner | `tools` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M33 – CI/CD und Integration Testing | AWS CodeBuild, CodePipeline, CodeDeploy / CodeBuild, CodePipeline, CodeDeploy, Testcontainers | CodeBuild, CodePipeline, CodeDeploy, Testcontainers | keiner | `tools` | Teilweise Emulation; AWS-Grenzen im Reality-Check prüfen |
| M34 – Cost Explorer, CUR und Data Exports | AWS Cost Explorer, Cost and Usage Reports, AWS Data Exports / Pricing, Cost Explorer, CUR, BCM Data Exports | Pricing, Cost Explorer, CUR, BCM Data Exports | keiner | `core` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M35 – Performance- und Kostenoptimierung | Performance- und Kostenoptimierung | Floci Core | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M36 – Apache Iceberg und Open Table Formats | Apache Iceberg auf S3, Athena, Glue, EMR, Redshift, S3 Tables | Floci Core | Spark + Iceberg Runtime | `spark` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M37 – Vectors, HNSW, IVF und S3 Vectors | Amazon S3 Vectors, OpenSearch, Aurora PostgreSQL pgvector, MemoryDB / S3 Vectors, optional OpenSearch | S3 Vectors, optional OpenSearch | PostgreSQL + pgvector | `vector` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M38 – Bedrock, RAG und LLM Data Processing | Amazon Bedrock, Bedrock Knowledge Bases / Bedrock Runtime Stub | Bedrock Runtime Stub | deterministische lokale RAG-API | `rag` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M39 – SageMaker Unified Studio und Business Data Catalog | Amazon SageMaker Unified Studio, SageMaker Catalog | Floci Core | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M40 – Capstone: Batch Analytics Platform | Capstone: Batch Analytics Platform | Floci Core | Spark Master + Worker | `spark` | Lokaler Ersatz; kein identisches AWS Data Plane |
| M41 – Capstone: Streaming Operations Platform | Capstone: Streaming Operations Platform | Floci Core | Floci erzeugt Stream-/Runtime-Container | `core` | Lokales Data Plane; keine Aussage über AWS-Skalierung/Quotas |
| M42 – Incident Simulation und Architecture Defense | Incident Simulation und Architecture Defense | Floci Core | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
| M43 – Mock Exam und Final Readiness | Mock Exam und Final Readiness | Floci Core | keiner | `core` | Theorie/Entscheidung; optionaler Real-AWS-Abgleich |
