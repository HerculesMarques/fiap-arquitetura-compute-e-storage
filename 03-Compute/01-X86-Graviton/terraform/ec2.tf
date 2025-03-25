provider "aws" {
  region = "us-east-1"
}

# Ubuntu 22.04 LTS para x86_64
data "aws_ami" "ubuntu_x86" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Ubuntu 22.04 LTS para ARM64 (Graviton)
data "aws_ami" "ubuntu_arm" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_instance" "x86_instance" {
  ami                    = data.aws_ami.ubuntu_x86.id
  instance_type          = "t3.large"
  key_name               = "vockey"
  iam_instance_profile   = "LabInstanceProfile"
  subnet_id              = random_shuffle.random_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.sec-compute.id]
  user_data = <<-EOF
              #!/bin/bash -xe
              echo 'x86_instance' | sudo tee -a /proc/sys/kernel/hostname
              sudo hostname x86_instance
              EOF
  tags = {
    Name = "x86-instance"
  }
}

resource "aws_instance" "graviton_instance" {
  ami                    = data.aws_ami.ubuntu_arm.id
  instance_type          = "t4g.large"
  key_name               = "vockey"
  iam_instance_profile   = "LabInstanceProfile"
  subnet_id              = random_shuffle.random_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.sec-compute.id]

  user_data = <<-EOF
              #!/bin/bash -xe
              echo 'graviton_instance' | sudo tee -a /proc/sys/kernel/hostname
              sudo hostname graviton_instance
              EOF

  tags = {
    Name = "graviton-instance"
  }
}

output "x86_instance_public_ip" {
  value = aws_instance.x86_instance.public_ip
}

output "graviton_instance_public_ip" {
  value = aws_instance.graviton_instance.public_ip
}