resource "aws_lb" "main" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for s in aws_subnet.public : s.id]

  tags = {
    Name = "${local.name_prefix}-alb"
  }
}

resource "aws_lb_target_group" "service" {
  for_each = local.services

  name        = substr("${local.name_prefix}-${each.key}-tg", 0, 32)
  port        = each.value.port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = each.value.health_path
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.domain_name == "" ? "fixed-response" : "redirect"

    dynamic "fixed_response" {
      for_each = var.domain_name == "" ? [1] : []
      content {
        content_type = "text/plain"
        message_body = "Host not configured"
        status_code  = "404"
      }
    }

    dynamic "redirect" {
      for_each = var.domain_name == "" ? [] : [1]
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.domain_name == "" ? 0 : 1

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.discovr[0].arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Host not configured"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "service_host" {
  for_each = local.services

  listener_arn = var.domain_name == "" ? aws_lb_listener.http.arn : aws_lb_listener.https[0].arn
  priority     = each.value.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.domain]
    }
  }
}

