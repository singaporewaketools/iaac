terraform {
  source = "../../../modules//composed/account-base"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_secret_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("common_secret_vars.yaml")}"))
  common_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("common_vars.yaml")}"))
}

inputs = {
  namespace          = "swt"
  stage              = "svc"
  name               = "main"
  public_zones       = {}
  billing_threshhold = 400 #USD

  billing_subscriptions = local.common_secret_vars.billing_subscriptions
}
