[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

![Terraform](https://cloudarmy.io/tldr/images/tf_aws.jpg)
<br>
<br>
<br>
<br>
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/arkhoss/terraform-aws-datasync?color=lightgreen&label=latest%20tag%3A&style=for-the-badge)
<br>
<br>
# terraform-aws-datasync


Terraform module to create [Amazon DataSync](https://aws.amazon.com/datasync) resources.

AWS DataSync is an online data movement and discovery service that simplifies data migration and helps you quickly, easily, and securely transfer your file or object data to, from, and between AWS storage services..
<br>

## Module Capabilities
  * Create... <!-- TODO(dcaballero): add cap here -->
<br>

## Architecture Example
![](assets/image.png)

## Assumptions
  * Public API Scenario
  * Create... <!-- TODO(dcaballero): add assumption here -->
<br>

## Usage
  * some here
    ```
    aws_datasync_*
    ```
<br>

## Special Notes

### Terraform Basic Example
```
module "this" {
  source = "git::git@github.com:arkhoss/terraform-aws-datasync.git//.?ref=1.0.7"


inputs = {

  tags = local.tags
}
```
### Terragrunt Basic Example
```
terraform {
  source = "git::git@github.com:arkhoss/terraform-aws-datasync.git//.?ref=1.0.7"
}

inputs = {

  tags = local.tags
}
```

## Supporting Articles & Documentation
  - Create... <!-- TODO(dcaballero): add assumption here -->

<!-- DO NOT REMOVE THE LINE BELOW  Self generated TF DOCS -->
<!-- Generated with https://github.com/terraform-docs/terraform-docs -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |
| <a name="requirement_terragrunt"></a> [terragrunt](#requirement\_terragrunt) | >= 0.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|

## Outputs

| Name | Description |
|------|-------------|

<!-- END_TF_DOCS -->
