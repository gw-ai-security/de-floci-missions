import json
from datetime import datetime, timezone

import boto3
from botocore.exceptions import ClientError


# ---------------------------------------------------------
# 1. Verbindung zu Floci S3 herstellen
# ---------------------------------------------------------

s3 = boto3.client(
    "s3",
    endpoint_url="http://localhost:4566",
    region_name="eu-central-1",
    aws_access_key_id="test",
    aws_secret_access_key="test",
)


# ---------------------------------------------------------
# 2. Bucket, Quellobjekt und Manifest konfigurieren
# ---------------------------------------------------------

bucket = "northstar-data-lake"

source_key = (
    "raw/orders/ingestion_date=2026-07-19/"
    "orders_20260719T094506Z.csv"
)

manifest_key = (
    "manifests/orders/"
    "orders_20260719T094506Z.json"
)


# ---------------------------------------------------------
# 3. Metadaten des Quellobjekts lesen
#
# HeadObject lädt nicht den Dateiinhalt herunter.
# Es wird zunächst geprüft, ob das Objekt existiert.
# Anschließend werden ETag und Objektgröße ausgelesen.
# ---------------------------------------------------------

try:
    source_response = s3.head_object(
        Bucket=bucket,
        Key=source_key,
    )

except ClientError as error:
    error_code = error.response["Error"]["Code"]

    if error_code in ("404", "NoSuchKey", "NotFound"):
        raise FileNotFoundError(
            f"Source object not found: "
            f"s3://{bucket}/{source_key}"
        ) from error

    # Andere Fehler, beispielsweise AccessDenied,
    # dürfen nicht als fehlendes Objekt interpretiert werden.
    raise


current_etag = source_response["ETag"].strip('"')
current_size = source_response["ContentLength"]

print("Current ETag:", current_etag)
print("Current size:", current_size)


# ---------------------------------------------------------
# 4. Bestehendes Manifest lesen
#
# Das Manifest enthält den ETag des zuletzt erfolgreich
# verarbeiteten Quellobjekts.
#
# Existiert noch kein Manifest, wird stored_etag auf None
# gesetzt. Das Quellobjekt muss dann verarbeitet werden.
# ---------------------------------------------------------

try:
    manifest_response = s3.get_object(
        Bucket=bucket,
        Key=manifest_key,
    )

    manifest_content = (
        manifest_response["Body"]
        .read()
        .decode("utf-8-sig")
    )

    manifest = json.loads(manifest_content)
    stored_etag = manifest["etag"]

    print("Stored ETag:", stored_etag)

except ClientError as error:
    error_code = error.response["Error"]["Code"]

    if error_code in ("404", "NoSuchKey", "NotFound"):
        stored_etag = None
        print("Manifest not found")

    else:
        # Berechtigungs-, Verbindungs- oder andere Fehler
        # dürfen nicht wie ein fehlendes Manifest behandelt werden.
        raise


# ---------------------------------------------------------
# 5. Idempotenzentscheidung treffen
#
# Gleicher ETag:
# Das Quellobjekt wurde bereits erfolgreich verarbeitet.
#
# Unterschiedlicher ETag:
# Das Objekt ist neu oder sein Inhalt wurde verändert.
# ---------------------------------------------------------

if current_etag == stored_etag:
    print("Decision: SKIP")
    print("Reason: Source object was already processed")

else:
    print("Decision: PROCESS")
    print("Reason: Source object is new or changed")


    # -----------------------------------------------------
    # 6. Quellobjekt vollständig herunterladen
    #
    # GetObject liefert den tatsächlichen Dateiinhalt.
    # Erst jetzt beginnt die eigentliche Verarbeitung.
    # -----------------------------------------------------

    print("Processing source object...")

    object_response = s3.get_object(
        Bucket=bucket,
        Key=source_key,
    )

    source_bytes = object_response["Body"].read()


    # -----------------------------------------------------
    # 7. Technisch leere Datei ablehnen
    #
    # Ein Objekt mit 0 Bytes ist keine gültige Eingabedatei.
    # Durch die Exception wird das Manifest nicht aktualisiert.
    # -----------------------------------------------------

    if len(source_bytes) == 0:
        raise ValueError(
            "Source object is empty. "
            "Manifest will not be updated."
        )


    # -----------------------------------------------------
    # 8. Dateiinhalt als UTF-8 dekodieren
    #
    # utf-8-sig verarbeitet sowohl normales UTF-8 als auch
    # Dateien mit einem UTF-8 Byte Order Mark.
    #
    # Ein Decode-Fehler bricht die Verarbeitung ab, bevor
    # das Manifest aktualisiert werden kann.
    # -----------------------------------------------------

    source_content = source_bytes.decode("utf-8-sig")

    if not source_content.strip():
        raise ValueError(
            "Source object contains no usable data. "
            "Manifest will not be updated."
        )

    print("Source file loaded successfully")
    print("Downloaded bytes:", len(source_bytes))


    # -----------------------------------------------------
    # 9. CSV-Inhalt minimal validieren
    #
    # Die erste Zeile wird als Header interpretiert.
    # Mindestens eine weitere Zeile muss als Datensatz
    # vorhanden sein.
    # -----------------------------------------------------

    lines = source_content.splitlines()

    if len(lines) < 2:
        raise ValueError(
            "Source file contains no data rows. "
            "Manifest will not be updated."
        )

    header = lines[0]
    data_row_count = len(lines) - 1

    print("CSV header:", header)
    print("Data rows:", data_row_count)


    # -----------------------------------------------------
    # 10. Neues Manifest vorbereiten
    #
    # Dieser Abschnitt wird nur erreicht, wenn:
    #
    # - das Objekt existiert,
    # - es nicht leer ist,
    # - es erfolgreich dekodiert wurde,
    # - mindestens eine Datenzeile vorhanden ist.
    # -----------------------------------------------------

    updated_manifest = {
        "bucket": bucket,
        "object_key": source_key,
        "etag": current_etag,
        "size_bytes": current_size,
        "record_count": data_row_count,
        "processed_at": datetime.now(
            timezone.utc
        ).isoformat(),
        "status": "INGESTED",
    }

    manifest_body = json.dumps(
        updated_manifest,
        indent=2,
    ).encode("utf-8")


    # -----------------------------------------------------
    # 11. Manifest erst nach erfolgreicher Verarbeitung
    #     aktualisieren
    #
    # Dieses Vorgehen folgt dem Commit-after-success-Muster.
    # Bei jeder vorherigen Exception wird dieser PutObject-
    # Aufruf nicht ausgeführt.
    # -----------------------------------------------------

    s3.put_object(
        Bucket=bucket,
        Key=manifest_key,
        Body=manifest_body,
        ContentType="application/json",
    )

    print("Processing completed")
    print("Manifest updated")