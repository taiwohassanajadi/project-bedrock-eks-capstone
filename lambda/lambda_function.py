import json
import urllib.parse
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):

    for record in event['Records']:

        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(
            record['s3']['object']['key'],
            encoding='utf-8'
        )

        print(f"Image received: {key}")
        print(f"Bucket: {bucket}")

    return {
        'statusCode': 200,
        'body': json.dumps('File processed successfully')
    }