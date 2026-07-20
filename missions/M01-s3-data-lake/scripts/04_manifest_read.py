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
manifest_key = "manifests/orders/orders_20260719T094506Z.json"

response = s3.get_object(
    Bucket=bucket,
    Key=manifest_key
)

manifest_content = response["Body"].read().decode("utf-8-sig")
manifest = json.loads(manifest_content)

stored_etag = manifest["etag"]

print("Stored ETag:", stored_etag)
