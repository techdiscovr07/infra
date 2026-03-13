# Discovr AWS Terraform (4 Services)

This folder provisions AWS infrastructure for all four services:

- `backend` -> `discovr` (Go API)
- `ai` -> `discovr-ai-service` (FastAPI)
- `frontend` -> `discovr-frontend`
- `admin` -> `admin`

## What Terraform creates

- VPC + 2 public subnets + internet gateway
- Security groups (ALB and ECS tasks)
- One Application Load Balancer
- Host-based routing for all 4 services
- ECS cluster (Fargate)
- 4 ECS task definitions + services
- 4 ECR repositories
- CloudWatch log groups
- Optional Route53 A records (if `route53_zone_id` is set)

## Domain routing

Traffic is routed by host header:

- `backend_domain` -> backend service
- `ai_domain` -> ai service
- `frontend_domain` -> frontend service
- `admin_domain` -> admin service

## Prerequisites

- Terraform >= 1.5
- AWS CLI authenticated to your account
- Docker installed locally
- Domain ready in Route53 (optional but recommended)

## 1) Configure variables

```bash
cd infra
# edit main.tfvars
```

## 2) Create infra

```bash
terraform init
terraform plan -var-file="main.tfvars"
terraform apply -var-file="main.tfvars"
```

After apply, run:

```bash
terraform output ecr_repository_urls
terraform output alb_dns_name
```

## 3) Build and push images (from repo root)

Use the ECR URLs from output.

```bash
# authenticate Docker to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-south-1.amazonaws.com

# backend
docker build -t <backend-ecr-url>:latest ./discovr
docker push <backend-ecr-url>:latest

# ai service
docker build -t <ai-ecr-url>:latest ./discovr-ai-service
docker push <ai-ecr-url>:latest

# frontend
docker build -t <frontend-ecr-url>:latest ./discovr-frontend
docker push <frontend-ecr-url>:latest

# admin
docker build -t <admin-ecr-url>:latest ./admin
docker push <admin-ecr-url>:latest
```

## 4) Redeploy ECS tasks with new tags

If you use a non-`latest` tag, update `service_image_tags` in `main.tfvars` and run:

```bash
terraform apply -var-file="main.tfvars"
```

## Important notes

- This baseline uses HTTP listener (`:80`) on ALB. Add ACM + HTTPS listener for production TLS.
- ECS tasks are currently in public subnets with public IPs for simplicity.
- Ensure each service Dockerfile starts the app on the configured container port in `locals.tf`.
- Runtime secrets should come from env vars (and ideally from AWS Secrets Manager/SSM in next step).
