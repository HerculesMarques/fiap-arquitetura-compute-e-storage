variable "bucket" {
  description = "Name of the S3 Bucket to use for the lab"
  type        = string
  default     = "base-config-99"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.bucket))
    error_message = "The bucket must begin with a letter and contain only alphanumeric characters or hyphens."
  }
}

variable "project" {
  default = "fiap-lab"
}

data "aws_vpc" "vpc" {
    tags = {
        Name = "${var.project}"
    }
}

data "aws_subnets" "all" {
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}

variable "iam_profile" {
  description = "IAM Profile to use for the EC2 resources"
  type        = string
  default     = "LabInstanceProfile"
}

variable "linux_ami" {
  description = "Linux AMI ID"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}