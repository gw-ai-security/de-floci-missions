import json
from datetime import datetime, timezone

import boto3
from botocore.exceptions import ClientError

s3 = boto3.client(
    "s3",
    endpoint_url="http://localhost:4566",
    region_name="eu-central-1",
    aws_access_key_id="test",
    aws_secret_access_key="test"
)

bucket = "northstar-data-lake"
source_key = "raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv"
manifest_key = "manifests/orders/orders_20260719T094506Z.json"

source_response = s3.head_object(
    Bucket=bucket,
    Key=source_key
)

current_etag = source_response["ETag"].strip('"')
current_size = source_response["ContentLength"]

try:
    manifest_response = s3.get_object(
        Bucket=bucket,
        Key=manifest_key
    )

    manifest_content = manifest_response["Body"].read().decode("utf-8-sig")
    manifest = json.loads(manifest_content)
    stored_etag = manifest["etag"]

except ClientError as error:
    error_code = error.response["Error"]["Code"]

    if error_code in ("NoSuchKey", "404"):
        stored_etag = None
        print("Manifest not found")
    else:
        raise

if current_etag == stored_etag:
    print("Decision: SKIP")
    print("Reason: Source object was already processed")

else:
    print("Decision: PROCESS")
    print("Reason: Source object is new or changed")

    print("Processing source object...")

    updated_manifest = {
        "bucket": bucket,
        "object_key": source_key,
        "etag": current_etag,
        "size_bytes": current_size,
        "processed_at": datetime.now(timezone.utc).isoformat(),
        "status": "INGESTED"
    }

    manifest_body = json.dumps(
        updated_manifest,
        indent=2
    ).encode("utf-8")

    s3.put_object(
        Bucket=bucket,
        Key=manifest_key,
        Body=manifest_body,
        ContentType="application/json"
    )

    print("Processing completed")
    print("Manifest updated")
