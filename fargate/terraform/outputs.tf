output "ecr_repository_url" {
  description = "Push images here: docker push <url>:<tag>"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "task_public_ip_hint" {
  description = "After deploy, find the task public IP in ECS console > cluster > tasks > networking"
  value       = "aws ecs list-tasks --cluster ${aws_ecs_cluster.main.name} --region ${var.aws_region}"
}
