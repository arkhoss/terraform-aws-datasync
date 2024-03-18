### Terragrunt Basic Example
```
terraform {
  source = "git::git@github.com:arkhoss/terraform-aws-datasync.git//.?ref=1.0.0"
}

inputs = {

  tags = local.tags
}
```
