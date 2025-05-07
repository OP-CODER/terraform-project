output "inventory" {
  value = <<EOT
[frontend]
c9.local ansible_host=${aws_instance.c8.public_ip}
[backend]
u21.local ansible_host=${aws_instance.u21.public_ip}
