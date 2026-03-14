# Renamed to force a fresh request after DNS propagation
resource "aws_acm_certificate" "discovr" {
  count = var.domain_name == "" ? 0 : 1

  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.name_prefix}-cert"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = (var.domain_name == "" || var.route53_zone_id == "") ? {} : {
    for dvo in aws_acm_certificate.discovr[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "discovr" {
  count = var.domain_name == "" ? 0 : 1

  certificate_arn         = aws_acm_certificate.discovr[0].arn
  validation_record_fqdns = [for dvo in aws_acm_certificate.discovr[0].domain_validation_options : dvo.resource_record_name]
}
