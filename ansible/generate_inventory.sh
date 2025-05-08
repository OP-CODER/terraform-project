#!/bin/bash

FRONTEND_IP=$(terraform output -raw frontend_public_ip)
BACKEND_IP=$(terraform output -raw backend_public_ip)

cat > inventory.ini <<EOF
[frontend]
c8 ansible_host=${FRONTEND_IP} ansible_user=ec2-user

[backend]
u21 ansible_host=${BACKEND_IP} ansible_user=ubuntu
EOF
