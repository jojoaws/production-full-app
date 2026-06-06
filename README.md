Production Full App
Overview
Full-stack AWS application deployed using Terraform.

Architecture
React (S3 as static website) -> ALB -> ECS Fargate (Flask) -> DynamoDB
File Uploads -> S3

Technologies
- Terraform
- AWS ECS
- AWS ECR
- AWS ALB
- AWS S3
- AWS DynamoDB
- Docker
- Flask
- React
- GitHub Actions

Features
- Backend health check
- Create users
- Store users in DynamoDB
- Upload files to S3
- CI/CD pipeline

Deployment
terraform apply
npm run build
aws s3 sync ...

