aws_region   = "ap-south-1"
project_name = "discovr"
environment  = "prod"

availability_zones = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs = ["10.42.1.0/24", "10.42.2.0/24"]

backend_domain  = "api.discovr.ai"
ai_domain       = "ai.discovr.ai"
frontend_domain = "discovr.ai"
admin_domain    = "admin.discovr.ai"

# Optional: set to your public hosted zone ID to auto-create DNS records
route53_zone_id = ""

# Tag that was pushed to ECR for each service image
service_image_tags = {
  backend  = "latest"
  ai       = "latest"
  frontend = "latest"
  admin    = "latest"
}

# Add runtime env vars per service (examples below)
backend_env = {
  MONGO_URI              = "mongodb+srv://..."
  MONGO_DATABASE         = "discovr"
  FIREBASE_CREDENTIALS   = "USE_DEFAULT"
  FIREBASE_WEB_API_KEY   = "..."
  FIREBASE_STORAGE_BUCKET = "..."
  PUBLIC_BASE_URL        = "https://api.discovr.ai"
  YOUTUBE_CLIENT_ID      = "..."
  YOUTUBE_CLIENT_SECRET  = "..."
  INSTAGRAM_CLIENT_ID    = "..."
  INSTAGRAM_CLIENT_SECRET = "..."
  AI_SERVICE_API_KEY     = "shared-secret"
}

ai_env = {
  OPENROUTER_API_KEY = "..."
  MONGODB_URI        = "mongodb+srv://..."
  MONGODB_DATABASE   = "discovr_ai"
  REDIS_URL          = "redis://..."
  AI_SERVICE_API_KEY = "shared-secret"
}

frontend_env = {
  VITE_API_URL = "https://api.discovr.ai"
}

admin_env = {
  NEXT_PUBLIC_API_URL = "https://api.discovr.ai"
}
