locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
    Name      = local.id
    Namespace = var.namespace
    Stage     = var.stage
  }
}

data "aws_caller_identity" "current" {}