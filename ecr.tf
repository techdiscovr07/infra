resource "aws_ecr_repository" "service" {
  for_each = local.services

  name                 = "${var.project_name}/${each.value.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${local.name_prefix}-${each.key}-ecr"
  }
}
