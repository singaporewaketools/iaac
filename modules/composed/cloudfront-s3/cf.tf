resource "aws_cloudfront_distribution" "s3" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "s3 distribution"
  price_class         = var.price_class
 
  aliases = var.urls

  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = local.id #  A unique identifier for the origin (used in routes / caching)

    # s3 should not be configured as website endpoint, else must use custom_origin_config
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site.cloudfront_access_identity_path
    }
  }
  
  default_root_object = "index.html"

  # handle pushState via index.html
  # any GET for a non-existing URL gets handled through index.html
  custom_error_response {
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300 # the default
  }

  custom_error_response {
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300 # the default
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site.arn
    ssl_support_method  = "sni-only"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.id
    compress         = true                    # NOTE: this removes eTag header though

    forwarded_values {
      query_string = false

      # doesn't apply for s3 according to AWS docs, but required by terraform provider
      cookies {
        forward           = "none" # for s3, forwarding cookies would reduce cacheability - set to none for s3 origins
      }
    }

    viewer_protocol_policy = "redirect-to-https" # One of allow-all, https-only, or redirect-to-https
    # # The default amount of time (in seconds) 
    # default_ttl            = "86400"     # Defaults to 1 day
    # min_ttl                = "0"         # Defaults to 0 seconds.
    # max_ttl                = "31536000"  # Defaults to 365 days.
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.tags
  depends_on = [
    aws_acm_certificate_validation.site,
  ]
}

resource "aws_route53_record" "site" {
  for_each = toset(var.urls)
  zone_id  = data.aws_route53_zone.zone.id
  name     = each.key
  type     = "A"
  alias {
     name    = aws_cloudfront_distribution.s3.domain_name
     zone_id = aws_cloudfront_distribution.s3.hosted_zone_id
     evaluate_target_health = true
  }
}
