terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "DiscovrAI"
    workspaces {
      name = "infra"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
