output "k8s_allns" {
  value = module.k8s.all-ns
}

output "gocd-server-public-ip" {
  value = module.gocd.gocd-server-ip
}
