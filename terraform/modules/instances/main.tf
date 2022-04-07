variable "ec2_key_pair_name" {}
variable "subnet_id" {}
variable "security_group_ids" {}
variable "instance_count" {}
variable "instance_type" {}

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

resource "aws_instance" "public" {
  count = var.instance_count

  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.ec2_key_pair_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
}
output "instance_ids" {
  value = aws_instance.public.*.id
}
