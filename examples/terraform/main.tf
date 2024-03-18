module "datasync" {
  source = "git::git@github.com:arkhoss/terraform-aws-datasync.git//.?ref=1.0.0"

  tags = local.tags
}
