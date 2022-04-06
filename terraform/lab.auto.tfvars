region = "us-east-1"
profile = "Admin"
environment = "k8s-lab"
cidr_block = "10.0.0.0/16"
tag_map = {
  Name        = "K8sLab"
  Application = "K8sLab"
  CostCenter  = "K8sLab"
  Environment = "K8sLab"
  Customer    = "K8sLab"
}
ec2_key_pair_name = "aws-personal"
subnet_map = {
  public = "1"
  private = "0"
  isolated = "0"
}
