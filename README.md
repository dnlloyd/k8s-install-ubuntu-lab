# Install Kubernetes on Ubuntu

Guide to install Kubernetes clusters using AWS infrastructure.

*Note: This project is current to these versions:*
* Ubuntu: `18.04.3`
* Docker: `20.10.7`
* kubeadm: `1.23`

## Install a highly available Kubernetes cluster

### Doc

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/

### AWS Specific Attributes

* Infrastructure declared in `terraform` directory
  * VPC with public subnets*
  * Three control plane nodes in separate AZs
  * Security group to allow SSH and control plane/worker connectivity
  * Network load balancer for API server

\* VPC/subnet creation optional

Terraform plan

```
terraform plan -var-file=ha-cluster.tfvars
```

## Install a basic Kubernetes cluster

### Doc

Short version

https://phoenixnap.com/kb/install-kubernetes-on-ubuntu

Supplemental (but required for some steps)

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

### AWS Specific Attributes

* VPC, instance, and security groups declared in `terraform` directory
* Use t3.small for kubernetes system reqs
* Launch master and worker nodes in same AZ
* Add security group to allow master / worker traffic

* Infrastructure declared in `terraform` directory
  * VPC with public subnets*
  * Single master server in single AZ
  * Security group to allow SSH and master/worker connectivity

\* VPC/subnet creation optional

Terraform plan

```
terraform plan -var-file=basic-cluster.tfvars
```

### CGroup driver mismatch issue in kubeadm

#### Issue Detail (Long)

https://github.com/kubernetes/kubernetes/issues/43805#issuecomment-907734385

#### TL;DR

The kubeadm and docker CGroup drivers need to match. With the versions used at the date of this doc, kubeadm uses `systemd` and docker uses `cgroupfs`. I resolved by switching kubeadm to `cgroupfs`. More info [here](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver).

#### Problematic kubadm init command:

*Note: The `--pod-network-cidr=10.244.0.0/16` patameter is required for the flannel network during init*
```
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

Immediately after `init` is ran, edit: `/var/lib/kubelet/config.yaml` and change the following
```
cgroupDriver: cgroupfs
```

*The initialization should now complete successfully*

You'll need to do the same thing on the worker node when joining it to the cluster
