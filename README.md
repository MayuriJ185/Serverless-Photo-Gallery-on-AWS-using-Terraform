# 🖼️ SmartGallery: AI-Powered Serverless Photo App

## 📘 Overview
This project demonstrates the **deployment of a fully serverless photo gallery on AWS**, built using **Terraform** for infrastructure automation. The system allows real-time image uploads and automatically generates **thumbnails** and **AI-driven quality checks** using **Amazon Rekognition**.

Designed for scalability, automation, and intelligence, this solution showcases a modern serverless architecture ideal for cloud-native applications and AI-enhanced user experiences.

---

## 🎯 Project Goal

- Automate the provisioning of all necessary AWS services using Terraform
- Deploy and integrate Lambda functions for image processing
- Use Amazon Rekognition to score image quality and **filter out low-quality uploads**
- Automatically generate thumbnails for high-quality images
- Serve images securely and globally via CloudFront

---

## 🛠️ Tools & Technologies

- **Infrastructure as Code**: Terraform
- **Cloud Provider**: AWS
- **Compute**: AWS Lambda
- **AI/ML Service**: Amazon Rekognition
- **Storage**: Amazon S3
- **Delivery**: AWS CloudFront
- **Runtime**: Python (Lambda Functions)
- **Deployment**: Local CLI using Terraform

---

## 🧩 Key Features

- 🔁 **AI-based Image Filtering**: Uses Rekognition to detect low-quality or blurry images before thumbnailing
- 🖼️ **Automated Thumbnail Generation**: Creates 128x128 thumbnails for valid uploads using PIL
- ☁️ **Serverless & Scalable**: Built entirely on Lambda, S3, and API Gateway
- 🧾 **Clean IaC Design**: Declarative, reusable Terraform scripts
- 📈 **Event-Driven Architecture**: Lambda triggers on S3 image uploads
- 🛡️ **IAM Secured**: Lambda has scoped permissions for Rekognition and S3

---

## 🏗️ Infrastructure Components

### ✅ AWS Lambda Function
- Handles image quality scoring and thumbnail creation
- Uses Python’s `PIL` and `boto3` for image processing and Rekognition

### ✅ Amazon Rekognition
- Evaluates image quality and detects blurry/low-quality images in real-time

### ✅ Amazon S3 Buckets
- Stores original uploads and processed thumbnails separately

### ✅ API Gateway
- Exposes image upload endpoints for external clients

### ✅ CloudFront
- Delivers gallery images with low latency and high availability

---

## 🧠 Learning Highlights

- Using Terraform to deploy AI-enhanced serverless applications
- Integrating AWS Rekognition for real-time image insights
- Implementing IAM best practices for minimal permissions
- Building scalable infrastructure with Lambda, S3, and CloudFront

---

## 💡 Use Cases

- AI-powered image galleries
- Moderated user-generated content systems
- Scalable cloud photo storage & delivery platforms
- Serverless ML-powered content pipelines

---

## 📈 Future Enhancements

- 🔍 Add OpenSearch for natural-language image search
- 👥 Integrate Rekognition Face Comparison or Celebrity Detection
- 🧠 Add aesthetic scoring via SageMaker or HuggingFace models
- 🧾 Store metadata in DynamoDB for advanced querying
- 🧪 Integrate CI/CD for Lambda deployments

---

## ✅ How to Deploy

1. Ensure AWS CLI and Terraform are installed
2. Zip your updated `lambda_function.py` as `lambda.zip`
3. Run:

```bash
terraform init
terraform plan
terraform apply
