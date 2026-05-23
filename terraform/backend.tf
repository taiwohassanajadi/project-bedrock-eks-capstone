terraform {
  backend "s3" {
    bucket  = "project-bedrock-terraform-state-135167709863"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}