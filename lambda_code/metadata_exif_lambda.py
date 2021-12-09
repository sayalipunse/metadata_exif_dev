#!/usr/bin/env python3

import logging
import io
import boto3
import os
from exif import Image

# Initializing logger and setting basic log level as Info 
logger = logging.getLogger()
logger.setLevel('INFO')

# S3 boto3 connection
s3 = boto3.client('s3')
s3_resource = boto3.resource('s3')

# Function to read lambda input triggered from source S3 bucket A
# and return filename, bucketname and event type
def read_lambda_trigger(event):
    event_type = event['Records'][0]['eventName']
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_name = event['Records'][0]['s3']['object']['key']
    return file_name, bucket_name, event_type

# Function to read source s3 bucket A file and return its content
def read_s3_file(file_name, bucket):
    s3_object = s3_resource.Object(bucket, file_name)
    with io.BytesIO() as f:
        s3_object.download_fileobj(f)
        f.seek(0)
        content = f.read()
    return content

# Function to clean metadata exif from the source bucket A file
def clean_metadata_exif(source_content):
    byte_content = bytes(source_content)
    image = Image(byte_content)
    clean_img = image.delete_all()
    no_exif_image = image.get_file()
    return no_exif_image

# Function to copy clean metadata exif file to destination bucket B
def copy_file_to_destination_bucket(event):
    source_file, source_bucket, event_type = read_lambda_trigger(event)
    print('New file uploaded to source S3 bucket ' + source_file + ' using method ' + event_type )
    destination_bucket = os.environ['destination_s3_bucket']
    source_content = read_s3_file(source_file, source_bucket)
    clean_image = clean_metadata_exif(source_content)
    s3.put_object(Body=clean_image, Bucket=destination_bucket, Key=source_file, ContentType='image/jpeg')
    return(source_file + ' has been cleaned and saved in the destination bucket ' + destination_bucket)

# Lambda handler
def lambda_handler(event, context):
    print(copy_file_to_destination_bucket(event))
