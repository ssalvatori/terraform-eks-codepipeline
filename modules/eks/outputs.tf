output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority.0.data
}

output "token" {
  value = "${data.aws_eks_cluster_auth.this.token}"
}

output "depends_on_workstation" {
  value      = true
  depends_on = [aws_security_group.workstation-access, aws_security_group_rule.cluster-ingress-workstation-https]
}
