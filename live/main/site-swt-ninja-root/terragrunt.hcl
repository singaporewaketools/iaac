terraform {
  source = "../../../modules//composed/cloudfront-s3"
}

include {
  path = find_in_parent_folders()
}
locals {
  dns_zone = "swt.ninja"

  urls = [
  "${local.dns_zone}",
  "www.${local.dns_zone}",
  ]
}

inputs = {
  namespace = "swt"
  stage     = "prod"
  name      = "root"
  
  dns_zone = local.dns_zone
  urls     = local.urls
}
