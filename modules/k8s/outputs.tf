data "kubernetes_all_namespaces" "allns" {
  depends_on = [var.eks_depends_on]
}

output "all-ns" {
  value = data.kubernetes_all_namespaces.allns.namespaces
}

output "ns-present" {
  value = contains(data.kubernetes_all_namespaces.allns.namespaces, "kube-system")
}

