terraform {
  backend "s3" {
    bucket = "base-config-SEU_RM"
    key    = "vpc"
    region = "us-east-1"
  }
}
