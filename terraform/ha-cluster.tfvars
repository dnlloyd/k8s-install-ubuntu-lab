region = "us-east-1"
profile = "Foghorn"
environment = "k8s-HA"
ec2_key_pair_name = "fh-sandbox"
instance_count_cp = 3
instance_type_cp = "t3.small"
instance_count_worker = 1
instance_type_worker = "t3.micro"
load_balancer = 1
private_domain_name = "k8sha.net"

# vpc_id = ""
vpc_id = "vpc-065b33a8baa73e2a3"
subnets = {
  public = [
    "subnet-08090a8df7f3a8c63",
    "subnet-07f0c07531ff40032",
    "subnet-0377599577dac9845"
  ]
}

# VPC
az_width = 3
cidr_block = "10.0.0.0/16"
nat_instances = 0
subnet_map = {
  public = 3
  private = 0
  isolated = 0
}
tag_map = {
  Name        = "K8sHa"
  Application = "K8sHa"
  CostCenter  = "K8sHa"
  Environment = "K8sHa"
  Customer    = "K8sHa"
}
