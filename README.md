# Install kubernetes on ubuntu

## Docs

Short version

https://phoenixnap.com/kb/install-kubernetes-on-ubuntu

Supplemental (but required for some steps)

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/


## AWS Specific Attributes

* VPC, instance, and security groups declared in `terraform` directory
* Use t3.small for kubernetes system reqs
* Launch master and worker nodes in same AZ
* Add security group to allow master / worker traffic

## CGroups driver mismatch issue in kubeadm

Issue Detail (Long conversation)

https://github.com/kubernetes/kubernetes/issues/43805#issuecomment-907734385


### Problematic kubadm init command:

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
