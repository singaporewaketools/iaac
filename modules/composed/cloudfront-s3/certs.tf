
data "aws_route53_zone" "zone" {
  name         = "${var.dns_zone}." # interpolated to suffix "."
  private_zone = false
}

resource "aws_acm_certificate" "site" {
  provider                  = aws.cf
  domain_name               = var.urls[0]
  subject_alternative_names = slice(var.urls, 1, length(var.urls))
  validation_method         = "DNS"
  tags                      = local.tags
}

resource "aws_acm_certificate_validation" "site" {
  provider                = aws.cf
  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [ for value in aws_route53_record.cert_validation: value.fqdn ]
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.cf
  for_each = { for domain_validation_option in aws_acm_certificate.site.domain_validation_options:
    domain_validation_option.domain_name => domain_validation_option
  }
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  zone_id  = data.aws_route53_zone.zone.id
  records  = [
    each.value.resource_record_value
  ]
  ttl      = 60
}
