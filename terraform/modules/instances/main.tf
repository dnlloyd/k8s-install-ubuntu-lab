variable "ec2_key_pair_name" {}
variable "subnet_ids" {}
variable "security_group_ids" {}
variable "instance_count_cp" {}
variable "instance_type_cp" {}
variable "instance_count_worker" {}
variable "instance_type_worker" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  # filters from:
  # aws ec2 describe-images --image-ids ami-0e472ba40eb589f49 --region us-east-1
  
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "control_plane" {
  count = var.instance_count_cp

  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_cp
  key_name = var.ec2_key_pair_name
  subnet_id = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
}

resource "aws_instance" "worker" {
  count = var.instance_count_worker

  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_worker
  key_name = var.ec2_key_pair_name
  subnet_id = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
}

output "instance_ids_cp" {
  value = aws_instance.control_plane.*.id
}

output "instance_ipaddresses_worker" {
  value = aws_instance.worker.*.public_ip
}
