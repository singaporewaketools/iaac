resource "aws_route53_zone" "public_zones" {
  for_each = var.public_zones
  name     = each.key

  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-${each.key}"
    )
  )
}

data "aws_vpc" "default" {
  default = "true"
}

data "aws_route53_zone" "parents" {
  for_each = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.parent) > 0
  }
  name = each.value.parent
}

resource "aws_route53_record" "parent_ns" {
  for_each = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.parent) > 0
  }

  zone_id = data.aws_route53_zone.parents[each.key].zone_id
  name    = each.key
  type    = "NS"
  ttl     = "900"

  records = aws_route53_zone.public_zones[each.key].name_servers
}

