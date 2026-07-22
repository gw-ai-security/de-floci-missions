# S3 Backup- und Restore-Runbook

## 1. Zweck und Geltungsbereich

Dieses Runbook beschreibt die Wiederherstellung eines versionierten Objekts im lokalen Floci-S3-Service und überträgt das Vorgehen auf Amazon S3.

Es behandelt zwei Recovery-Fälle:

1. Ein Objekt wurde versehentlich gelöscht und durch einen Delete Marker verdeckt.
2. Eine fehlerhafte aktuelle Objektversion soll durch den Inhalt einer älteren Version ersetzt werden.

> **Abgrenzung:** S3 Versioning ist ein Recovery-Mechanismus, aber allein keine vollständige Backup-Strategie. Ein separates Backup sollte einen unabhängigen Schutzbereich besitzen, beispielsweise ein anderes AWS-Konto, eine getrennte Region, eigene Berechtigungen oder unveränderbare Aufbewahrung.

## 2. Testumgebung

| Element | Wert |
|---|---|
| Lokale Emulation | Floci |
| AWS-Pendant | Amazon S3 |
| Bucket | `northstar-data-lake` |
| Beispiel-Key | `mission-02/versioning/orders.csv` |
| Voraussetzung | Bucket-Versioning ist aktiviert |

Die Befehle werden aus dem Stammverzeichnis des Repositorys ausgeführt.

## 3. Voraussetzungen

- Floci und die Core-Container laufen.
- Der Bucket `northstar-data-lake` existiert.
- S3 Versioning ist für den Bucket aktiviert.
- Für den betroffenen Object Key existieren frühere Versionen.
- `awslocal` ist im Floci-Container verfügbar.
- Bucket, Object Key, Incident-Zeitpunkt und gewünschter Recovery-Zustand sind bekannt.
- Die ausführende Person besitzt die erforderlichen Lese-, Schreib- und Löschberechtigungen.

## 4. Recovery-Fall bestimmen

### Fall A: Objekt wurde versehentlich gelöscht

Merkmale:

- Ein normales `GetObject` liefert `NoSuchKey`.
- `list-object-versions` zeigt einen aktuellen Delete Marker.
- Frühere Datenversionen sind weiterhin vorhanden.

Maßnahme:

- Den aktuellen Delete Marker gezielt über seine `VersionId` löschen.
- Keine Datenversion erneut hochladen.

Ergebnis:

- Die vorherige Datenversion wird wieder sichtbar.
- Es entsteht keine neue Datenversion.

### Fall B: Falscher Inhalt wurde unter demselben Key gespeichert

Merkmale:

- Ein normales `GetObject` funktioniert.
- Die aktuelle Datenversion enthält falsche oder unerwünschte Daten.
- Eine korrekte ältere Version ist weiterhin vorhanden.

Maßnahme:

- Die gewünschte ältere Version über ihre `VersionId` herunterladen.
- Den geprüften Inhalt erneut unter demselben Object Key hochladen.

Ergebnis:

- Es entsteht eine neue aktuelle Datenversion.
- Die bestehende Versionshistorie bleibt erhalten.

### Entscheidungstabelle

| Beobachtung | Recovery-Methode |
|---|---|
| Aktueller Delete Marker vorhanden | Delete Marker gezielt löschen |
| Aktuelle Datenversion ist fehlerhaft | Ältere Version lesen, prüfen und erneut hochladen |
| Gewünschte `VersionId` unbekannt | Versionshistorie zuerst auflisten |
| Keine frühere Version vorhanden | Wiederherstellung über Versioning nicht möglich |

## 5. Variablen festlegen

Die Recovery-Befehle verwenden Variablen, damit keine Version ID versehentlich fest codiert oder wiederverwendet wird.

```powershell
$Bucket = "northstar-data-lake"
$Key = "mission-02/versioning/orders.csv"
```

Die konkrete Version ID wird erst nach der Diagnose gesetzt:

```powershell
$TargetVersionId = "HIER-GEPRUEFTE-VERSION-ID-EINTRAGEN"
```

## 6. Diagnose vor der Wiederherstellung

### 6.1 Core-Umgebung prüfen

```powershell
.\scripts\verify-core.ps1 -SkipRestart
```

### 6.2 Bucket-Versioning prüfen

```powershell
docker compose exec floci awslocal s3api get-bucket-versioning `
  --bucket $Bucket
