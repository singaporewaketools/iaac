# Modules

To keep our environments DRY, all infra is instantiated from these modules - currently we are not versioning the modules for staged roll-outs of changes from non-prod to prod. In the future, this directory should be managed in a separate repository with a CI pipeline publishing versioned modules.

## Basic

Basic Modules are the building blocks for our all the different environments in our infrastructe. These modules do not define providers or backend configuration as they are composed into larger infrastructure pieces, inheriting all Terraform providers from there.

## Composed

These are the actual infrastructure templates used to create the different environments. These modules have placeholders for providers and backend configuration for Terragrunt to fill in.

These modules directly relate to state files, still keeping them small reduces impact of changes, and these can define inter dependencies managed by Terragrunt.
