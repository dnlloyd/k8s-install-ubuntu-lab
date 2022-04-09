region = "us-east-1"
profile = "Foghorn"
environment = "k8s-basic"
ec2_key_pair_name = "fh-sandbox"
instance_count_cp = 1
instance_type_cp = "t3.small"
instance_count_worker = 1
instance_type_worker = "t3.micro"
load_balancer = 0

vpc_id = "vpc-065b33a8baa73e2a3"
subnets = {
  public = [
    "subnet-08090a8df7f3a8c63"
  ]
}

# VPC - If vpc_id = ""
az_width = 1
cidr_block = "10.0.0.0/16"
nat_instances = 0
subnet_map = {
  public = "1"
  private = "0"
  isolated = "0"
}
tag_map = {
  Name        = "K8sBasic"
  Application = "K8sBasic"
  CostCenter  = "K8sBasic"
  Environment = "K8sBasic"
  Customer    = "K8sBasic"
}
