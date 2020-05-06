terraform {
  source = "../../../modules//composed/gmail"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain = "namdo-sourcing.com"
}
