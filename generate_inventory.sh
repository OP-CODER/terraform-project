#!/bin/bash
cd terraform
terraform init
terraform apply -auto-approve
terraform output -raw inventory > ../ansible/inventory.ini
