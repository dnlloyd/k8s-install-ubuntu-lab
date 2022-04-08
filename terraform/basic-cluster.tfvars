region = "us-east-1"
profile = "Admin"
environment = "k8s-basic"
cidr_block = "10.0.0.0/16"
tag_map = {
  Name        = "K8sBasic"
  Application = "K8sBasic"
  CostCenter  = "K8sBasic"
  Environment = "K8sBasic"
  Customer    = "K8sBasic"
}
ec2_key_pair_name = "aws-personal"
subnet_map = {
  public = "1"
  private = "0"
  isolated = "0"
}
nat_instances = 1
instance_count_cp = 1
instance_type_cp = "t3.small"
instance_count_worker = 1
instance_type_worker = "t3.micro"
az_width = 1
load_balancer = 0
