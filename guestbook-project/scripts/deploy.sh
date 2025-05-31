#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TERRAFORM_DIR="$BASE_DIR/terraform"
ANSIBLE_DIR="$BASE_DIR/ansible"
INVENTORY_FILE="$ANSIBLE_DIR/inventory/hosts.ini"
SSH_KEY="$BASE_DIR/ssh/guestbook-key"

echo "🚀 Initializing Terraform..."
cd "$TERRAFORM_DIR"
terraform init

echo "📦 Applying Terraform plan..."
terraform apply -auto-approve

echo "🔍 Getting outputs from Terraform..."
EC2_IP=$(terraform output -raw ec2_public_ip)
RDS_HOST=$(terraform output -raw rds_endpoint)
S3_BUCKET=$(terraform output -raw s3_bucket_name)

echo "✅ EC2 Public IP: $EC2_IP"
echo "✅ RDS Endpoint: $RDS_HOST"
echo "✅ S3 Bucket: $S3_BUCKET"

echo "🛠 Updating Ansible inventory..."
cat > "$INVENTORY_FILE" <<EOF
[web]
$EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY
EOF

cd "$ANSIBLE_DIR"

echo "🔧 Running Ansible playbook..."
ansible-playbook -i inventory/hosts.ini \
  -e "db_host=$RDS_HOST db_user=postgres db_pass=supersecurepass123 s3_bucket=$S3_BUCKET" \
  playbook.yml

echo "✅ Deployment complete!"
echo "🌐 Application is available at: http://$EC2_IP"