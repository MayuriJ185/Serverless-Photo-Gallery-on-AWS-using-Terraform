resource "aws_s3_bucket" "photo_storage" {
  bucket = "photo-gallery-${random_string.suffix.id}"
}

resource "aws_s3_bucket" "thumbnail_storage" {
  bucket = "photo-thumbnails-${random_string.suffix.id}"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
resource "aws_lambda_function" "photo_processor" {
  function_name    = "photoProcessor"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  filename         = "C:/Users/maayu/OneDrive/Documents/Projects/Terraform Project/lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      THUMBNAIL_BUCKET = aws_s3_bucket.thumbnail_storage.id
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "rekognition_policy" {
  name = "rekognition-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rekognition:DetectLabels"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_apigatewayv2_api" "photo_upload_api" {
  name          = "PhotoUploadAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "photo_upload_integration" {
  api_id           = aws_apigatewayv2_api.photo_upload_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.photo_processor.invoke_arn
}

resource "aws_apigatewayv2_route" "photo_upload_route" {
  api_id    = aws_apigatewayv2_api.photo_upload_api.id
  route_key = "POST /upload"
  target    = "integrations/${aws_apigatewayv2_integration.photo_upload_integration.id}"
}
resource "aws_cloudfront_distribution" "photo_gallery" {
    origin {
      domain_name = aws_s3_bucket.photo_storage.bucket_regional_domain_name
      origin_id   = "PhotoGalleryOrigin"
  }

    default_cache_behavior {
      target_origin_id = "PhotoGalleryOrigin"
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]
      forwarded_values {
            query_string = false # Set to true if query strings need to be forwarded
            cookies {
                forward = "none" # Options: "none", "whitelist", "all"
            }
        }
  }

    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"

    viewer_certificate {
      cloudfront_default_certificate = true
    }
    restrictions {
        geo_restriction {
            restriction_type = "whitelist" # or "blacklist" or "none"
            locations        = ["US", "CA"] # List of country codes
        }
    }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.photo_storage.bucket
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.photo_upload_api.api_endpoint
}
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.photo_gallery.domain_name
}
