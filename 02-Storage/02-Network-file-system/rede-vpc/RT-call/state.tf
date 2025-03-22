terraform {
  backend "s3" {
    bucket = "base-config-SEU_RM"
    key    = "route-table"
    region = "us-east-1"
  }
}
