# Replikationsarchitektur für Mission 02

## 1. Ziel

Dieses Dokument beschreibt eine theoretische Replikationsarchitektur für Daten im Bucket `northstar-data-lake`.

Die Architektur soll bewerten, wie S3 Replication zur Verbesserung von Verfügbarkeit, Resilienz und organisatorischer Trennung eingesetzt werden kann.

## 2. Ausgangssituation

Der Quell-Bucket ist:

- Bucket: `northstar-data-lake`
- Umgebung: Floci als lokale AWS-Emulation
- AWS-Pendant: Amazon S3
- Versioning: aktiviert
- relevante Daten: `mission-02/versioning/`

Floci wird für die lokale Vorbereitung und Dokumentation verwendet. Eine reale Same-Region- oder Cross-Region-Replikation wird in dieser Mission nicht vollständig technisch nachgewiesen.

## 3. Zu schützende Risiken

Die Architektur soll insbesondere folgende Risiken betrachten:

1. Ausfall oder Nichtverfügbarkeit einer AWS-Region
2. versehentliche Änderung oder Überschreibung von Objekten
3. versehentliches Löschen von Objekten
4. kompromittierte Berechtigungen im Quellkonto
5. Bedarf an einer getrennten Kopie für Compliance oder Analyse
6. Wiederherstellung nach einem logischen oder betrieblichen Fehler

## 4. Zentrale Architekturfrage

Vor der Auswahl zwischen Same-Region Replication und Cross-Region Replication muss geklärt werden:

```text
Welche Fehlerdomäne soll durch die Replikation getrennt werden?
```

Eine Kopie in demselben Bucket wäre keine Replikationsarchitektur.

Eine Kopie in einem anderen Bucket derselben Region trennt den Bucket, aber nicht die Region.

Eine Kopie in einer anderen Region trennt zusätzlich die regionale Fehlerdomäne.

Eine Kopie in einem anderen AWS-Konto trennt zusätzlich die administrative und sicherheitsbezogene Fehlerdomäne.

## 5. Vergleich der Replikationsvarianten

| Kriterium | Same-Region Replication | Cross-Region Replication |
|---|---|---|
| Zielregion | gleiche AWS-Region | andere AWS-Region |
| Schutz vor Bucket-Fehlern | ja | ja |
| Schutz vor regionalem Ausfall | nein | ja |
| Latenz | in der Regel geringer | in der Regel höher |
| Datenübertragungskosten | meist geringer | zusätzliche regionsübergreifende Kosten |
| Typische Nutzung | getrennte Buckets, Analyse, Log-Aggregation | Disaster Recovery, Compliance, geografische Trennung |
| Zielkonto | gleiches oder anderes Konto | gleiches oder anderes Konto |

### 5.1 Same-Region Replication

Same-Region Replication eignet sich, wenn Daten in einen getrennten Bucket derselben Region kopiert werden sollen.

Typische Anwendungsfälle:

- getrennte Kopie für Analyse
- Aggregation von Logs
- Trennung verschiedener Teams oder Konten
- Schutz vor versehentlichen Änderungen am Quell-Bucket
- unterschiedliche Lifecycle-Regeln für Quelle und Ziel

Einschränkung:

Ein regionaler Ausfall betrifft grundsätzlich beide Buckets.

### 5.2 Cross-Region Replication

Cross-Region Replication eignet sich, wenn zusätzlich die regionale Fehlerdomäne getrennt werden soll.

Typische Anwendungsfälle:

- Disaster Recovery
- regulatorisch geforderte geografische Trennung
- Zugriff aus einer anderen Region
- Resilienz gegenüber regionalen Störungen

Nachteile:

- zusätzliche Datenübertragungskosten
- höhere Komplexität
- mögliche Replikationsverzögerung
- KMS- und IAM-Konfiguration wird anspruchsvoller

## 6. Empfohlene Zielarchitektur

Für kritische Daten wird folgende Zielarchitektur empfohlen:

```text
Quellkonto
└── Region eu-central-1
    └── Bucket northstar-data-lake
        └── Prefix mission-02/versioning/
                |
                | Cross-Region Replication
                v
Zielkonto
└── Region eu-west-1
    └── Bucket northstar-data-lake-replica
```

### 6.1 Architekturentscheidung

Die bevorzugte Variante ist:

- Cross-Region Replication
- Ziel-Bucket in einem separaten AWS-Konto
- Versioning auf Quell- und Ziel-Bucket aktiviert
- separate IAM-Rollen und Bucket Policies
- eigene Lifecycle-Regeln im Ziel-Bucket
- Verschlüsselung mit getrennten KMS-Schlüsseln
- Zugriff auf den Ziel-Bucket stark eingeschränkt

