output "gocd-server-ip" {
  value = aws_instance.gocd-server.public_ip
}
