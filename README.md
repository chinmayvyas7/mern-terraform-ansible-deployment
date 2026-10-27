# MERN Application Deployment on AWS using Terraform & Ansible

An end-to-end Infrastructure as Code (IaC) project that deploys the **TravelMemory MERN application** on AWS using Terraform for infrastructure provisioning and Ansible for server configuration and application deployment.

## Project Overview

This project automates the deployment of a MERN application on AWS with a public web server, a private database server, secure network boundaries, and repeatable configuration management.

The infrastructure was deployed and verified on AWS in the `ap-south-1` (Mumbai) region.

## Architecture

```text
                    Internet
                       |
                HTTP (Port 80)
                       |
                +--------------+
                |  AWS VPC     |
                |              |
                |  Public      |
                |  Subnet      |
                |      |       |
                |  Web EC2     |
                |  Nginx       |
                |  React UI    |
                |  Node.js API |
                |      |       |
                |  Private     |
                |  Subnet      |
                |      |       |
                |  MongoDB EC2 |
                +--------------+
```

### Technology Stack

| Component | Technology |
|---|---|
| Cloud provider | Amazon Web Services (AWS) |
| Infrastructure provisioning | Terraform |
| Configuration management | Ansible |
| Frontend | React.js |
| Backend | Node.js, Express.js |
| Database | MongoDB |
| Web server / reverse proxy | Nginx |
| Compute | Amazon EC2 |
| Networking | VPC, public and private subnets, security groups |
| Operating environment | Ubuntu / WSL |

## Key Features

- Infrastructure provisioning using reusable Terraform configuration.
- Separate web and database EC2 instances.
- Public-facing web tier and private database tier.
- Automated server configuration through Ansible roles and playbooks.
- MongoDB authentication and application database user configuration.
- Nginx reverse proxy and systemd-managed backend service.
- Application health endpoint for deployment verification.
- Sensitive configuration excluded from version control.
- Deployment evidence and technical documentation maintained in the repository.

## Repository Structure

```text
MERN-Terraform-Ansible/
├── app/
│   ├── backend/
│   └── frontend/
├── terraform/
│   ├── versions.tf
│   ├── variables.tf
│   ├── network.tf
│   ├── security.tf
│   ├── ec2.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── ansible/
│   ├── ansible.cfg
│   ├── playbooks/
│   ├── roles/
│   ├── group_vars/
│   └── requirements.yml
├── docs/
│   ├── architecture-and-deployment-report.md
│   └── ASSIGNMENT-CHECKLIST.md
├── evidence/
├── .gitignore
└── README.md
```

## Prerequisites

Install and configure the following before deploying:

- AWS account with appropriately scoped permissions.
- AWS CLI configured with valid credentials.
- Terraform.
- Ansible.
- SSH access to the EC2 instances.
- A private SSH key stored securely outside the repository.
- PowerShell if using the supplied Windows inventory-generation script.

## Deployment Guide

### 1. Configure AWS

Configure your AWS CLI credentials and verify the identity:

```bash
aws configure
aws sts get-caller-identity
aws configure get region
```

Use the AWS region configured for your deployment.

### 2. Configure Terraform

```bash
cd terraform

terraform init
terraform fmt -check
terraform validate
terraform plan
```

Review the Terraform plan before applying any infrastructure changes.

```bash
terraform apply
```

> **Note:** Applying Terraform can create billable AWS resources or modify existing infrastructure. Review the plan carefully before proceeding.

After deployment, inspect the available outputs:

```bash
terraform output
```

### 3. Configure Ansible

Install the required Ansible collections from the project directory:

```bash
cd ../ansible

ansible-galaxy collection install -r requirements.yml
```

Generate or configure the inventory using the Terraform outputs and the private key path appropriate to your execution environment.

Review the inventory before running the playbooks. The generated inventory file is intentionally excluded from Git.

### 4. Configure Database and Application Servers

Run the database configuration playbook:

```bash
ANSIBLE_CONFIG="$PWD/ansible.cfg" \
ansible-playbook -i inventory/hosts.ini playbooks/database.yml --ask-vault-pass
```

Run the web server and application configuration playbook:

```bash
ANSIBLE_CONFIG="$PWD/ansible.cfg" \
ansible-playbook -i inventory/hosts.ini playbooks/web.yml --ask-vault-pass
```

The vault password must be supplied securely. Do not commit the vault password or decrypted credentials.

### 5. Verify the Deployment

Open the public IP address of the web instance in a browser:

```text
http://<WEB_PUBLIC_IP>
```

Check the application health endpoint:

```bash
curl -i http://<WEB_PUBLIC_IP>/health
```

The expected health response is HTTP 200 with a JSON response indicating that the application is healthy and the database connection is established.

Also verify the Ansible play recap and the EC2 instance status checks in the AWS Console.

## Deployment Verification

The following checks were completed for the deployed environment:

- Both EC2 instances were running and passed their AWS status checks.
- The web application loaded through the public web server.
- A trip was created and displayed successfully in the application.
- The application health endpoint returned HTTP 200.
- The health response reported a successful database connection.
- The Ansible database and web configuration playbooks completed without failed hosts.

Supporting evidence is maintained in the `evidence/` directory and the deployment report in `docs/`.

## Security Practices

- Keep Terraform state files and local variable files out of version control.
- Store MongoDB credentials in Ansible Vault.
- Never commit SSH private keys, AWS access keys, passwords, or production `.env` files.
- Restrict database access to the application tier.
- Limit SSH access to trusted source addresses.
- Use example configuration files for documenting required variables.
- Rotate any credentials that may have been exposed during development.

## Cost and Cleanup

EC2 instances, EBS volumes, public IPv4 addresses, and other AWS resources can incur charges while they exist.

When the environment is no longer required, inspect the Terraform workspace and plan the cleanup carefully before running:

```bash
cd terraform
terraform plan -destroy
```

If the plan is correct and the environment is no longer needed:

```bash
terraform destroy
```

Do not destroy resources that must remain available for assessment or demonstration.

## Documentation

- [Architecture and Deployment Report](docs/architecture-and-deployment-report.md)
- [Assignment Checklist](docs/ASSIGNMENT-CHECKLIST.md)
- [Deployment Evidence](evidence/)

## Author

**Chinmay Vyas**

GitHub: [@chinmayvyas7](https://github.com/chinmayvyas7)

---

*Built to demonstrate Infrastructure as Code, configuration management, secure cloud networking, and automated application deployment on AWS.*
