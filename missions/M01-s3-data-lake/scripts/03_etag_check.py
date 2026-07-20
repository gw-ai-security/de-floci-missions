import boto3

s3 = boto3.client(
    "s3",
    endpoint_url="http://localhost:4566",
    region_name="eu-central-1",
    aws_access_key_id="test",
    aws_secret_access_key="test"
)

bucket = "northstar-data-lake"
object_key = "raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv"

response = s3.head_object(
    Bucket=bucket,
    Key=object_key
)

current_etag = response["ETag"].strip('"')

print("Current ETag:", current_etag)
