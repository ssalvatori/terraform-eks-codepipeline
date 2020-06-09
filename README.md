# EKS+GoCD using Terraform

* VPC creation using `terraform-aws-modules/vpc/aws`
* EKS creation

Setting Up kubectl 

```
mkdir ~/.kube/
terraform output kubeconfig > ~/.kube/config
kubectl version
terraform output config_map_aws_auth > configmap.yml
kubectl get nodes -o wide
```

Install k8s dashboard

Install Helm

Install Flux-CD
