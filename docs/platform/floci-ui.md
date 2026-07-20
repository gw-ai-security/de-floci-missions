# Floci UI und Mission Control

## Mission Control – Port 3000

Die projektspezifische Lern-UI liest den unveränderten Missionenplan bei jedem Start. Aufgaben, Deliverables, Pflichtanforderungen, Abnahmen, Incidents und Readiness-Kriterien werden als Meilensteine geführt. Filter, Suche, Gesamtfortschritt und Missionsstatus werden aus dem lokal gespeicherten Hakenstatus berechnet.

## Offizielle Floci UI – Port 4500

Das offizielle Image `floci/floci-ui:0.2.0` zeigt reale Daten des Floci-Core-Endpunkts. Mock-Modus ist deaktiviert. Aktuell sind insbesondere S3 Storage, EKS, RDS, EC2/Networking, Lambda-Flows und Secrets Manager sichtbar; mehrere andere Bereiche sind laut offiziellem UI-README noch Platzhalter oder nicht in der Navigation verdrahtet.

UI-Abdeckung ist daher nicht gleich Floci-Serviceabdeckung. Für Glue, Athena, Kinesis, Step Functions, EventBridge, MSK und viele Security-/Operations-Aufgaben bleiben AWS CLI, SDK und IaC die verlässliche Lernoberfläche.

Offizielle Quelle: https://github.com/floci-io/floci-ui
