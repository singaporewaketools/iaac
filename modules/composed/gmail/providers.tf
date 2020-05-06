provider "aws" {
  region = var.aws_region
  version = "~> 2.50"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  # The latest version of Terragrunt (v0.19.0 and above) requires Terraform 0.12.0 or above.
  # Additionaly, these modules use for_each resource configuration introduced with Terraform 0.12.6 and above
  required_version = ">= 0.12.6"
}