```

Erwartete Antwort:

```json
{
  "Status": "Enabled"
}
```

### 6.3 Versionshistorie auflisten

```powershell
docker compose exec floci awslocal s3api list-object-versions `
  --bucket $Bucket `
  --prefix $Key
```

Zu prüfen sind:

- `VersionId`
- `IsLatest`
- `LastModified`
- `ETag`
- `Size`
- `StorageClass`
- vorhandene `DeleteMarkers`

### 6.4 Aktuellen Objektzustand prüfen

```powershell
docker compose exec floci awslocal s3api get-object `
  --bucket $Bucket `
  --key $Key `
  /tmp/orders-diagnostic.csv
```

Interpretation:

- Erfolgreicher Abruf: Eine Datenversion ist aktuell sichtbar.
- `NoSuchKey`: Häufig ist ein Delete Marker aktuell.
- In beiden Fällen muss zusätzlich die Versionshistorie geprüft werden.

### 6.5 Zielversion fachlich identifizieren

Die Zielversion darf nicht allein anhand ihrer Position in der Ausgabe ausgewählt werden.

Zu prüfen sind:

- fachlich korrekter Inhalt
- `LastModified`
- `VersionId`
- Dateigröße
- `ETag`
- Incident- und Pipeline-Zeitpunkt
- erwartete Datensätze und Statuswerte

## 7. Recovery-Fall A: Delete Marker entfernen

### 7.1 Delete Marker identifizieren

```powershell
docker compose exec floci awslocal s3api list-object-versions `
  --bucket $Bucket `
  --prefix $Key
```

Unter `DeleteMarkers` muss der Eintrag mit `IsLatest: true` identifiziert werden.

```powershell
$DeleteMarkerVersionId = "HIER-GEPRUEFTE-DELETE-MARKER-ID-EINTRAGEN"
```

### 7.2 Delete Marker gezielt löschen

```powershell
docker compose exec floci awslocal s3api delete-object `
  --bucket $Bucket `
  --key $Key `
  --version-id $DeleteMarkerVersionId
```

Wichtig:

- Die Version ID muss zum Delete Marker gehören.
- Ohne `--version-id` würde ein weiterer Delete Marker erzeugt.
- Die Version ID einer Datenversion darf hier nicht verwendet werden, da diese Version sonst dauerhaft gelöscht wird.

### 7.3 Undelete prüfen

```powershell
docker compose exec floci awslocal s3api get-object `
  --bucket $Bucket `
  --key $Key `
  /tmp/orders-after-undelete.csv
```

```powershell
docker compose exec floci cat /tmp/orders-after-undelete.csv
```

Erwartetes Ergebnis:

- Das Objekt ist wieder ohne `VersionId` abrufbar.
- Die vorherige Datenversion ist wieder aktuell sichtbar.
- Es wurde keine neue Datenversion erzeugt.

## 8. Recovery-Fall B: Ältere Version wiederherstellen

### 8.1 Zielversion herunterladen

```powershell
$TargetVersionId = "HIER-GEPRUEFTE-VERSION-ID-EINTRAGEN"
```

```powershell
docker compose exec floci awslocal s3api get-object `
  --bucket $Bucket `
  --key $Key `
  --version-id $TargetVersionId `
  /tmp/orders-restore-source.csv
```

### 8.2 Inhalt kontrollieren

```powershell
docker compose exec floci cat /tmp/orders-restore-source.csv
```

Der Inhalt muss vor dem Upload dem gewünschten Recovery-Zustand entsprechen.

### 8.3 Inhalt erneut unter demselben Key hochladen

```powershell
docker compose exec floci awslocal s3api put-object `
  --bucket $Bucket `
  --key $Key `
  --body /tmp/orders-restore-source.csv
```

Erwartetes Ergebnis:

- Eine neue `VersionId` wird erzeugt.
- Die neue Version erhält `IsLatest: true`.
- Die ursprüngliche ältere Version bleibt erhalten.
- Die fehlerhafte Version bleibt für Analyse und Audit in der Historie erhalten.

### 8.4 Restore prüfen

```powershell
docker compose exec floci awslocal s3api list-object-versions `
  --bucket $Bucket `
  --prefix $Key
```

```powershell
docker compose exec floci awslocal s3api get-object `
  --bucket $Bucket `
  --key $Key `
  /tmp/orders-after-restore.csv
```

```powershell
docker compose exec floci cat /tmp/orders-after-restore.csv
```

