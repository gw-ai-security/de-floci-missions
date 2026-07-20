import boto3

s3 = boto3.client(
    "s3",
    endpoint_url="http://localhost:4566",
    region_name="eu-central-1",
    aws_access_key_id="test",
    aws_secret_access_key="test",
)

response = s3.head_object(
    Bucket="northstar-data-lake",
    Key="raw/orders/ingestion_date=2026-07-19/orders_20260719T094506Z.csv",
)

print("ContentLength:", response["ContentLength"])
print("ETag:", response["ETag"])
print("LastModified:", response["LastModified"])
print("ContentType:", response["ContentType"])
