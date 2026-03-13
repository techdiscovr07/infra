output "alb_dns_name" {
  description = "Public DNS name of the application load balancer"
  value       = aws_lb.main.dns_name
}

output "ecr_repository_urls" {
  description = "ECR repositories for backend, ai, frontend, admin"
  value = {
    for key, repo in aws_ecr_repository.service : key => repo.repository_url
  }
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_names" {
  description = "ECS service names by key"
  value = {
    for key, svc in aws_ecs_service.service : key => svc.name
  }
}
