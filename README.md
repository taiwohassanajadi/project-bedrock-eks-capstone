# AWS EKS Retail Store Platform – DevOps Capstone Project

## Project Overview

This project demonstrates the deployment of a secure, scalable, highly available, and observable cloud-native retail application on AWS using modern DevOps and Infrastructure as Code (IaC) practices.

The solution leverages:

- Amazon EKS (Elastic Kubernetes Service)
- Terraform Infrastructure as Code
- Helm-based Kubernetes deployments
- AWS Application Load Balancer (ALB)
- Amazon RDS (MySQL & PostgreSQL)
- AWS Lambda + S3 Event-Driven Processing
- AWS IAM + Kubernetes RBAC
- CloudWatch Logging & Monitoring
- GitHub Actions CI/CD Pipeline

The architecture was designed following security, scalability, observability, and automation best practices.

---

# Architecture Diagram

![Architecture Diagram](docs/architecture-diagram.png)

---

# Project Objectives

This project implements:

- Infrastructure provisioning using Terraform
- Secure EKS cluster deployment
- High availability architecture
- Kubernetes application deployment using Helm
- Event-driven serverless integration
- IAM least privilege access control
- Observability and centralized logging
- CI/CD automation
- Developer handoff readiness

---

# Technologies Used

| Technology | Purpose |
|---|---|
| AWS EKS | Kubernetes orchestration |
| Terraform | Infrastructure as Code |
| Helm | Kubernetes package management |
| Amazon RDS | Managed relational databases |
| Amazon S3 | Object storage |
| AWS Lambda | Event-driven processing |
| CloudWatch | Monitoring and logs |
| IAM + RBAC | Secure developer access |
| GitHub Actions | CI/CD automation |
| ALB Ingress Controller | External traffic routing |

---

# Architecture Components

## Networking Layer

- Custom VPC
- Public and Private Subnets
- NAT Gateway
- Internet Gateway
- Security Groups
- Route Tables

## Compute Layer

- Amazon EKS Cluster
- Managed Node Groups
- Kubernetes Deployments & Services

## Application Layer

Retail Store Microservices:

- UI
- Catalog
- Orders
- Checkout
- Carts

## Data Layer

- Amazon RDS MySQL
- Amazon RDS PostgreSQL
- AWS Secrets Manager

## Serverless Layer

- Amazon S3 Assets Bucket
- AWS Lambda Trigger
- CloudWatch Logging

---

# Security Implementation

## IAM Least Privilege

Created developer IAM user:

```text
bedrock-dev-view
```

Permissions:

- AWS Console ReadOnlyAccess
- AmazonEKSViewPolicy
- Namespace-scoped Kubernetes access

## Kubernetes RBAC

Developer access restricted to:

```text
Namespace: retail-app
```

Read-only access implemented using:

```text
AmazonEKSViewPolicy
```

Verification:

```bash
kubectl get pods -n retail-app
```

Allowed.

```bash
kubectl delete pod <pod-name> -n retail-app
```

Denied.

---

# CI/CD Pipeline

GitHub Actions workflow automates:

## Pull Requests

- terraform fmt
- terraform init
- terraform validate
- terraform plan

## Merge to Main

- terraform apply

AWS credentials are securely managed using GitHub repository secrets.

Workflow file:

```text
.github/workflows/terraform.yml
```

---

# Helm Deployment

Application deployed using Helm.

Deployment command:

```bash
helm upgrade --install retail-store src/app/chart \
  --namespace retail-app \
  -f ../helm/bedrock-values.yaml
```

---

# Event-Driven Serverless Workflow

When a file is uploaded to the S3 assets bucket:

1. S3 event triggers Lambda
2. Lambda processes uploaded object
3. Event logs are written to CloudWatch

Example log:

```text
Image received: test-image.txt
```

---

# Observability

## EKS Control Plane Logging Enabled

- API
- Audit
- Authenticator
- ControllerManager
- Scheduler

## CloudWatch Integration

Application logs:
```text
/aws/eks/project-bedrock-cluster/cluster
```

Lambda logs:
```text
/aws/lambda/bedrock-asset-processor
```

---

# Infrastructure Outputs

Generated grading file:

```text
grading.json
```

Terraform outputs include:

- cluster_endpoint
- cluster_name
- aws_region
- vpc_id
- assets_bucket_name

---

# Project Structure

```text
project-bedrock-eks-capstone/
│
├── .github/workflows/
├── docs/
├── helm/
├── kubernetes/
├── lambda/
├── screenshots/
├── terraform/
├── grading.json
├── README.md
└── retail-store-sample-app/
```

---

# Deployment Guide

## 1. Clone Repository

```bash
git clone <repository-url>
cd project-bedrock-eks-capstone
```

---

## 2. Initialize Terraform

```bash
cd terraform
terraform init
terraform apply
```

---

## 3. Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster
```

---

## 4. Deploy Application

```bash
helm dependency build src/app/chart

helm upgrade --install retail-store src/app/chart \
  --namespace retail-app \
  -f ../helm/bedrock-values.yaml
```

---

# Application Access

Retail Store URL:

```text
http://<ALB-DNS-NAME>
```

---

# Tags

All AWS infrastructure resources tagged with:

```text
Project = karatu-2025-capstone
```

---

# Screenshots

Project evidence available in:

```text
/screenshots
```

Includes:

- Terraform provisioning
- EKS deployment
- ALB ingress
- RDS creation
- Lambda execution
- CloudWatch logs
- GitHub Actions
- Retail application access

---

# Author

Taiwo Hassan Ajadi  
Cloud & DevOps Engineering Capstone Project

---

# Cleanup

To avoid unnecessary AWS charges:

```bash
terraform destroy
```

---

# License

This project is for academic and educational purposes.
