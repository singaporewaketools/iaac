data "aws_route53_zone" "main" {
    name = var.domain
}

# # google domain set up
# resource "aws_route53_record" "site_verification" {
#   zone_id = data.aws_route53_zone.main.id
#   name    = ""
#   type    = "TXT"

#   records = [
#    var.ssite_verification,
#   ]

#   ttl = "300"
# }

# host -t mx google.com ~ or verify google suite admin - recommended priority
resource "aws_route53_record" "gmail" {
  zone_id = data.aws_route53_zone.main.id
  name    = ""
  type    = "MX"

  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
  ]

  ttl = "300"
}

resource "aws_route53_record" "google_suite_cnames" {
  for_each = var.google_suite_cnames
  zone_id  = data.aws_route53_zone.main.id
  name     = each.key
  type     = "CNAME"
  records  = ["ghs.googlehosted.com"]
  ttl      = "300"
}
