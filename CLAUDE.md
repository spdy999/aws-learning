# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Learning repo for AWS services using Terraform + GitHub Actions. Each top-level directory covers one AWS service.

## Repository layout

```
aws-learning/
├── fargate/
│   ├── app/          # Dockerized app (nginx serving static HTML)
│   └── terraform/    # All infra for the Fargate service
└── .github/
    └── workflows/
        └── deploy-fargate.yml
```

## Adding a new AWS service

Create a new top-level directory (e.g. `lambda/`, `rds/`) with the same pattern:
- `<service>/app/` — sample application code
- `<service>/terraform/` — Terraform using the same S3 backend pattern
- `.github/workflows/deploy-<service>.yml` — CI/CD pipeline

## Terraform

All modules use a **partial S3 backend** — the bucket name is injected at `terraform init` time.

```bash
# One-time: create the state bucket manually
aws s3 mb s3://<your-bucket> --region us-east-1

# Local init (replace bucket name)
cd fargate/terraform
terraform init \
  -backend-config="bucket=<your-bucket>" \
  -backend-config="key=fargate/terraform.tfstate" \
  -backend-config="region=us-east-1"

terraform plan -var="image_tag=latest"
terraform apply -var="image_tag=latest"
terraform destroy
```

## GitHub Actions secrets and variables

Set these in **Settings > Secrets and variables > Actions**:

| Name | Type | Description |
|------|------|-------------|
| `AWS_ACCESS_KEY_ID` | Secret | KodeKloud AWS key |
| `AWS_SECRET_ACCESS_KEY` | Secret | KodeKloud AWS secret |
| `AWS_SESSION_TOKEN` | Secret | KodeKloud session token (temp credentials) |
| `TF_STATE_BUCKET` | Variable | S3 bucket name for Terraform state |

The pipeline triggers on pushes to `main` that touch `fargate/**`. It can also be run manually from the Actions tab with an optional `destroy=true` input to tear everything down.

## KodeKloud constraints

- Uses the **default VPC** (no VPC creation needed)
- `assign_public_ip = true` on the ECS service avoids needing a NAT gateway
- Credentials are **temporary** — update `AWS_SESSION_TOKEN` in GitHub secrets each KodeKloud session
- `force_delete = true` on the ECR repo enables clean `terraform destroy`

## Finding the running container's public IP

After deploy, the task IP is not in Terraform outputs (it's assigned at runtime). To find it:

```bash
# 1. Get the task ARN
aws ecs list-tasks --cluster hello-fargate --region us-east-1

# 2. Get the ENI attachment
aws ecs describe-tasks --cluster hello-fargate --tasks <task-arn> --region us-east-1

# 3. Get the public IP from the ENI
aws ec2 describe-network-interfaces --network-interface-ids <eni-id> --region us-east-1 \
  --query 'NetworkInterfaces[0].Association.PublicIp' --output text
```
