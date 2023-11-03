terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}# Define the AWS provider configuration


provider "aws" {
  region = "eu-central-1"  # Set your desired AWS region
}

output "ecr_repository_url" {
  value = var.ecr_url
}
