provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "base-config-SEU_RM"
    key    = "compute/x86-graviton/terraform.tfstate"
    region = "us-east-1"
  }
}
