# EKS+GoCD using Terraform

* VPC creation using `terraform-aws-modules/vpc/aws`
* EKS creation

K8S dashboard
* https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

## Access to k8s dashboard

Setting Up kubectl 

```
aws --profile saml eks --region eu-central-1 update-kubeconfig --name eks-test
```

Get the auth token using
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
```

Active proxy

```
kubectl proxy
```

```
http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

Install Helm

Install Flux-CD
