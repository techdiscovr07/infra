locals {
  name_prefix = "${var.project_name}-${var.environment}"

  services = {
    backend = {
      name         = "discovr-backend"
      port         = 8080
      health_path  = "/health"
      domain       = var.backend_domain
      rule_priority = 10
    }
    ai = {
      name         = "discovr-ai-service"
      port         = 8000
      health_path  = "/health"
      domain       = var.ai_domain
      rule_priority = 20
    }
    frontend = {
      name         = "discovr-frontend"
      port         = 80
      health_path  = "/"
      domain       = var.frontend_domain
      rule_priority = 30
    }
    admin = {
      name         = "discovr-admin"
      port         = 3000
      health_path  = "/"
      domain       = var.admin_domain
      rule_priority = 40
    }
  }

  service_env = {
    backend = merge(
      {
        SERVER_PORT    = "8080"
        AI_SERVICE_URL = "https://${var.ai_domain}"
      },
      var.backend_env
    )
    ai = merge(
      {
        PORT = "8000"
      },
      var.ai_env
    )
    frontend = merge(
      {
        VITE_API_URL = "https://${var.backend_domain}"
      },
      var.frontend_env
    )
    admin = merge(
      {
        NEXT_PUBLIC_API_URL = "https://${var.backend_domain}"
      },
      var.admin_env
    )
  }
}
