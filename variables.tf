variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project prefix used in names"
  type        = string
  default     = "discovr"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (at least 2)"
  type        = list(string)
  default     = ["10.42.1.0/24", "10.42.2.0/24"]
}

variable "availability_zones" {
  description = "AZs matching public_subnet_cidrs length"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "domain_name" {
  description = "The main domain name (e.g. discovr.ai)"
  type        = string
  default     = ""
}

variable "backend_domain" {
  description = "Host/domain for backend service"
  type        = string
}

variable "ai_domain" {
  description = "Host/domain for AI service"
  type        = string
}

variable "frontend_domain" {
  description = "Host/domain for frontend service"
  type        = string
}

variable "admin_domain" {
  description = "Host/domain for admin service"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID. Leave empty to skip DNS records"
  type        = string
  default     = ""
}

variable "service_image_tags" {
  description = "Image tags per service key: backend, ai, frontend, admin"
  type        = map(string)
  default = {
    backend  = "latest"
    ai       = "latest"
    frontend = "latest"
    admin    = "latest"
  }
}

variable "service_desired_count" {
  description = "Desired ECS task count per service"
  type        = map(number)
  default = {
    backend  = 1
    ai       = 1
    frontend = 1
    admin    = 1
  }
}

variable "service_cpu" {
  description = "Fargate CPU units per service"
  type        = map(number)
  default = {
    backend  = 512
    ai       = 512
    frontend = 256
    admin    = 512
  }
}

variable "service_memory" {
  description = "Fargate memory (MB) per service"
  type        = map(number)
  default = {
    backend  = 1024
    ai       = 1024
    frontend = 512
    admin    = 1024
  }
}

variable "backend_env" {
  description = "Extra env vars for backend container"
  type        = map(string)
  default     = {}
}

variable "ai_env" {
  description = "Extra env vars for ai container"
  type        = map(string)
  default     = {}
}

variable "frontend_env" {
  description = "Extra env vars for frontend container"
  type        = map(string)
  default     = {}
}

variable "admin_env" {
  description = "Extra env vars for admin container"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Extra tags for all resources"
  type        = map(string)
  default     = {}
}

variable "FIREBASE_CREDENTIALS_JSON" {
  description = "Firebase service account JSON content"
  type        = string
  sensitive   = true
  default     = ""
}
