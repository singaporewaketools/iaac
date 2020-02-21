terraform {
  source = "../../../modules//composed/cloudfront-s3"
}

include {
  path = find_in_parent_folders()
}
locals {
  dns_zone = "swt.ninja"

  urls = [
  "files.${local.dns_zone}",
  ]
}

inputs = {
  namespace = "swt"
  stage     = "prod"
  name      = "files"
  
  dns_zone = local.dns_zone
  urls     = local.urls
}
