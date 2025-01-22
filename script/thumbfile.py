from PIL import Image
import os

def lambda_handler(event, context):
    input_bucket = event['input_bucket']
    output_bucket = event['output_bucket']
    key = event['key']
    size = (128, 128)

    local_input_path = f"/tmp/{key}"
    local_output_path = f"/tmp/thumbnail-{key}"

    # Simulate downloading file (replace with actual code if needed)
    # s3_client.download_file(input_bucket, key, local_input_path)

    try:
        with Image.open(local_input_path) as img:
            img.thumbnail(size)
            img.save(local_output_path, "JPEG")

        # Simulate uploading file (replace with actual code if needed)
        # s3_client.upload_file(local_output_path, output_bucket, f"thumbnail-{key}")
        
        return {"statusCode": 200, "body": "Thumbnail generated successfully"}
    except Exception as e:
        return {"statusCode": 500, "body": str(e)}

if __name__ == "__main__":
    lambda_handler(event, context)