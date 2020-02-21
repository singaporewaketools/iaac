resource "aws_s3_bucket" "site" {
  acl           = "private"
  bucket        = local.id
  tags          = local.tags
  force_destroy = "true"
  
  lifecycle {
    create_before_destroy = "true"
  }
}

# Restrict S3 access to CloudFront using an origin_access_identity
resource "aws_cloudfront_origin_access_identity" "site" {
  comment = "${local.id} access identity"
}

data "aws_iam_policy_document" "site_cf_origin" {
  statement {
    actions   = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.site.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.site.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.site.arn,
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.site.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site_cf_origin" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site_cf_origin.json
}