Ein Restore setzt eine ältere Version nicht direkt auf `IsLatest: true`:

```text
ältere Version lesen
→ Inhalt prüfen
→ Inhalt erneut hochladen
→ neue aktuelle Version erzeugen
```

## 9. Verifikation und Abschlusskriterien

Eine Wiederherstellung gilt erst dann als erfolgreich, wenn technische und fachliche Prüfungen bestanden sind.

### 9.1 Technische Verifikation

- Das Objekt ist ohne Angabe einer `VersionId` abrufbar.
- Der Abruf liefert keinen unerwarteten `NoSuchKey`-Fehler.
- Die Versionshistorie enthält genau den erwarteten aktuellen Zustand.
- Es existiert kein unbeabsichtigter zusätzlicher Delete Marker.
- Keine benötigte Datenversion wurde gelöscht.

### 9.2 Inhaltsprüfung

Zu prüfen sind:

- erwartete Datensätze
- erwartete Spalten
- erwartete Statuswerte
- vollständiger Dateiinhalt
- Zeichencodierung, insbesondere ein mögliches UTF-8 BOM
- Lesbarkeit durch nachgelagerte Prozesse

### 9.3 Metadatenprüfung

Für die aktuelle Version sind mindestens zu prüfen:

- `VersionId`
- `ETag`
- `Size`
- `LastModified`
- `StorageClass`

> Bei kleinen Single-Part-Uploads kann eine identische ETag auf identischen Inhalt hinweisen. ETags sind jedoch nicht allgemein als universeller Integritäts-Hash zu behandeln, insbesondere nicht bei Multipart-Uploads oder bestimmten Verschlüsselungsszenarien.

### 9.4 Abschlusskriterien

Der Recovery-Vorgang ist abgeschlossen, wenn:

1. das Objekt wieder erreichbar ist,
2. der Inhalt fachlich korrekt ist,
3. die erwartete Version aktuell sichtbar ist,
4. die Versionshistorie konsistent geblieben ist,
5. keine benötigte Version gelöscht wurde,
6. Bucket, Key und verwendete Version IDs dokumentiert wurden,
7. nachgelagerte Prozesse erfolgreich validiert wurden.

## 10. RPO und RTO

### 10.1 Recovery Point Objective

Das Recovery Point Objective definiert den maximal tolerierbaren Datenverlust, gemessen als Zeitspanne zwischen dem letzten noch nutzbaren Recovery-Punkt und dem Incident.

Für diesen Lernfall gilt:

- Wiederherstellbar ist jede noch vorhandene und fachlich korrekte Objektversion.
- Der tatsächliche Recovery-Punkt hängt vom Zeitpunkt der zuletzt korrekten Version ab.
- Dauerhaft gelöschte Versionen können durch Versioning nicht wiederhergestellt werden.
- Lifecycle-Regeln können ältere Recovery-Punkte entfernen.

Beispiel:

```text
Letzte korrekte Version: 13:03 Uhr
Fehlerhafte Version:     13:10 Uhr
Incident erkannt:        13:20 Uhr

Tatsächlicher Recovery-Punkt: 13:03 Uhr
Entstehender Datenverlust: Änderungen zwischen 13:03 und 13:10 Uhr
```

Ein akzeptables RPO muss durch den fachlichen Eigentümer der Daten festgelegt werden; es ergibt sich nicht automatisch aus aktiviertem Versioning.

### 10.2 Recovery Time Objective

Das Recovery Time Objective definiert die maximal akzeptable Dauer bis zur Wiederherstellung des Betriebs.

Lokales Übungsziel:

```text
RTO: maximal 15 Minuten
```

Darin enthalten sind:

1. Incident erkennen,
2. Versionshistorie analysieren,
3. korrekte Version auswählen,
4. Undelete oder Restore durchführen,
5. Inhalt und Versionshistorie verifizieren.

In AWS hängt das tatsächliche RTO zusätzlich ab von:

- Berechtigungen und Freigabeprozessen
- Objektgröße und Anzahl betroffener Objekte
- Storage Class und erforderlichem Restore-Prozess
- Automatisierungsgrad
- nachgelagerten Datenpipelines
- Cross-Account- oder Cross-Region-Abhängigkeiten

## 11. Risiken und Schutzmaßnahmen

### 11.1 Falsche Version auswählen

**Risiko:** Eine technisch gültige, aber fachlich falsche Version wird wiederhergestellt.

