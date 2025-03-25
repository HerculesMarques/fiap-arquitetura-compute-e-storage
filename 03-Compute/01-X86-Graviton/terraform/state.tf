terraform {
  backend "s3" {
    bucket = "base-config-99"
    key    = "compute/x86-graviton/terraform.tfstate"
    region = "us-east-1"
  }
}
