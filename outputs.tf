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

output "acm_validation_records" {
  description = "DNS records to create for ACM certificate validation"
  value = var.domain_name == "" ? null : [
    for dvo in aws_acm_certificate.discovr[0].domain_validation_options : {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  ]
}

