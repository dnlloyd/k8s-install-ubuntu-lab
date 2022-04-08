region = "us-east-1"
profile = "Admin"
environment = "k8s-HA"
cidr_block = "10.0.0.0/16"
tag_map = {
  Name        = "K8sHa"
  Application = "K8sHa"
  CostCenter  = "K8sHa"
  Environment = "K8sHa"
  Customer    = "K8sHa"
}
ec2_key_pair_name = "aws-personal"
subnet_map = {
  public = 3
  private = 0
  isolated = 0
}
nat_instances = 3
instance_count_cp = 3
instance_type_cp = "t3.small"
instance_count_worker = 1
instance_type_worker = "t3.small"
az_width = 3
load_balancer = 1
private_domain_name = "k8sha.net"
