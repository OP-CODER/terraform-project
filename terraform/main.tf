provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-085386e29e44dacd7"
  instance_type = "t2.micro"
  key_name      = var.public_key

  tags = {
    Name = "c8.local"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/frontend_ip.txt"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t2.micro"
  key_name      = var.public_key

  tags = {
    Name = "u21.local"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/backend_ip.txt"
  }
}
# Output IP addresses for Ansible inventory
output "c8_ip" {
  value = aws_instance.c8.public_ip
}
output "u21_ip" {
  value = aws_instance.u21.public_ip
}
