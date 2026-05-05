variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name used for all resources"
  type        = string
  default     = "hello-fargate"
}

variable "image_tag" {
  description = "Docker image tag to deploy (injected by CI as the git SHA)"
  type        = string
  default     = "latest"
}
