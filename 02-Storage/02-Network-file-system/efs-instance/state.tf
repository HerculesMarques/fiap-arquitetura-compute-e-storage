terraform {
  backend "s3" {
    bucket = "base-config-SEU_RM"
    key    = "efs-lab"
    region = "us-east-1"
  }
}
