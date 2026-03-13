resource "aws_route53_record" "service" {
  for_each = var.route53_zone_id == "" ? {} : local.services

  zone_id = var.route53_zone_id
  name    = each.value.domain
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
