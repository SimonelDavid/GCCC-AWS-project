# Guestbook Cloud Containerized App

> 🏫 This project was developed as part of the *Grid, Cluster and Cloud Computing (GCCC)* course at the Faculty of Mathematics and Computer Science, Babeș-Bolyai University.

This project deploys a simple guestbook web application with image uploads using AWS infrastructure, Docker containers, Ansible automation, and Terraform IaC.

## 🗂 Project Structure

```
guestbook-project/
├── ansible
│   ├── inventory
│   │   └── hosts.ini
│   ├── playbook.yml
│   └── roles
│       └── ec2_setup
│           ├── files
│           │   └── app
│           │       ├── backend
│           │       │   ├── Dockerfile
│           │       │   ├── app.py
│           │       │   └── requirements.txt
│           │       └── frontend
│           │           ├── Dockerfile
│           │           ├── default.conf
│           │           ├── index.html
│           │           └── script.js
│           ├── tasks
│           │   └── main.yml
│           └── templates
│               └── docker-compose.yml.j2
├── scripts
│   ├── deploy.sh
│   ├── destroy.sh
│   └── redeploy.sh
├── ssh
│   ├── guestbook-key
│   └── guestbook-key.pub
└── terraform
    ├── main.tf
    ├── output.tf
    ├── terraform.tfstate*
    ├── terraform.tfvars
    └── variables.tf
```

> 🔒 `terraform.tfstate` and `.backup` files are state management files and should be included in `.gitignore`.

## 🚀 Technologies Used

- **AWS EC2 & S3**: Infrastructure hosting and image storage
- **Terraform**: Infrastructure provisioning
- **Ansible**: Configuration and deployment automation
- **Docker + Docker Compose**: Containerized frontend & backend
- **Python Flask**: Backend REST API
- **NGINX**: Frontend web server
- **HTML/CSS/JS**: Simple and modern guestbook UI


## 📦 App Architecture

The application is split into the following components:

- **Frontend**: A simple HTML/CSS/JavaScript UI served by an NGINX container. Handles form submissions and review rendering.
- **Backend**: A Flask-based Python REST API for handling uploads, database interactions, and image retrieval.
- **PostgreSQL**: Used to store guestbook messages and image metadata.
- **S3**: Stores uploaded images (originals and thumbnails).
- **Docker Compose**: Defines and connects frontend and backend containers.
- **Terraform**: Provisions AWS infrastructure including EC2, security groups, and S3 bucket.
- **Ansible**: Installs Docker, sets up the environment, and deploys the application to EC2.

### Scripts

- `deploy.sh`: Initializes Terraform, applies infrastructure, and runs the Ansible playbook to deploy the app.
- `destroy.sh`: Tears down all Terraform-managed resources.
- `redeploy.sh`: Deletes old code and containers, clears Docker data (containers, images, volumes, networks), pulls the latest app code, and redeploys cleanly.

## 🚀 Deployment Guide

1. Configure AWS credentials and SSH key
2. Run Terraform to provision infrastructure:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```
3. Run Ansible playbook:
   ```bash
   cd ../ansible
   ansible-playbook -i inventory/hosts.ini playbook.yml
   ```
4. (Optional) Use scripts for convenience:
   - `scripts/deploy.sh` to automate provisioning and deployment.
   - `scripts/redeploy.sh` to reset and redeploy a clean environment.
   - `scripts/destroy.sh` to destroy infrastructure and clean up.

5. Access the app via the EC2 public IP

## 📁 .gitignore Suggestions

```
# Ignore generated Terraform state files and SSH keys
guestbook-project/ssh/
terraform/terraform.tfstate
terraform/terraform.tfstate.backup
terraform/.terraform*
.DS_Store
__pycache__/
```

---
*Built as part of the Grid, Cluster and Cloud Computing (GCCC) course — Faculty of Mathematics and Computer Science, Babeș-Bolyai University.*