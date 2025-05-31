#!/bin/bash

set -e

TERRAFORM_DIR="../terraform"
ANSIBLE_DIR="../ansible"
INVENTORY_FILE="$ANSIBLE_DIR/inventory/hosts.ini"

echo "🧹 Destroying infrastructure..."

cd "$TERRAFORM_DIR"
terraform destroy -auto-approve

echo "🧽 Cleaning up Ansible inventory..."
rm -f "$INVENTORY_FILE"

echo "✅ Cleanup complete. All AWS resources destroyed."