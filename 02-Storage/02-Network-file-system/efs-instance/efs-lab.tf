# Data to retrieve the AMI ID from SSM Parameter
data "aws_ssm_parameter" "linux_ami" {
  name = var.linux_ami
}

resource "aws_efs_file_system" "sid_filesystem" {
  performance_mode = "generalPurpose"
  throughput_mode  = "provisioned"
  provisioned_throughput_in_mibps = 300

  tags = {
    Name = "SID-efs"
  }
}

resource "aws_efs_mount_target" "sid_mount_target" {
  file_system_id  = aws_efs_file_system.sid_filesystem.id
  subnet_id       = random_shuffle.random_subnet.result[0]
  security_groups = [aws_security_group.allow-ssh.id]
}

resource "aws_instance" "sid_perf_instance" {
  ami                         = data.aws_ssm_parameter.linux_ami.value
  instance_type               = "c5.large"
  subnet_id                   = random_shuffle.random_subnet.result[0]
  vpc_security_group_ids      = [aws_security_group.allow-ssh.id]
  iam_instance_profile        = var.iam_profile
  depends_on                  = [aws_efs_mount_target.sid_mount_target]

  tags = {
    Name = "SID-performance-instance"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = 1
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash -xe
              sudo yum update -y
              sudo yum install fio amazon-efs-utils git -y
              sudo amazon-linux-extras install epel -y
              sudo yum install fpart -y
              sudo yum install parallel -y
              sudo wget https://ftpmirror.gnu.org/parallel/parallel-20191022.tar.bz2
              sudo bzip2 -dc parallel-20191022.tar.bz2 | tar xvf -
              cd parallel-20191022
              sudo ./configure && make && sudo make install
              sudo mkfs -t ext4 /dev/nvme1n1
              sudo mkdir /ebsperftest
              sudo mount /dev/nvme1n1 /ebsperftest
              echo '/dev/nvme1n1       /ebsperftest    ext4  defaults,nofail        0   0' | sudo tee -a /etc/fstab
              screen -d -m -S fiotest fio --filename=/dev/nvme1n1 --rw=randread --bs=16k --runtime=9600 --time_based=1 --iodepth=32 --ioengine=libaio --direct=1  --name=gp2-16kb-burst-bucket-test
              sudo mkdir /efs
              sudo chown ec2-user:ec2-user /efs
              sudo mount -t efs ${aws_efs_file_system.sid_filesystem.id}:/ /efs
              sudo mkdir -p /efs/tutorial/{dd,touch,rsync,cp,parallelcp,parallelcpio}/
              sudo chown ec2-user:ec2-user /efs/tutorial/ -R
              cd /home/ec2-user/
              sudo git clone https://github.com/kevinschwarz/smallfile.git
              sudo mkdir -p /ebs/tutorial/{smallfile,data-1m}
              sudo chown ec2-user:ec2-user //ebs/tutorial/ -R
              echo '#!/bin/bash' > /etc/profile.d/script.sh
              sudo echo export bucket=${var.bucket} >> /etc/profile.d/script.sh
              echo 'fiap-efs-lab' | sudo tee -a /proc/sys/kernel/hostname
              python /home/ec2-user/smallfile/smallfile_cli.py --operation create --threads 10 --file-size 1024 --file-size-distribution exponential --files 200 --same-dir N --dirs-per-dir 1024 --hash-into-dirs Y --files-per-dir 10240 --top /ebs/tutorial/smallfile
              cp -R /ebs/tutorial/smallfile/file_srcdir/storage-workshop /ebs/tutorial/data-1m/
              mkdir -p ~/.aws
              aws configure set region us-east-1
              aws configure set output json
              EOF
}

output "perf_lab_instance_dns" {
  value = aws_instance.sid_perf_instance.public_dns
}
