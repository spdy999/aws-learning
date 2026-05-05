terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Bucket name is passed at init time via -backend-config
  # See .github/workflows/deploy-fargate.yml
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}
