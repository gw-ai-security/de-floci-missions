import json
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

manifest_response = s3.get_object(
    Bucket=bucket,
    Key=manifest_key
)

manifest_content = manifest_response["Body"].read().decode("utf-8-sig")
manifest = json.loads(manifest_content)

stored_etag = manifest["etag"]

print("Current ETag:", current_etag)
print("Stored ETag: ", stored_etag)

if current_etag == stored_etag:
    print("Decision: SKIP")
else:
    print("Decision: PROCESS")