### 6.2 Begründung

Diese Architektur trennt mehrere Fehlerdomänen:

1. Bucket
2. AWS-Region
3. AWS-Konto
4. administrative Berechtigungen
5. Verschlüsselungsschlüssel

Dadurch ist die Zielkopie besser gegen Fehlkonfigurationen oder kompromittierte Berechtigungen im Quellkonto geschützt.

### 6.3 Erforderliche AWS-Komponenten

Für eine reale Umsetzung wären mindestens erforderlich:

- zwei S3-Buckets
- aktiviertes Versioning auf beiden Buckets
- S3 Replication Rule
- IAM Replication Role
- Bucket Policy im Zielkonto
- Berechtigungen für S3 und gegebenenfalls KMS
- CloudWatch-Metriken oder S3 Replication Metrics
- optional S3 Replication Time Control

### 6.4 Replikationsfilter

Die Replikation sollte nicht zwingend den gesamten Bucket erfassen.

Empfohlener Filter:

```text
Prefix: mission-02/versioning/
```

Alternativ kann eine tagbasierte Replikation verwendet werden, beispielsweise:

```text
replication=true
```

Dadurch können nur fachlich relevante oder besonders kritische Objekte repliziert werden.

## 7. Technische Voraussetzungen in AWS

Für S3 Replication müssen folgende Voraussetzungen erfüllt sein:

- Versioning ist auf Quell- und Ziel-Bucket aktiviert.
- Im Quell-Bucket ist eine Replication Rule konfiguriert.
- Amazon S3 darf Objekte und Versionen aus dem Quell-Bucket lesen.
- Amazon S3 darf Replikate in den Ziel-Bucket schreiben.
- Bei Cross-Account Replication erlaubt die Bucket Policy des Ziel-Buckets den Zugriff der Replikationsrolle.
- Bei SSE-KMS-verschlüsselten Objekten bestehen passende KMS-Berechtigungen für Quelle und Ziel.
- Die Zielregion und das Zielkonto entsprechen den definierten Compliance- und Resilienzanforderungen.

Eine Replikationsregel sollte mindestens enthalten:

- eindeutige Rule ID
- Status `Enabled`
- Priorität
- Filter nach Prefix oder Tag
- Ziel-Bucket-ARN
- IAM-Rolle
- gewünschte Storage Class im Ziel
- Entscheidung über Delete Marker Replication
- optional Replication Metrics
- optional S3 Replication Time Control

## 8. Verhalten bestehender und neuer Objekte

### 8.1 Neue Objekte

Live Replication verarbeitet Objekte, die nach Aktivierung der Replication Rule neu erstellt oder geändert werden.

Neue Versionen eines bereits vorhandenen Keys werden ebenfalls als neue Objektversionen betrachtet und können repliziert werden.

### 8.2 Bereits vorhandene Objekte

Objekte, die bereits vor Aktivierung der Live-Replikation vorhanden waren, werden nicht automatisch rückwirkend repliziert.

Für bestehende Objekte ist S3 Batch Replication erforderlich.

Daraus folgt:

```text
Live Replication
→ neue oder geänderte Objektversionen

S3 Batch Replication
→ bereits vorhandene oder erneut zu verarbeitende Objekte
```

### 8.3 Fehlgeschlagene Replikationen

Objekte mit fehlgeschlagenem Replikationsstatus werden nicht allein durch späteres Korrigieren der Konfiguration automatisch erneut repliziert.

Mögliche Maßnahmen:

- Objekt erneut hochladen
- neue Objektversion erzeugen
- S3 Batch Replication verwenden

## 9. Delete Marker und permanente Löschung

Das Verhalten von Löschungen muss explizit festgelegt werden.

### 9.1 DeleteObject ohne VersionId

Bei aktiviertem Versioning entsteht im Quell-Bucket ein Delete Marker.

Ob dieser Delete Marker repliziert wird, hängt von der Replication Rule und der Einstellung `DeleteMarkerReplication` ab.

### 9.2 DeleteObject mit VersionId

Wird eine konkrete Datenversion über ihre `VersionId` dauerhaft gelöscht, wird diese Löschoperation nicht als gewöhnlicher Delete Marker behandelt.

Eine dauerhaft gelöschte Quellversion darf nicht automatisch als wiederherstellbar angenommen werden.

### 9.3 Lifecycle-Löschungen

Delete Marker, die durch S3 Lifecycle erzeugt werden, werden nicht wie benutzerinitiierte Delete Marker behandelt und nicht automatisch als normaler Löschvorgang repliziert.

Daraus folgt:

