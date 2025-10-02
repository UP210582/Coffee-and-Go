import boto3

s3 = boto3.client("s3")

def upload_to_s3(file_path: str, bucket_name: str, key: str):
    s3.upload_file(file_path, bucket_name, key)
    return f"s3://{bucket_name}/{key}"
