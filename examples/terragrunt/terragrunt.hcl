locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  product_vars = read_terragrunt_config(find_in_parent_folders("product.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  product      = local.product_vars.locals.product_name
  prefix       = local.product_vars.locals.prefix
  account      = local.account_vars.locals.account_id
  env          = local.env_vars.locals.env

  tags = merge(
    local.env_vars.locals.tags,
    local.additional_tags
  )

  additional_tags = {
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:arkhoss/terraform-aws-datasync.git//.?ref=1.0.0"
}

inputs = {

  tags = local.tags
}
