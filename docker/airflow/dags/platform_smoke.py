"""Plattform-Smoke-Test, ausdrücklich keine Lösung einer Lernmission."""
from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator


BUCKET = "smoke-airflow-platform"
KEY = "input/sample.txt"


def client():
    import boto3
    return boto3.client("s3", endpoint_url="http://floci:4566", region_name="eu-central-1")


def seed():
    s3 = client()
    s3.create_bucket(Bucket=BUCKET, CreateBucketConfiguration={"LocationConstraint": "eu-central-1"})
    s3.put_object(Bucket=BUCKET, Key=KEY, Body=b"northstar\ncommerce\n")


def transform():
    s3 = client()
    body = s3.get_object(Bucket=BUCKET, Key=KEY)["Body"].read().decode("utf-8")
    s3.put_object(Bucket=BUCKET, Key="output/sample.txt", Body=body.upper().encode("utf-8"))


def cleanup():
    s3 = client()
    for item in s3.list_objects_v2(Bucket=BUCKET).get("Contents", []):
        s3.delete_object(Bucket=BUCKET, Key=item["Key"])
    s3.delete_bucket(Bucket=BUCKET)


with DAG(
    dag_id="platform_smoke_only",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["platform-smoke", "not-a-mission-solution"],
) as dag:
    PythonOperator(task_id="seed_temporary_input", python_callable=seed) >> PythonOperator(
        task_id="transform_to_uppercase", python_callable=transform
    ) >> PythonOperator(task_id="cleanup_temporary_resources", python_callable=cleanup)
