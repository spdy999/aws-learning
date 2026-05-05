# aws-learning

Learning repo for AWS services using Terraform + GitHub Actions.

## Structure

Each top-level directory covers one AWS service:

| Directory | Service | Description |
|-----------|---------|-------------|
| `fargate/` | ECS Fargate | Containerized nginx app with ECR |
| `vpc/` | VPC | Custom VPC with IGW, public subnet, and route table |

## Usage

Each service has its own pipeline that triggers on pushes to `main` touching its directory. Pipelines can also be run manually from the Actions tab with `destroy=true` to tear down resources.

## GitHub Actions secrets/variables

| Name | Type | Description |
|------|------|-------------|
| `AWS_ACCESS_KEY_ID` | Secret | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Secret | AWS secret key |
| `AWS_SESSION_TOKEN` | Secret | Session token (temp credentials) |
| `TF_STATE_BUCKET` | Variable | S3 bucket for Terraform state |