**Schutzmaßnahme:** Inhalt, Zeitstempel, Version ID, Größe und Incident-Zeitpunkt vor dem Restore prüfen.

### 11.2 Datenversion dauerhaft löschen

**Risiko:** `DeleteObject` wird mit der Version ID einer Datenversion statt eines Delete Markers ausgeführt.

**Folge:** Die konkrete Datenversion wird dauerhaft entfernt.

**Schutzmaßnahme:** Vor jedem Löschbefehl prüfen, ob die Version ID unter `DeleteMarkers` oder `Versions` aufgeführt ist.

### 11.3 Weiteren Delete Marker erzeugen

**Risiko:** Ein Delete Marker soll entfernt werden, aber `DeleteObject` wird ohne `--version-id` ausgeführt.

**Folge:** Ein weiterer Delete Marker wird erzeugt.

**Schutzmaßnahme:** Beim Undelete immer die konkrete Version ID des Delete Markers verwenden.

### 11.4 Ungeeignete Lifecycle-Regel

**Risiko:** Nicht aktuelle Versionen werden zu früh dauerhaft gelöscht.

**Folge:** Der gewünschte Recovery-Punkt ist nicht mehr vorhanden.

**Schutzmaßnahme:** Lifecycle-Regeln vor Aktivierung prüfen, Präfixe begrenzen und aktuelle sowie nicht aktuelle Versionen getrennt behandeln.

### 11.5 Gemeinsame administrative Fehlerdomäne

**Risiko:** Angreifer oder fehlerhafte Automation können sowohl aktuelle als auch ältere Versionen löschen.

**Schutzmaßnahme:** Für kritische Daten getrennte Konten, restriktive IAM-Rollen, MFA Delete, Object Lock oder unabhängige Backups prüfen.

## 12. Rollback eines fehlerhaften Restores

Falls nach einem Restore festgestellt wird, dass die falsche Version verwendet wurde:

1. Versionshistorie erneut auflisten.
2. Die zuvor korrekte Version identifizieren.
3. Diese Version gezielt herunterladen.
4. Den Inhalt fachlich prüfen.
5. Den Inhalt erneut unter demselben Key hochladen.
6. Neue aktuelle Version und Inhalt verifizieren.

Auch ein Rollback erzeugt eine weitere Objektversion:

```text
fehlerhafter Restore
→ vorherige korrekte Version lesen
→ erneut hochladen
→ neue aktuelle Rollback-Version
```

Vorhandene Versionen sollten nicht vorschnell gelöscht werden, da sie für Incident-Analyse und Audit relevant sein können.

## 13. Abgrenzung der lokalen Emulation

In Floci wurden folgende Eigenschaften praktisch nachgewiesen:

- Aktivierung von Versioning
- Erzeugung mehrerer Objektversionen
- gezielter Abruf über `VersionId`
- Restore durch erneuten Upload
- Erzeugung und Entfernung eines Delete Markers

Nicht vollständig durch die lokale Emulation nachgewiesen sind:

- reale AWS-Dauerhaftigkeit und Verfügbarkeit
- produktive IAM- und KMS-Kontrollen
- MFA Delete
- Cross-Region- und Cross-Account-Replikation
- reale Glacier-Retrieval-Zeiten
- vollständige Object-Lock-Compliance
- reale Kosten nicht aktueller Versionen

Diese Eigenschaften müssen für produktive Architekturen separat in AWS validiert werden.

## 14. DEA-C01 Exam Transfer

- `DeleteObject` ohne Version ID erzeugt bei aktiviertem Versioning einen Delete Marker.
- Das Löschen des aktuellen Delete Markers macht die vorherige Datenversion wieder sichtbar.
- `DeleteObject` mit der Version ID einer Datenversion löscht diese konkrete Version dauerhaft.
- Ein Restore einer älteren Version erfolgt durch erneutes Schreiben ihres Inhalts und erzeugt eine neue aktuelle Version.
- Nicht aktuelle Versionen bleiben gespeichert und verursachen Kosten.
- Lifecycle-Regeln behandeln aktuelle und nicht aktuelle Versionen getrennt.
- Versioning, Replication und Backup lösen unterschiedliche Schutzanforderungen.
- One Zone-IA ist nicht für Workloads geeignet, die Multi-AZ-Resilienz benötigen.
- Archivklassen beeinflussen Kosten und Wiederherstellungszeit und damit das erreichbare RTO.