```text
Replikation von Daten
≠
identische Replikation jeder Löschoperation
```

## 10. Warum Replikation kein vollständiges Backup ist

S3 Replication verbessert Redundanz und Verfügbarkeit, ersetzt jedoch keine vollständige Backup-Strategie.

Gründe:

1. Fehlerhafte neue Versionen können ebenfalls repliziert werden.
2. Fehlkonfigurationen können Quelle und Ziel gleichzeitig betreffen.
3. Berechtigungen können in beiden Umgebungen kompromittiert sein.
4. Replikationsverzögerungen erzeugen ein Zeitfenster ohne Zielkopie.
5. Bestehende Objekte werden ohne Batch Replication nicht rückwirkend kopiert.
6. Lifecycle-Regeln im Ziel können Replikate löschen.
7. Replikation garantiert nicht automatisch Unveränderbarkeit.
8. Ein Ziel im selben Konto kann dieselbe administrative Fehlerdomäne teilen.

Für eine belastbarere Backup-Strategie sind zusätzlich zu prüfen:

- separates AWS-Konto
- eingeschränkte Administratorrechte
- S3 Object Lock
- getrennte KMS-Schlüssel
- längere Retention im Ziel
- AWS Backup oder externe Sicherung
- regelmäßige Restore-Tests

## 11. RPO und RTO

### 11.1 Recovery Point Objective

Das RPO beschreibt den maximal tolerierbaren Datenverlust.

Bei asynchroner S3 Replication kann zwischen dem Schreiben im Quell-Bucket und der erfolgreichen Replikation eine Verzögerung bestehen.

Für die Zielarchitektur gilt:

```text
Ziel-RPO: maximal 15 Minuten
```

Für geschäftskritische Daten sollte S3 Replication Time Control geprüft werden.

S3 RTC bietet einen definierten Replikationszeitrahmen für den überwiegenden Teil neuer Objekte und stellt Metriken sowie Ereignisse für Überschreitungen bereit.

Ohne S3 RTC kann kein festes 15-Minuten-RPO allein aus der Standardreplikation abgeleitet werden.

### 11.2 Recovery Time Objective

Das RTO beschreibt, wie schnell Daten aus dem Ziel-Bucket wieder nutzbar sein müssen.

Für die Zielarchitektur gilt:

```text
Ziel-RTO: maximal 30 Minuten
```

Darin enthalten sind:

1. Ausfall erkennen
2. Replikationsstatus prüfen
3. Zielobjekt verifizieren
4. Zugriff oder Pipeline auf das Ziel umstellen
5. fachliche Datenprüfung durchführen
6. Betrieb wieder aufnehmen

Das tatsächliche RTO hängt zusätzlich ab von:

- Anzahl der betroffenen Objekte
- Objektgröße
- Automatisierungsgrad
- IAM- und KMS-Berechtigungen
- Umschaltmechanismus der Datenpipeline
- verwendeter Storage Class
- erforderlichen Freigabeprozessen

## 12. Monitoring und Betrieb

Eine produktive Replikationsarchitektur benötigt Überwachung.

Zu überwachen sind insbesondere:

- ausstehende Replikationsbytes
- ausstehende Replikationsoperationen
- maximale Replikationslatenz
- fehlgeschlagene Replikationsoperationen
- Objekte mit Status `FAILED`
- Überschreitung des S3-RTC-Zeitfensters
- IAM- oder KMS-Fehler
- Änderungen an Replication Rules
- Änderungen an Bucket Policies

Empfohlene Komponenten:

- S3 Replication Metrics
- Amazon CloudWatch
- Amazon EventBridge oder S3 Event Notifications
- AWS CloudTrail
- Alarmierung bei fehlgeschlagenen oder verspäteten Replikationen

Ein erfolgreicher Upload in den Quell-Bucket beweist nicht, dass die Zielkopie bereits vorhanden ist.

Die Replikation muss über Status, Metriken oder einen gezielten Abruf im Ziel-Bucket verifiziert werden.

## 13. Typische Fehlerbilder

### 13.1 Versioning im Ziel nicht aktiviert

Folge:

- Die Replication Rule kann nicht korrekt betrieben werden.

### 13.2 IAM-Rolle unvollständig

Folge:

- Objekte erhalten den Replikationsstatus `FAILED`.

### 13.3 Fehlende KMS-Berechtigungen

Folge:

- SSE-KMS-verschlüsselte Objekte können nicht entschlüsselt oder im Ziel verschlüsselt werden.

### 13.4 Ziel-Bucket-Policy blockiert Quellkonto

Folge:

- Cross-Account Replication schlägt fehl.

