#!/bin/bash

FRONTEND_IP=$(terraform output -raw frontend_public_ip)
BACKEND_IP=$(terraform output -raw backend_public_ip)

cat > inventory.ini <<EOF
[frontend]
c8.local ansible_host=${FRONTEND_IP}

[backend]
u21.local ansible_host=${BACKEND_IP}
EOF
