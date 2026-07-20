import json
from datetime import datetime, timezone

import boto3

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

manifest = {
    "bucket": bucket,
    "object_key": source_key,
    "etag": current_etag,
    "size_bytes": current_size,
    "processed_at": datetime.now(timezone.utc).isoformat(),
    "status": "INGESTED"
}

manifest_body = json.dumps(
    manifest,
    indent=2
).encode("utf-8")

s3.put_object(
    Bucket=bucket,
    Key=manifest_key,
    Body=manifest_body,
    ContentType="application/json"
)

print("Manifest updated")
print("Stored ETag:", current_etag)
print("Size:", current_size)
