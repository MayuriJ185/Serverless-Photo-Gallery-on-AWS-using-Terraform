from PIL import Image
import boto3
import os
import logging

s3_client = boto3.client('s3')
rekognition_client = boto3.client('rekognition')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    input_bucket = event['input_bucket']
    output_bucket = event['output_bucket']
    key = event['key']
    size = (128, 128)

    local_input_path = f"/tmp/{key}"
    local_output_path = f"/tmp/thumbnail-{key}"

    try:
        # Download the image from S3
        s3_client.download_file(input_bucket, key, local_input_path)

        # --- Step 1: Call Rekognition to check image quality ---
        with open(local_input_path, 'rb') as image_file:
            response = rekognition_client.detect_labels(
                Image={'Bytes': image_file.read()},
                MaxLabels=10,
                MinConfidence=70
            )

        labels = [label['Name'] for label in response['Labels']]
        logger.info(f"Detected labels for {key}: {labels}")

        # Optional: Check for blurry or low-quality indicators
        if "Blurry" in labels or "Low Quality" in labels:
            logger.warning(f"Image {key} flagged as low quality, skipping thumbnail.")
            return {
                "statusCode": 200,
                "body": f"Image {key} flagged as low quality and skipped."
            }

        # --- Step 2: Generate Thumbnail ---
        with Image.open(local_input_path) as img:
            img.thumbnail(size)
            img.save(local_output_path, "JPEG")

        # Upload the thumbnail back to S3
        s3_client.upload_file(local_output_path, output_bucket, f"thumbnail-{key}")

        return {"statusCode": 200, "body": "Thumbnail generated successfully"}

    except Exception as e:
        logger.error(f"Error processing image {key}: {str(e)}")
        return {"statusCode": 500, "body": str(e)}

# For local testing (optional)
if __name__ == "__main__":
    test_event = {
        'input_bucket': 'your-source-bucket',
        'output_bucket': 'your-thumbnail-bucket',
        'key': 'test-image.jpg'
    }
    lambda_handler(test_event, None)
