output "inventory" {
  value = <<EOT
[frontend]
c9.local ansible_host=${aws_instance.r9.public_ip}
[backend]
u21.local ansible_host=${aws_instance.d12.public_ip}
