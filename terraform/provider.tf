provider "aws" {
region = var.aws_region

default_tags {
tags = {
Project     = "karatu-2025-capstone"
Environment = "production"
ManagedBy   = "terraform"
}
}
}
