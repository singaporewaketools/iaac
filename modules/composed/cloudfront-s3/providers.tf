provider "aws" {
  region = var.aws_region
  version = "~> 2.50"
}

# CloudFront ACM certificate must be in US-EAST-1
# https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#viewer-certificate-arguments)
provider "aws" {
  version = "~> 2.50"
  region = "us-east-1"
  alias = "cf"
}

provider "external" {
  version = "~> 1.2"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  # The latest version of Terragrunt (v0.19.0 and above) requires Terraform 0.12.0 or above.
  # Additionaly, these modules use for_each resource configuration introduced with Terraform 0.12.6 and above
  required_version = ">= 0.12.6"
}