### 13.5 Falscher Prefix-Filter

Folge:

- Erwartete Objekte werden nicht repliziert.

### 13.6 Bestehende Objekte werden erwartet

Folge:

- Objekte vor Aktivierung der Regel fehlen im Ziel.

Maßnahme:

- S3 Batch Replication verwenden.

### 13.7 Lifecycle-Regel im Ziel löscht Replikate

Folge:

- Die Zielkopie ist früher als geplant nicht mehr verfügbar.

Maßnahme:

- Lifecycle und Retention im Ziel unabhängig von der Quelle prüfen.

## 14. Sicherheits- und Compliance-Aspekte

Für eine robuste Cross-Account-Architektur gelten folgende Prinzipien:

- Least Privilege für die Replication Role
- kein allgemeiner Schreibzugriff auf den Ziel-Bucket
- eingeschränkter menschlicher Zugriff auf Replikate
- getrennte KMS-Schlüssel
- Logging von administrativen Änderungen
- Schutz der Ziel-Bucket-Policy
- optional S3 Object Lock
- getrennte Lifecycle- und Retention-Regeln
- regelmäßige Berechtigungsreviews
- dokumentierte Break-Glass-Prozedur

Das Zielkonto sollte nicht dieselben operativen Administratoren und Automationen wie das Quellkonto verwenden, sofern eine echte administrative Trennung verlangt wird.

## 15. Architekturentscheidung

Für die in Mission 02 betrachteten kritischen Daten wird folgende Variante gewählt:

```text
Cross-Region Replication
+ separates AWS-Konto
+ Versioning auf beiden Buckets
+ eingeschränkte Replication Role
+ getrennte KMS-Schlüssel
+ unabhängige Lifecycle-Regeln
+ Replication Metrics
+ optional S3 Replication Time Control
```

### Begründung

Diese Variante trennt:

- Bucket-Fehlerdomäne
- regionale Fehlerdomäne
- administrative Fehlerdomäne
- Verschlüsselungsdomäne

Sie ist komplexer und teurer als Same-Region Replication, bietet aber eine stärkere Resilienz gegenüber regionalen und administrativen Fehlern.

## 16. Abgrenzung der lokalen Emulation

In Floci wird in dieser Mission nur die Architektur theoretisch geplant.

Nicht lokal nachgewiesen werden:

- reale Cross-Region-Datenübertragung
- Cross-Account-Bucket-Policies
- produktive IAM-Rollenübernahme
- KMS-Schlüssel in mehreren Regionen oder Konten
- Replication Metrics
- S3 Replication Time Control
- reale Replikationslatenz
- reale Datenübertragungskosten
- Verhalten bei regionalen AWS-Störungen

Diese Punkte müssen vor einer produktiven Nutzung in einem kontrollierten AWS-Test validiert werden.

## 17. DEA-C01 Exam Transfer

Für das Exam sind insbesondere folgende Aussagen relevant:

1. SRR repliziert zwischen Buckets derselben Region.
2. CRR repliziert zwischen Buckets unterschiedlicher Regionen.
3. Versioning muss auf Quell- und Ziel-Bucket aktiviert sein.
4. Live Replication verarbeitet nicht automatisch alle bestehenden Objekte.
5. Bestehende Objekte können mit S3 Batch Replication verarbeitet werden.
6. Cross-Account Replication benötigt zusätzliche Berechtigungen im Zielkonto.
7. SSE-KMS-Replikation benötigt explizite KMS-Berechtigungen.
8. Delete Marker Replication muss bewusst konfiguriert werden.
9. Replikation ist asynchron.
10. Replikation ist kein vollständiger Backup-Ersatz.
11. S3 RTC ist relevant, wenn ein vorhersehbarer Replikationszeitrahmen verlangt wird.
12. Monitoring ist notwendig, weil ein erfolgreicher Quell-Upload keine erfolgreiche Zielreplikation beweist.

## 18. Abschlusskriterien

Der Meilenstein gilt als abgeschlossen, wenn:

- SRR und CRR verglichen wurden,
- die zu trennenden Fehlerdomänen dokumentiert sind,
- eine Zielregion und ein Zielkonto definiert wurden,
- Versioning als Voraussetzung berücksichtigt wurde,
- IAM- und KMS-Anforderungen beschrieben wurden,
- bestehende Objekte und Batch Replication behandelt wurden,
- Delete Marker und Lifecycle-Verhalten eingeordnet wurden,
- RPO und RTO definiert wurden,
- Monitoring und Fehlerbilder beschrieben wurden,
- Replikation klar von Backup abgegrenzt wurde,
- die Grenzen der lokalen Emulation dokumentiert wurden.
