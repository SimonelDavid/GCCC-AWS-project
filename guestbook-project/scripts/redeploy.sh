#!/bin/bash

set -e

# Load Terraform outputs
cd ../terraform
EC2_IP=$(terraform output -raw ec2_public_ip)
cd - > /dev/null

SSH_KEY="../ssh/guestbook-key"
SSH_USER="ubuntu"
SSH_CMD="ssh -i $SSH_KEY $SSH_USER@$EC2_IP"

echo "🚧 Cleaning up Docker environment on $EC2_IP..."

$SSH_CMD <<'EOF'
echo "📦 Navigating to app directory if it exists..."
if [ -d "/opt/app" ]; then
  cd /opt/app

  echo "🧯 Bringing down docker-compose stack..."
  sudo docker-compose down || true
fi

echo "🧹 Pruning all unused Docker resources (containers, networks, images, volumes)..."
sudo docker system prune -af --volumes

echo "🧼 Removing app directory completely..."
sudo rm -rf /opt/app
EOF

echo "♻️ Environment cleaned. Re-running deployment..."
./deploy.sh